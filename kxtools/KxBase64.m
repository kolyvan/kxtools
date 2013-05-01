//
//  ru.kolyvan.kxtools
//  https://github.com/kolyvan/kxtools
//

//  Copyright (C) 2012-2013, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


//
//  base64 encoder\decoder taken from:
//
// Copyright 2003-2009 Christian d'Heureuse,
// Inventec Informatik AG, Zurich, Switzerland
// www.source-code.biz, www.inventec.ch/chdh
//
// This module is multi-licensed and may be used under the terms
// of any of the following licenses:
//
//  EPL, Eclipse Public License, http://www.eclipse.org/legal
//  LGPL, GNU Lesser General Public License,
//    http://www.gnu.org/licenses/lgpl.html
//  AL, Apache License, http://www.apache.org/licenses
//  BSD, BSD License, http://www.opensource.org/licenses/bsd-license.php
//
//

#import "KxBase64.h"

static NSData * base64encode(NSData * from)
{
    static uint8_t const map[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
    
    NSUInteger length = [from length];
    NSUInteger dataLen = (length * 4 + 2) / 3;       // output length without padding
    NSMutableData *mdata = [NSMutableData dataWithLength:((length + 2) / 3) * 4]; // output length including padding
    
    uint8_t *input = (uint8_t *)[from bytes];
    uint8_t *output = (uint8_t *)[mdata mutableBytes];
    
    int ip = 0, op = 0;
    
    while (ip < length) {
        
        int i0, i1, i2;
        
        i0 = input[ip] & 0xff;
        ip += 1;
        
        if (ip < length) i1 = input[ip] & 0xff; else i1 = 0;
        ip += 1;
        
        if (ip < length) i2 = input[ip] & 0xff; else i2 =  0;
        ip += 1;
        
        int o0 = i0 >> 2;
        int o1 = ((i0 &   3) << 4) | (i1 >> 4);
        int o2 = ((i1 & 0xf) << 2) | (i2 >> 6);
        int o3 = i2 & 0x3F;
        
        output[op] = map[o0];
        op += 1;
        
        output[op] = map[o1];
        op += 1;
        
        if (op < dataLen) output[op] = map[o2]; else output[op] = '=';
        op += 1;
        
        if (op < dataLen) output[op] = map[o3]; else output[op] = '=';
        op += 1;
    }
    
    return mdata;
}

#define xx 65

static NSData * base64decode (NSData * from)
{
    static uint8_t const map[256] =
    {
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, 62, xx, xx, xx, 63,
        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, xx, xx, xx, xx, xx, xx,
        xx,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
        15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, xx, xx, xx, xx, xx,
        xx, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
        41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
        xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx, xx,
    };
    
    
    NSInteger length = [from length];
    if (length % 4 != 0)
        @throw [NSException
                exceptionWithName:@"NSDataBase64decodeException"
                reason:@"Length of Base64 encoded input string is not a multiple of 4."
                userInfo:nil];
    
    
    uint8_t *input = (uint8_t *)[from bytes];
    
    while (length > 0 && input[length - 1] == '=')
        length -= 1;
    
    NSInteger outLen = (length * 3) / 4;
    
    NSMutableData *mdata = [NSMutableData dataWithLength: outLen];
    uint8_t *output = (uint8_t *)[mdata mutableBytes];
    
    int ip = 0, op = 0;
    
    while (ip < length) {
        
        int i0, i1, i2, i3;
        
        i0 = input[ip];
        ip += 1;
        
        i1 = input[ip];
        ip += 1;
        
        if (ip < length) i2 = input[ip]; else i2 = 'A';
        ip += 1;
        
        if (ip < length) i3 = input[ip]; else i3 = 'A';
        ip += 1;
        
        
        if (i0 > 127 || i1 > 127 || i2 > 127 || i3 > 127)
            @throw [NSException
                    exceptionWithName:@"NSDataBase64decodeException"
                    reason:@"Illegal character in Base64 encoded data."
                    userInfo:nil];
        
        
        int b0 = map[i0];
        int b1 = map[i1];
        int b2 = map[i2];
        int b3 = map[i3];
        
        if (b0 == xx || b1 == xx || b2 == xx || b3 == xx)
            @throw [NSException
                    exceptionWithName:@"NSDataBase64decodeException"
                    reason:@"Illegal character in Base64 encoded data."
                    userInfo:nil];
        
        
        int o0 = ( b0       <<2) | (b1>>4);
        int o1 = ((b1 & 0xf)<<4) | (b2>>2);
        int o2 = ((b2 &   3)<<6) |  b3;
        
        output[op] = o0;
        op += 1;
        
        if (op < outLen) { output[op] = o1; op +=1; }
        if (op < outLen) { output[op] = o2; op +=1; }
    }
    
    return mdata;
}

@implementation NSData (BASE64)

+ (NSData *) dataFromBase64String:(NSString *)string
{
    NSData * base64 = [NSData dataWithBytes:[string UTF8String]
                                     length:[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];
    return base64decode(base64);
    
}

- (NSString *) base64EncodedString
{
    return [[NSString alloc] initWithData:base64encode(self) encoding:NSASCIIStringEncoding];
}


- (NSData *) base64encode
{
    return base64encode(self);
}

- (NSData *) base64decode
{
    return base64decode(self);    
}

@end

@implementation NSString (BASE64)

- (NSString *) base64encode
{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    return [data base64EncodedString];
}

- (NSString *) base64decode
{
    NSData *data = [NSData dataFromBase64String: self];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end