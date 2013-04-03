//
//  ru.kolyvan.kxtools
//  https://github.com/kolyvan/kxtools
//

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import "NSData+ZLIB.h"
#import <zlib.h>

@implementation NSData (ZLIB)

- (NSData *) gzip
{
    return [self gzipAsZlib: YES];
}

- (NSData *) gzipAsZlib: (BOOL) asZLib
{
    if (self.length == 0)
        return self;
    
    z_stream zs;
    
    zs.next_in = (Bytef *)self.bytes;
    zs.avail_in = (uInt)self.length;
    zs.total_out = 0;
    zs.avail_out = 0;
    zs.zalloc = Z_NULL;
    zs.zfree = Z_NULL;
    zs.opaque = Z_NULL;
    
    NSMutableData *deflated = [NSMutableData dataWithLength:16384];
    
    
    if (Z_OK != deflateInit2(&zs,
                             Z_DEFAULT_COMPRESSION,
                             Z_DEFLATED,
                             MAX_WBITS+(asZLib ? 0 : 16),
                             8,
                             Z_DEFAULT_STRATEGY))
        return nil;
    
    do {
        if (zs.total_out >= deflated.length)
            [deflated increaseLengthBy:16384];
        
        zs.next_out = deflated.mutableBytes + zs.total_out;
        zs.avail_out = (uInt)(deflated.length - zs.total_out);
        int status =  deflate(&zs, Z_FINISH);
        
        if (Z_OK != status &&
            Z_STREAM_END != status)
            return nil; // some error
        
    } while (0 == zs.avail_out);
    
    deflateEnd(&zs);
    deflated.length = zs.total_out;
    
    return deflated;
}

- (NSData *) gunzip
{
    NSUInteger halfLen = self.length / 2;
    
    NSMutableData *inflated = [NSMutableData dataWithLength:self.length + halfLen];
    
    z_stream zs;
    
    zs.next_in = (Bytef *)self.bytes;
    zs.avail_in = (uInt)self.length;
    zs.total_out = 0;
    zs.avail_out = 0;
    zs.zalloc = Z_NULL;
    zs.zfree = Z_NULL;
    zs.opaque = Z_NULL;
    
    if (Z_OK != inflateInit2(&zs, MAX_WBITS+32))
        return nil;
    
    int status = Z_OK;
    while (Z_OK == status) {
        
        if (zs.total_out >= inflated.length)
            [inflated increaseLengthBy:halfLen];
        
        zs.next_out = inflated.mutableBytes + zs.total_out;
        zs.avail_out = (uInt)(inflated.length - zs.total_out);
        
        status = inflate(&zs, Z_SYNC_FLUSH);
    }
    
    if ((Z_STREAM_END == status) &&
        (Z_OK == inflateEnd(&zs))) {
        
        inflated.length = zs.total_out;
        return inflated;
    }
    
    return nil;
}

@end
