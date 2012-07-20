//
//  ru.kolyvan.repo
//  https://github.com/kolyvan
//  

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import <Foundation/Foundation.h>

@class KxTuple2;

@interface NSString (Kolyvan)

@property(nonatomic,readonly,getter=isEmpty) BOOL isEmpty;
@property(nonatomic,readonly,getter=nonEmpty) BOOL nonEmpty;
@property(nonatomic,readonly) unichar first;
@property(nonatomic,readonly) unichar last;

+ (NSString *) uniqueString;
+ (NSString *) stringFromAsciiBytes: (NSData *) data;
+ (NSString *) stringFromUtf8Bytes: (NSData *) data;

- (unichar) first;
- (unichar) last;

- (NSString *) tail;
- (NSString *) butlast;
- (NSString *) take: (NSInteger) n;
- (NSString *) drop: (NSInteger) n;

- (NSString *) md5;

- (BOOL) isEmpty; 
- (BOOL) nonEmpty;
- (BOOL) contains:(NSString *)string; 
- (BOOL) isEmail;
- (BOOL) isLowercase;
- (BOOL) isUppercase;

- (NSString *) escapeHTML;
- (NSString *) unescapeHTML;
- (NSString *) removeHTML;
- (NSString *) trimmed;
- (NSString *) append:(NSString *)string;
- (NSString *) prepend:(NSString *)string;

- (NSArray *) split;
- (NSArray *) split:(NSString *)string;
- (KxTuple2*) splitAt:(NSInteger)position;
- (NSArray *) lines;
- (NSArray *) lines: (NSInteger) maxLen;

- (NSString *) sliceFrom: (NSInteger) from until: (NSInteger) until;

- (NSString *) base64encode;
- (NSString *) base64decode;

- (NSArray *) toArray;
- (NSString *) toString;

@end
