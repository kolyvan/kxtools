//
//  ru.kolyvan.kxtools
//  https://github.com/kolyvan/kxtools
//

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import <Foundation/Foundation.h>

typedef void (^KxUtilsEnumerateItemsBlock)(NSFileManager *fm, NSString *path, NSDictionary *attr);

typedef struct {
    
    // file managers
        
    BOOL (*fileExists)(NSString *path); 
    BOOL (*ensureDirectory)(NSString * path, NSError **perror);
    BOOL (*saveObjectAsJson)(id object, NSString *path, NSError **perror);
    id (*loadObjectFromJson)(NSString *path, NSError **perror);
    void (*enumerateItemsAtPath)(NSString *path, BOOL subDirs, KxUtilsEnumerateItemsBlock block);
    NSArray * (*filesAsPath)(NSString *path);
    
#ifndef __IPHONE_OS_VERSION_MAX_ALLOWED
    NSString * (*appBundleID)();
#endif
    
    // pathes
    
    NSString * (*appPath)(); 
    NSString * (*resourcePath)();
    NSString * (*desktopPath)();
    NSString * (*publicDataPath)();
    NSString * (*privateDataPath)();
    NSString * (*cacheDataPath)();
    NSString * (*offlineDataPath)();
    NSString * (*temporaryDataPath)();
    
    NSString * (*pathForPublicFile)(NSString * file);
    NSString * (*pathForPrivateFile)(NSString * file);
    NSString * (*pathForCacheFile)(NSString * file);
    NSString * (*pathForOfflineFile)(NSString * file);
    NSString * (*pathForTemporaryFile)(NSString * file);
    NSString * (*pathForResource)(NSString * file);
    
    //    
    
    void (*waitRunLoop)(NSTimeInterval secondsToWait, NSTimeInterval interval, BOOL (^condition)(void));
    
    //
    
    NSString * (*errorMessage)(NSError *error);
    NSString * (*completeErrorMessage)(NSError *error);
    
    
} KxUtils_t;

extern KxUtils_t KxUtils;

