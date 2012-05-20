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

#import <CommonCrypto/CommonDigest.h>
#import "NSString+Kolyvan.h"
#import "NSArray+Kolyvan.h"
#import "NSData+Kolyvan.h"
#import "KxTuple2.h"
#define NSNUMBER_SHORTHAND
#import "KxMacros.h"
#import "KxArc.h"

@implementation NSString (Kolyvan)

@dynamic first;
@dynamic last;

+ (NSString *) uniqueString
{
	CFUUIDRef uuidObj = CFUUIDCreate(nil);
    NSString *uuidString = (NSString* )CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
	CFRelease(uuidObj);
	return KX_AUTORELEASE(uuidString);
}

+ (NSString *) stringFromAsciiBytes: (NSData *) data
{
    NSString *s =  [[NSString alloc] initWithData:data
                                         encoding:NSASCIIStringEncoding];
    return  KX_AUTORELEASE(s);
}

+ (NSString *) stringFromUtf8Bytes: (NSData *) data
{
    NSString *s = [[NSString alloc] initWithData:data
                                        encoding:NSUTF8StringEncoding];
    return KX_AUTORELEASE(s);
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

- (BOOL) isEmpty 
{
    return [self length] == 0;
}

- (BOOL) nonEmpty
{
    return [self length] > 0;    
}

- (BOOL) contains:(NSString *)string 
{
    if ([string isEmpty])
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

- (NSString *) escapeHTML
{
  	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
	NSMutableString *s = [NSMutableString string];
	
	NSInteger start = 0;
	NSInteger len = [self length];
	
	while (start < len) {
		NSRange r = [self rangeOfCharacterFromSet:chs 
                                          options:0 
                                            range:NSMakeRange(start, len-start)];
		
        if (r.location == NSNotFound) {
			[s appendString:[self substringFromIndex:start]];
			break;
		}
		
		if (start < r.location) {
			[s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
		}
		
		switch ([self characterAtIndex:r.location]) {
			case '<': [s appendString:@"&lt;"]; break;
			case '>': [s appendString:@"&gt;"]; break;
			case '"': [s appendString:@"&quot;"]; break;
			case '&': [s appendString:@"&amp;"]; break;
		}
		
		start = r.location + 1;
	}
	
	return s;
}

- (NSString *) unescapeHTML
{
	NSCharacterSet *chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];    
	NSMutableString *s = [NSMutableString string];
	NSMutableString *target = [self mutableCopy];
	
	while ([target length] > 0) {
		NSRange r = [target rangeOfCharacterFromSet:chs];
		if (r.location == NSNotFound) {
			[s appendString:target];
			break;
		}
		
		if (r.location > 0) {
			[s appendString:[target substringToIndex:r.location]];
			[target deleteCharactersInRange:NSMakeRange(0, r.location)];
		}
		
		if ([target hasPrefix:@"&lt;"]) {
			[s appendString:@"<"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&gt;"]) {
			[s appendString:@">"];
			[target deleteCharactersInRange:NSMakeRange(0, 4)];
		} else if ([target hasPrefix:@"&quot;"]) {
			[s appendString:@"\""];
			[target deleteCharactersInRange:NSMakeRange(0, 6)];
		} else if ([target hasPrefix:@"&#39;"]) {
			[s appendString:@"'"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else if ([target hasPrefix:@"&amp;"]) {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 5)];
		} else if ([target hasPrefix:@"&hellip;"]) {
			[s appendString:@"вА¶"];
			[target deleteCharactersInRange:NSMakeRange(0, 8)];
		} else {
			[s appendString:@"&"];
			[target deleteCharactersInRange:NSMakeRange(0, 1)];
		}
	}
	
    KX_RELEASE(target);
	return s;
}

- (NSString *) removeHTML
{
    NSScanner *scanner = [NSScanner scannerWithString:self];
    NSMutableString *acc = [NSMutableString stringWithCapacity:[self length]];
    NSString *s;

    while ([scanner isAtEnd] == NO) {
        
        s = nil;
        [scanner scanUpToString:@"<" intoString:&s];        
        if (s)
            [acc appendString:s];
        
        if ([scanner scanString:@"<" intoString:nil]) {            
            
            s = nil;
            [scanner scanUpToString:@">" intoString:&s];        
            if (![scanner scanString:@">" intoString:nil]) {
                if (s)
                    [acc appendString:s];
            }
        }
    }    
    
    return acc;
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
    return [NSString stringWithFormat:@"%@%@", string, self];
}


- (NSArray *) split 
{
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSArray *) split:(NSString *)string 
{
    return [self componentsSeparatedByString:string];
}

- (KxTuple2 *) splitAt:(NSInteger)position
{
    return [KxTuple2 first: [self substringToIndex:position] second: [self substringFromIndex:position]];
}

- (NSArray *) lines 
{
    return [self componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];    
}

- (NSArray *) lines: (NSInteger) maxLen
{   
    return [[self lines] flatMap:^(id elem) {
        
        NSString *s = elem;
        
        if (s.length < maxLen) 
            return s;
        
        NSMutableArray *bb = [[NSMutableArray alloc] init];
        
        while (s.length > maxLen) {
            
            // try to split a line by space            
            NSInteger n = maxLen;
            while (n && [s characterAtIndex:n] != 32) {
                --n;
            }
            if (n == 0) 
                n = maxLen;
            
            KxTuple2 * tuple = [s splitAt:n];
            [bb addObject:tuple.first];            
            s = tuple.second;            
        }
        
        [bb addObject: s];
        return (id)bb;        
    }];
}

- (NSString *) sliceFrom: (NSInteger) from until: (NSInteger) until
{
    NSInteger len = MIN([self length], until - from);
    return [self substringWithRange: NSMakeRange(MAX(0, from), len)];
}


- (NSString *) base64encode 
{
    NSData * d = [NSData dataWithBytes:[self UTF8String] 
                                length:[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding]];    
    return [d base64EncodedString];
}

- (NSString *) base64decode
{
    return [self->isa stringFromAsciiBytes: [NSData dataFromBase64String: self]];    
}

- (NSArray *) toArray
{
    // NSMutableArray *result = [NSMutableArray arrayWithCapacity:self.length];
    NSMutableArray * result = [NSMutableArray arrayWithCapacity:self.length];    
    for (int i = 0; i < self.length; ++i)
        [result addObject: $uchar([self characterAtIndex: i])];    
    return result;
}

- (NSString *) toString 
{ 
    return [NSString stringWithString:self];
}

@end
