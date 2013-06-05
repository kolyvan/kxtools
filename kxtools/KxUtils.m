//
//  ru.kolyvan.kxtools
//  https://github.com/kolyvan/kxtools
//

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


//
// Some code and ideas was taken from following projects, thank you.

//
//  StandardPaths
//  Created by Nick Lockwood on 10/11/2011.
//  Copyright (C) 2012 Charcoal Design
//
//  Distributed under the permissive zlib License
//  Get the latest version from either of these locations:
//
//  http://charcoaldesign.co.uk/source/cocoa#standardpaths
//  https://github.com/nicklockwood/StandardPaths
//

//
// ConciseKit
// Copyright (c) 2010-2012 Peter Jihoon Kim and contributors
// https://github.com/petejkim/ConciseKit
// This code is licensed under the MIT License.
// 

#import "KxUtils.h"
#import "KxTuple2.h"

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#include <sys/xattr.h>
#endif

static NSString * errorMessage (NSError *error)
{
    NSString *reason = error.localizedFailureReason;
    if (reason.length) {
        return [NSString stringWithFormat:@"%@ (%@/%ld) reason: %@",
                error.localizedDescription, error.domain, (long)error.code, reason];
    } else {
        return [NSString stringWithFormat:@"%@ (%@/%ld)",
                error.localizedDescription, error.domain, (long)error.code];
    }
}

static NSString * completeErrorMessage (NSError * error)
{
    NSMutableString *message = [errorMessage(error) mutableCopy];
        
    NSDictionary *userInfo;
    
    while ((userInfo = [error userInfo]) && 
           (error = [userInfo objectForKey:NSUnderlyingErrorKey])) {
        
        [message appendString:@"\n  "];
        [message appendString:errorMessage(error)];
    }
    
    return message;
}

static BOOL fileExists(NSString *path)
{
    NSCAssert(path.length, @"empty path");    
    NSFileManager *fm = [[NSFileManager alloc] init];    
    return [fm fileExistsAtPath:path];
}

static BOOL ensureDirectory(NSString *path, NSError **perror)
{
    NSCAssert(path.length, @"empty path");
    
    NSFileManager *fm = [[NSFileManager alloc] init];
    if ([fm fileExistsAtPath:path])
        return YES;
    
    return [fm createDirectoryAtPath:path
         withIntermediateDirectories:YES
                          attributes:nil
                               error:perror];
}

static BOOL saveObjectAsJson(id object, NSString * path, NSError **pError)
{
    NSCParameterAssert(object);
    NSCParameterAssert(path.length);
    
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object
                                                   options:NSJSONWritingPrettyPrinted
                                                     error:&error];
    if (!data) {
        
        if (pError) *pError = error;
        NSLog(@"unable make json from %@, %@", object, error.localizedDescription);
        return NO;
    }
    
    if (![data writeToFile:path options:0 error:pError]) {
        
        if (pError) *pError = error;
        NSLog(@"unable save json at %@, %@", path, error.localizedDescription);
        return NO;
    }
    
    return YES;
}


static id loadObjectFromJson(NSString * path, NSError **pError)
{
    NSCParameterAssert(path.length);
    
    NSFileManager *fm = [[NSFileManager alloc] init];
    if (![fm isReadableFileAtPath:path])
        return nil;
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (!data) {
        
        if (pError) *pError = error;
        NSLog(@"unable load data from %@, %@", path, error.localizedDescription);
        return nil;
    }
    
    if (!data.length)
        return [NSNull null];
    
    id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (!object) {
        
        if (pError) *pError = error;
        NSLog(@"unable make object from json, %@", error.localizedDescription);
        return NO;
    }
    
    return object;
}

