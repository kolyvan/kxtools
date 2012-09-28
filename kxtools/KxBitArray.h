//
//  KxBitArray.h
//  kxtools
//
//  Created by Kolyvan on 13.09.12.
//
//

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
