//
//  ru.kolyvan.kxtools
//  https://github.com/kolyvan/kxtools
//

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


#import <Foundation/Foundation.h>

@interface KxBitArray :  NSObject<NSCopying>

@property (readonly, nonatomic) NSUInteger count;

+ (id) bits: (NSUInteger) count;
+ (id) bitsFromString: (NSString *) string;
+ (id) bitsFromData: (NSData *) data;

- (id) init: (NSUInteger) count;
- (id) initFromString: (NSString *) string;

- (BOOL) testBit: (NSUInteger) index;
- (void) setBit: (NSUInteger) index;
- (void) clearBit: (NSUInteger) index;
- (void) toggleBit: (NSUInteger) index;
- (void) assignBit: (NSUInteger) index on: (BOOL) on ;

- (void) setAll;
- (void) clearAll;

- (NSUInteger) countBits: (BOOL) on;
- (NSUInteger) firstSetBit;
- (BOOL) testAny;

- (KxBitArray *) intersectBits: (KxBitArray *) other;
- (KxBitArray *) unionBits: (KxBitArray *) other;
- (KxBitArray *) negateBits;

- (BOOL) isEqualToBitArray: (KxBitArray *) other;

- (void) enumerateBits: (void(^)(NSUInteger))block;

- (NSArray *) toArray;
- (NSIndexSet *) toIndexSet;
- (NSString *) toString;
- (NSData *) toData;

@end