static void enumerateItemsAtPath(NSString *path,
                                 BOOL subDirs,
                                 KxUtilsEnumerateItemsBlock block)
{
    NSCAssert(path.length, @"empty path");
    NSCAssert(block, @"nil block");
    
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSArray *contents = [fm contentsOfDirectoryAtPath:path error:nil];
        
    for (NSString *filename in contents) {
        
        if (filename.length && [filename characterAtIndex:0] != '.') {
            
            NSString *fullpath = [path stringByAppendingPathComponent:filename];
            NSDictionary *attr = [fm attributesOfItemAtPath:fullpath error:nil];
            
            id fileType = [attr fileType];
            
            if ([fileType isEqual: NSFileTypeRegular]) {
                
                block(fm, fullpath, attr);
                
            } else if (subDirs && [fileType isEqual: NSFileTypeDirectory]) {
                
               enumerateItemsAtPath(fullpath, subDirs, block);
            }
        }
    }
}

static NSArray *filesAsPath(NSString *path)
{
    NSCAssert(path.length, @"empty path");
    
    NSFileManager *fm = [[NSFileManager alloc] init];
    NSArray *contents = [fm contentsOfDirectoryAtPath:path error:nil];        
    NSMutableArray *ma = [NSMutableArray array];
    
    for (NSString *filename in contents) {
        
        if (filename.length && [filename characterAtIndex:0] != '.') {
            
            NSString *fullpath = [path stringByAppendingPathComponent:filename];
            NSDictionary *attr = [fm attributesOfItemAtPath:fullpath error:nil];
            if ([attr.fileType isEqual: NSFileTypeRegular])
                [ma addObject:filename];
        }
    }
    
    return ma;
}


#ifndef __IPHONE_OS_VERSION_MAX_ALLOWED
static NSString * appBundleID()
{    
   // return [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    NSString * identifier = [[NSBundle mainBundle] bundleIdentifier];
    if (identifier)
        return identifier;    
    // [[NSProcessInfo processInfo] processName] 
    return [[[NSBundle mainBundle] executablePath] lastPathComponent]; 
}
#endif

static NSString * appPath() 
{
    return [[NSBundle mainBundle] bundlePath];
}

static NSString * resourcePath()
{
    return [[NSBundle mainBundle] resourcePath];
}

static NSString * desktopPath() 
{
    return [NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, 
                                                NSUserDomainMask, 
                                                YES) objectAtIndex:0];
}

static NSString * publicDataPath() 
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, 
                                                NSUserDomainMask, 
                                                YES) lastObject];
}

static NSString * privateDataPath() 
{
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, 
                                                          NSUserDomainMask, 
                                                          YES) lastObject];
            
#ifndef __IPHONE_OS_VERSION_MAX_ALLOWED    
    //append application name on Mac OS
    path = [path stringByAppendingPathComponent:appBundleID()];
            
#endif

    ensureDirectory(path, nil);
    return path;    
}

static NSString * cacheDataPath() 
{
   NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, 
                                                         NSUserDomainMask, 
                                                         YES) lastObject];
            
#ifndef __IPHONE_OS_VERSION_MAX_ALLOWED            
    //append application bundle ID on Mac OS
    path = [path stringByAppendingPathComponent:appBundleID()];
            
#endif
    
    ensureDirectory(path, nil);
    return path;    
}

static NSString * offlineDataPath()
{
    NSString *path = [privateDataPath() stringByAppendingPathComponent:@"Offline Data"];
    ensureDirectory(path, nil);
        
#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#ifdef __IPHONE_5_1
        
    if (& NSURLIsExcludedFromBackupKey && 
        [NSURL instancesRespondToSelector:@selector(setResourceValue:forKey:error:)])
    {
        //use iOS 5.1 method to exclude file from backp
        NSURL *URL = [NSURL fileURLWithPath:path isDirectory:YES];
        [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:NULL];
    }
    else            
#endif
        
    {
        //use the iOS 5.0.1 mobile backup flag to exclude file from backp
        u_int8_t b = 1;
        setxattr([path fileSystemRepresentation], "com.apple.MobileBackup", &b, 1, 0, 0);
    }
        
#endif
     
    return path;
}

