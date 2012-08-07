//
//  ru.kolyvan.repo
//  https://github.com/kolyvan
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
#import "KxList.h"
#import "KxMacros.h"
#import "KxArc.h"

#ifdef __IPHONE_OS_VERSION_MAX_ALLOWED
#include <sys/xattr.h>
#endif

static NSString * completeErrorMessage (NSError * error) 
{    
    NSMutableString *message = [[NSString stringWithFormat:@"%@ (%@/%ld)", 
                                 [error localizedDescription], 
                                 [error domain], 
                                 [error code]] mutableCopy];
    
    NSDictionary *userInfo;
    
    while ((userInfo = [error userInfo]) && 
           (error = [userInfo objectForKey:NSUnderlyingErrorKey])) {
        
        NSString * s = [NSString stringWithFormat:@"%@ (%@/%ld)", 
                        [error localizedDescription], 
                        [error domain], 
                        [error code]];
        
        [message appendString:@"\n"];
        [message appendString:s];
    }
    
    return message;
}

static NSFileManager * fileManager() 
{
    NSFileManager *fm = [[NSFileManager alloc] init];
    return KX_AUTORELEASE(fm);
}

static BOOL fileExists(NSString *filepath)
{    
    NSFileManager *fm = [[NSFileManager alloc] init];    
    BOOL exists = [fm fileExistsAtPath:filepath];    
    KX_RELEASE(fm);
    return exists;
}

static NSError * ensureDirectory(NSString * path) 
{
    NSFileManager * fm = fileManager();    

    if ([fm fileExistsAtPath:path])
        return nil;
    
    NSError * KX_AUTORELEASING error = nil;
    [fm createDirectoryAtPath:path
  withIntermediateDirectories:YES 
                   attributes:nil 
                        error:&error];        

#ifdef DEBUG    
    if (error)
        NSLog(@"failed in %s - %@", __PRETTY_FUNCTION__, completeErrorMessage(error));
#endif    
    return error;
    
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

    ensureDirectory(path);
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
    
    ensureDirectory(path);
    return path;    
}

static NSString * offlineDataPath()
{
    NSString *path = [privateDataPath() stringByAppendingPathComponent:@"Offline Data"];
    ensureDirectory(path);
        
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



///// 


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

static NSArray * array (id first, ...)
{
    va_list args;    
    va_start(args, first);
    
    NSMutableArray* result = [NSMutableArray array];  
    for (id p = first; p != nil; p = va_arg(args, id))
        [result addObject:p];
    va_end(args);

    return [NSArray arrayWithArray:result];
}

static NSDictionary* dictionary(id firstObj, ...) 
{    
    va_list args;    
    va_start(args, firstObj);
    
    NSMutableArray* current = [NSMutableArray array];
    NSMutableArray* next = [NSMutableArray array];        
    
    for (id p = firstObj; p != nil; p = va_arg(args, id)) {
        [current addObject:p];
        // swap
        NSMutableArray *t = current;
        current = next;
        next = t;
    }
    va_end(args);

    return [NSDictionary dictionaryWithObjects:current forKeys:next];
};


static NSString * format (NSString * fmt, ...) 
{
    va_list args;    
    va_start(args, fmt);
    NSString * s = [[NSString alloc] initWithFormat:fmt arguments:args];
    va_end(args);
    return KX_AUTORELEASE(s);
};

static KxTuple2 * tuple(id first, id second)
{
    return [KxTuple2 first: first second: second];
}

static KxList* list(id head, ...)
{
    va_list args;    
    va_start(args, head);    
    
    NSMutableArray * b = [NSMutableArray array];
    for (id p = head; p != nil; p = va_arg(args, id)) {    
        [b addObject:p];
    }
    va_end(args);
    
    return [KxList fromArray:b];
}

////

KxUtils_t KxUtils = {
    fileManager,
    fileExists,
    ensureDirectory,    
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
    completeErrorMessage,
    
    //
    array,
    dictionary,
    format,     
    tuple,
    list,
};

