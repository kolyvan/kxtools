//
//  ru.kolyvan.repo
//  https://github.com/kolyvan
//  

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import <Foundation/Foundation.h>


//// arc

#if __has_feature(objc_arc)

    #define KX_RETAIN(x)            (x)
    #define KX_RELEASE(x)
    #define KX_AUTORELEASE(x)       (x)
    #define KX_SAFE_RELEASE(xx)     { xx = nil; }
    #define KX_SUPER_DEALLOC()

    #define KX_PROP_STRONG strong

    #if __has_feature(objc_arc_weak)

        #define KX_PROP_WEAK weak
        #define KX_WEAK __weak
        #define KX_BLOCK __weak

    #else

        #define KX_PROP_WEAK unsafe_unretained
        #define KX_WEAK __unsafe_unretained
        #define KX_BLOCK __unsafe_unretained

    #endif

    #define KX_AUTORELEASING __autoreleasing
    #define KX_UNSAFE_UNRETAINED __unsafe_unretained

    #define KX_AUTORELEASE_POOL_BEGIN() @autoreleasepool {
    #define KX_AUTORELEASE_POOL_END() }

#else

    #define KX_RETAIN(x)            ([(x) retain])
    #define KX_RELEASE(x)           ([(x) release])
    #define KX_AUTORELEASE(x)       ([(x) autorelease])
    #define KX_SAFE_RELEASE(xx)     { [xx release]; xx = nil; }
    #define KX_SUPER_DEALLOC()      ([super dealloc])

    #define KX_PROP_STRONG retain
    #define KX_PROP_WEAK assign
    #define KX_WEAK 
    #define KX_BLOCK __block
    #define KX_AUTORELEASING
    #define KX_UNSAFE_UNRETAINED

    #define KX_AUTORELEASE_POOL_BEGIN() NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    #define KX_AUTORELEASE_POOL_END()   [pool drain];

#endif

//#if ! __has_feature(objc_arc)
//#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
//#endif