static NSString * temporaryDataPath()
{
    NSString *path = NSTemporaryDirectory();
        
    //apparently NSTemporaryDirectory() can return nil in some cases
    if (!path)  {
        path = [cacheDataPath() stringByAppendingPathComponent:@"Temporary Files"];
    }
    
    return path;
}

static NSString * pathForPublicFile(NSString * file)
{
	return [publicDataPath() stringByAppendingPathComponent:file];
}

static NSString * pathForPrivateFile(NSString * file)
{
    return [privateDataPath() stringByAppendingPathComponent:file];
}

static NSString * pathForCacheFile(NSString * file)
{
    return [cacheDataPath() stringByAppendingPathComponent:file];
}

static NSString * pathForOfflineFile(NSString * file)
{
    return [offlineDataPath() stringByAppendingPathComponent:file];
}

static NSString * pathForTemporaryFile(NSString * file)
{
    return [temporaryDataPath() stringByAppendingPathComponent:file];
}

static NSString * pathForResource(NSString * file)
{
    return [resourcePath() stringByAppendingPathComponent:file];
}

////

static void waitRunLoop (NSTimeInterval secondsToWait, NSTimeInterval interval, BOOL (^condition)(void)) {
    
    NSTimeInterval time = 0;
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    
    while(1) {
        
        if (condition() || (time >= secondsToWait))
            return;
        
        [runLoop runUntilDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
        
        time += interval;
    }
}

////

static BOOL saveObjectAsPlist(id object, NSString * path, NSError **pError)
{
    NSCParameterAssert(object);
    NSCParameterAssert(path.length);
    
    NSError *error;
    NSData *data = [NSPropertyListSerialization dataWithPropertyList:object
                                                              format:NSPropertyListBinaryFormat_v1_0
                    // format:NSPropertyListXMLFormat_v1_0
                                                             options:0
                                                               error:&error];
    if (!data) {
        
        if (pError) *pError = error;
        NSLog(@"unable make plist from %@, %@", object, error.localizedDescription);
        return NO;
    }
    
    if (![data writeToFile:path options:0 error:pError]) {
        
        if (pError) *pError = error;
        NSLog(@"unable save plist at %@, %@", path, error.localizedDescription);
        return NO;
    }
    
    return YES;
}

static id loadObjectFromPlist(NSString * path, NSError **pError)
{
    NSCParameterAssert(path.length);
    
    NSFileManager *fm = [[NSFileManager alloc] init];
    if (![fm isReadableFileAtPath:path])
        return nil;
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (!data) {
        
        if (pError) *pError = error;
        NSLog(@"unable load data from %@, %@", path, error.localizedDescription);
        return nil;
    }
    
    if (!data.length)
        return [NSNull null];
    
    
    id object = [NSPropertyListSerialization propertyListWithData:data
                                                          options:NSPropertyListImmutable
                                                           format:nil
                                                            error:&error];
    
    if (!object) {
        
        if (pError) *pError = error;
        NSLog(@"unable make object from plist, %@", error.localizedDescription);
        return NO;
    }
    
    return object;
}

/////

KxUtils_t KxUtils = {

    fileExists,
    ensureDirectory,
    saveObjectAsJson,
    loadObjectFromJson,
    enumerateItemsAtPath,
    filesAsPath,
    
#ifndef __IPHONE_OS_VERSION_MAX_ALLOWED
    appBundleID,
#endif    
    appPath,
    resourcePath,
    desktopPath,
    publicDataPath,
    privateDataPath,
    cacheDataPath,
    offlineDataPath,
    temporaryDataPath,
    
    pathForPublicFile,
    pathForPrivateFile,
    pathForCacheFile,
    pathForOfflineFile,
    pathForTemporaryFile,
    pathForResource,
    
    //    
    waitRunLoop,
    
    //
    errorMessage,
    completeErrorMessage,
    
    //
    saveObjectAsPlist,
    loadObjectFromPlist,
    
};

