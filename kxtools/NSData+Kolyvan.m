//
//  ru.kolyvan.kxtools
//  https://github.com/kolyvan/kxtools
//

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import "NSData+Kolyvan.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSData (Kolyvan)

- (NSData *) sha1
{
    Byte digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1_CTX context;
    CC_SHA1_Init(&context);
    CC_SHA1_Update(&context, self.bytes, (CC_LONG)self.length);
    CC_SHA1_Final(digest, &context);
    
    return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

- (NSData *) md5
{
    Byte digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, digest);
    return [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];    
}

- (NSString *) toString
{
    NSMutableString *ms = [NSMutableString stringWithCapacity:self.length * 2];
    const Byte *p = self.bytes;
    for(int i = 0; i < self.length; i++)
        [ms appendFormat:@"%02x", p[i]];
    return [ms copy];
}

@end

