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
// cocoa_helpers
// Created by Arthur Evstifeev
// github.com/ap4y/cocoa_helpers
// 

// 
// TapkuLibrary 
// Created by Devin Ross on 11/9/10.
// tapku.com || github.com/devinross/tapkulibrary
// TapkuLibrary is licensed under the MIT License. 
//

#import "NSString+Kolyvan.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (Kolyvan)

+ (NSString *) uniqueString
{
	CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (NSString* )CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return uuidString;
}

+ (NSString *) stringFromAsciiBytes: (NSData *) data
{
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

+ (NSString *) stringFromUtf8Bytes: (NSData *) data
{
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (unichar) first
{
    return [self characterAtIndex:0];
}

- (unichar) last
{
    NSInteger n =  MAX(0, (NSInteger)self.length - 1);
    return [self characterAtIndex:n];    
}

- (NSString *) tail
{
    return [self substringFromIndex: 1];
}

- (NSString *) butlast
{
    return [self substringToIndex: self.length - 1];        
}

- (NSString *) take: (NSInteger) n
{
    return [self substringToIndex: n];    
}

- (NSString *) drop: (NSInteger) n
{
    return [self substringFromIndex: n];        
}

- (NSString *) md5
{
    const char *str = [self UTF8String];
    unsigned char digest[16];
    CC_MD5(str, (CC_LONG)strlen(str), digest);
    
    NSMutableString *out = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [out appendFormat:@"%02x", digest[i]];
    
    return out;     
}

- (BOOL) contains:(NSString *)string 
{
    if (!string.length)
        return YES;        
    return [self rangeOfString:string].location != NSNotFound;
}

- (BOOL) isEmail 
{    
    static NSString *regex =  
    @"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";    
	
    NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];  
    return [p evaluateWithObject:[self lowercaseString]];  
}

- (BOOL) isLowercase
{
    static NSCharacterSet *charset = nil;
    if (!charset)
        charset = [NSCharacterSet lowercaseLetterCharacterSet];
    return [charset isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString: self]];
}

- (BOOL) isUppercase
{
    static NSCharacterSet *charset = nil;
    if (!charset)
        charset = [NSCharacterSet uppercaseLetterCharacterSet];
    return [charset isSupersetOfSet:[NSCharacterSet characterSetWithCharactersInString: self]];
}

- (NSString *) trimmed
{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *) append:(NSString *)string
{
    return [self stringByAppendingString:string];
}

- (NSString *) prepend:(NSString *)string 
{
    return [string append:self];
}

- (NSArray *) split 
{
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray *) split:(NSString *)string 
{
    return [self componentsSeparatedByString:string];
}

- (NSArray *) lines 
{
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];    
}

- (NSArray *) lines: (NSInteger) maxLen
{
    NSMutableArray *result = [NSMutableArray array];
    
    for (NSString *line in self.lines) {
        
        NSString *s = line;
        
        while (s.length > maxLen) {
            
            // try to split a line by space
            NSInteger n = maxLen;
            while (n && [s characterAtIndex:n] != 32) {
                --n;
            }
            if (n == 0)
                n = maxLen;
            [result addObject:[s substringToIndex:n]];
            s = [s substringFromIndex:n];
        }
           
        if (s.length)
            [result addObject:s];
    }

    return [result copy];
}

- (NSString *) sliceFrom: (NSInteger) from until: (NSInteger) until
{
    NSInteger len = MIN([self length], until - from);
    return [self substringWithRange: NSMakeRange(MAX(0, from), len)];
}

- (NSArray *) toArray
{
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:self.length];    
    for (int i = 0; i < self.length; ++i)
        [result addObject: @([self characterAtIndex: i])];
    return result;
}

- (NSUInteger) integerValueFromHex
{
    unsigned int result = 0;
    NSScanner* scanner = [NSScanner scannerWithString:self];
    [scanner scanHexInt:&result];
    return result;
}

+ (NSString *)formatSizeWithUnit:(double) value
{
#define KILO_FACTOR 1024.0
#define MEGA_FACTOR 1048576.0
#define GIGA_FACTOR 1073741824.0
#define TERA_FACTOR 1099511627776.0
    
    if (value < 1.0)
        return @"0";
    
    char *unit;
    
    if (value < KILO_FACTOR) {
        
        unit = "B";
        
    } else if (value < MEGA_FACTOR) {
        
        value /= KILO_FACTOR;
        unit = "KB";
        
    } else if (value < GIGA_FACTOR) {
        
        value /= MEGA_FACTOR;
        unit = "MB";
        
    } else if (value < TERA_FACTOR) {
        
        value /= GIGA_FACTOR;
        unit = "GB";
        
    } else {
        
        value /= TERA_FACTOR;
        unit = "TB";
    }
    
    float integral;
    if (0 == modff(value, &integral))
        return [NSString stringWithFormat:@"%.0f%s", integral, unit];
    return [NSString stringWithFormat:@"%.1f%s", value, unit];
}

@end
