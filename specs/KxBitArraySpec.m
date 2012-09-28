//
//  KxBitArraySpec.m
//  kxtools
//
//  Created by Kolyvan on 13.09.12.
//
//

#import <Cedar/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "KxBitArray.h"
#import "KxUtils.h"


SPEC_BEGIN(KxBitArraySpec)
describe(@"KxBitArray", ^{
        
    it(@"bits", ^{
        
        KxBitArray *bits = [KxBitArray bits: 5];

        assertThatInteger([bits count], equalToInteger(5));
        
        assertThatBool([bits testBit:0], equalToBool(NO));
        assertThatBool([bits testBit:1], equalToBool(NO));
        assertThatBool([bits testBit:2], equalToBool(NO));
        assertThatBool([bits testBit:3], equalToBool(NO));
        assertThatBool([bits testBit:4], equalToBool(NO));
    });
    
    it(@"setAll", ^{
        
        KxBitArray *bits = [KxBitArray bits: 4];
        
        [bits setAll];
        
        assertThatBool([bits testBit:0], equalToBool(YES));
        assertThatBool([bits testBit:1], equalToBool(YES));
        assertThatBool([bits testBit:2], equalToBool(YES));
        assertThatBool([bits testBit:3], equalToBool(YES));
    });
    
    it(@"bitsFromString", ^{
        
        KxBitArray *bits = [KxBitArray bitsFromString: @"00110101"];

        assertThatBool([bits testBit:0], equalToBool(NO));
        assertThatBool([bits testBit:1], equalToBool(NO));
        assertThatBool([bits testBit:2], equalToBool(YES));
        assertThatBool([bits testBit:3], equalToBool(YES));

        assertThatBool([bits testBit:4], equalToBool(NO));
        assertThatBool([bits testBit:5], equalToBool(YES));
        assertThatBool([bits testBit:6], equalToBool(NO));
        assertThatBool([bits testBit:7], equalToBool(YES));
    });
    
    it(@"copy", ^{
        
        KxBitArray *bits = [[KxBitArray bitsFromString: @"00110001"] copy];
        
        assertThatBool([bits testBit:0], equalToBool(NO));
        assertThatBool([bits testBit:1], equalToBool(NO));
        assertThatBool([bits testBit:2], equalToBool(YES));
        assertThatBool([bits testBit:3], equalToBool(YES));
        
        assertThatBool([bits testBit:4], equalToBool(NO));
        assertThatBool([bits testBit:5], equalToBool(NO));
        assertThatBool([bits testBit:6], equalToBool(NO));
        assertThatBool([bits testBit:7], equalToBool(YES));
    });
    
    it(@"setBit", ^{
        
        KxBitArray *bits = [KxBitArray bits: 4];
        
        [bits setBit:2];
        [bits setBit:3];
        
        assertThatBool([bits testBit:0], equalToBool(NO));
        assertThatBool([bits testBit:1], equalToBool(NO));
        assertThatBool([bits testBit:2], equalToBool(YES));
        assertThatBool([bits testBit:3], equalToBool(YES)); 
    });
    
    it(@"clearBit", ^{
        
        KxBitArray *bits = [KxBitArray bits: 100];
        [bits setAll];
        
        [bits clearBit:11];
        [bits clearBit:77];
        
        assertThatBool([bits testBit:11], equalToBool(NO));
        assertThatBool([bits testBit:77], equalToBool(NO));
        assertThatBool([bits testBit:78], equalToBool(YES));
        assertThatBool([bits testBit:99], equalToBool(YES));
    });
    
    it(@"toggleBit", ^{
        
        KxBitArray *bits = [KxBitArray bits: 100];
        
        [bits toggleBit:11];
        [bits toggleBit:99];
        [bits toggleBit:99];
        
        assertThatBool([bits testBit:11], equalToBool(YES));
        assertThatBool([bits testBit:99], equalToBool(NO));
    });

    it(@"assignBit", ^{
        
        KxBitArray *bits = [KxBitArray bits: 4];
        
        [bits assignBit:2 on: YES];
        [bits assignBit:3 on: YES];
        [bits assignBit:3 on: NO];
        
        assertThatBool([bits testBit:0], equalToBool(NO));
        assertThatBool([bits testBit:1], equalToBool(NO));
        assertThatBool([bits testBit:2], equalToBool(YES));
        assertThatBool([bits testBit:3], equalToBool(NO));
    });
    
    it(@"countBits", ^{
        
        KxBitArray *bits = [KxBitArray bits: 100];

        [bits setBit:7];
        [bits setBit:11];
        [bits setBit:42];
        [bits setBit:75];
        
        assertThatInteger([bits countBits:YES], equalToInteger(4));
        assertThatInteger([bits countBits:NO], equalToInteger(96));
        
        bits = [KxBitArray bitsFromString: @"1111111111"];
        assertThatInteger([bits countBits:YES], equalToInteger(10));
                        
        bits = [KxBitArray bitsFromString: @"0000000000"];
        assertThatInteger([bits countBits:YES], equalToInteger(0));
        
        bits = [KxBitArray bitsFromString: @"1000000001"];
        assertThatInteger([bits countBits:YES], equalToInteger(2));
        
        [bits setAll];
        assertThatInteger([bits countBits:YES], equalToInteger(10));
    });
    
    it(@"firstSetBit, testAny", ^{
        
        KxBitArray *bits = [KxBitArray bits: 100];
        
        assertThatInteger([bits firstSetBit], equalToInteger(NSNotFound));
        assertThatBool([bits testAny], equalToBool(NO));
        
        [bits setBit:42];
        assertThatInteger([bits firstSetBit], equalToInteger(42));
        assertThatBool([bits testAny], equalToBool(YES));
    });

    it(@"intersectBits", ^{
        
        KxBitArray *bits1 = [KxBitArray bitsFromString: @"00110001"];
        KxBitArray *bits2 = [KxBitArray bitsFromString: @"01100101"];
        KxBitArray *bits = [bits1 intersectBits:bits2];
        
        assertThatBool([bits testBit:0], equalToBool(NO));
        assertThatBool([bits testBit:1], equalToBool(NO));
        assertThatBool([bits testBit:2], equalToBool(YES));
        assertThatBool([bits testBit:3], equalToBool(NO));
        
        assertThatBool([bits testBit:4], equalToBool(NO));
        assertThatBool([bits testBit:5], equalToBool(NO));
        assertThatBool([bits testBit:6], equalToBool(NO));
        assertThatBool([bits testBit:7], equalToBool(YES));
    });
    
    it(@"unionBits", ^{
        
        KxBitArray *bits1 = [KxBitArray bitsFromString: @"00110001"];
        KxBitArray *bits2 = [KxBitArray bitsFromString: @"01100101"];
        KxBitArray *bits = [bits1 unionBits:bits2];
        
        assertThatBool([bits testBit:0], equalToBool(NO));
        assertThatBool([bits testBit:1], equalToBool(YES));
        assertThatBool([bits testBit:2], equalToBool(YES));
        assertThatBool([bits testBit:3], equalToBool(YES));
        
        assertThatBool([bits testBit:4], equalToBool(NO));
        assertThatBool([bits testBit:5], equalToBool(YES));
        assertThatBool([bits testBit:6], equalToBool(NO));
        assertThatBool([bits testBit:7], equalToBool(YES));        
    });
    
    it(@"negate", ^{
        
        KxBitArray *bits = [[KxBitArray bitsFromString: @"00110001"] negateBits];
       
        assertThatBool([bits testBit:0], equalToBool(YES));
        assertThatBool([bits testBit:1], equalToBool(YES));
        assertThatBool([bits testBit:2], equalToBool(NO));
        assertThatBool([bits testBit:3], equalToBool(NO));
        
        assertThatBool([bits testBit:4], equalToBool(YES));
        assertThatBool([bits testBit:5], equalToBool(YES));
        assertThatBool([bits testBit:6], equalToBool(YES));
        assertThatBool([bits testBit:7], equalToBool(NO));
        
        assertThatInteger([bits countBits:YES], equalToInteger(5));
        
        bits = [[KxBitArray bits: 100] negateBits];
        assertThatInteger([bits countBits:YES], equalToInteger(100));

        bits = [bits negateBits];
        assertThatInteger([bits countBits:YES], equalToInteger(0));
    });
    
    it(@"isEqual", ^{
        
        KxBitArray *bits1 = [KxBitArray bitsFromString: @"00110001"];
        KxBitArray *bits2 = [KxBitArray bitsFromString: @"01100101"];
        
        assertThatBool([bits1 isEqual:@""], equalToBool(NO));
        assertThatBool([bits1 isEqual:bits2], equalToBool(NO));
        assertThatBool([bits1 isEqual:[bits1 copy]], equalToBool(YES));
        
        KxBitArray *bits3 = [KxBitArray bitsFromString: @"11111111"];
        KxBitArray *bits4 = [KxBitArray bits: 8];
        assertThatBool([bits3 isEqual:bits4], equalToBool(NO));
        
        [bits4 setAll];
        assertThatBool([bits3 isEqual:bits4], equalToBool(YES));
                
        [bits3 clearAll];
        assertThatBool([bits3 isEqual:bits4], equalToBool(NO));
        
        [bits4 clearAll];
        assertThatBool([bits3 isEqual:bits4], equalToBool(YES));
    });
    
    it(@"enumerateBits", ^{
        
        KxBitArray *bits = [KxBitArray bitsFromString: @"01010011"];
        
        NSMutableArray *ma = [NSMutableArray array];
        [bits enumerateBits:^(NSUInteger i) {
            [ma addObject:[NSNumber numberWithInteger:i]];
        }];
        
        assertThat(ma, equalTo(@[@1, @3, @6, @7]));
    });
    
    it(@"toString", ^{
        
        KxBitArray *bits = [KxBitArray bitsFromString: @"00110001"];
        assertThat([bits toString], equalTo(@"00110001"));
    });
    
    it(@"toData", ^{
        
        Byte bytes[] = {1,0,1,0,1,0,1,0};
        NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
        KxBitArray *bits = [KxBitArray bitsFromData: data];
        assertThat([bits toData], equalTo(data));
        assertThat([bits toString], equalTo(@"10101010"));
    });
    
    it(@"toArray", ^{
        
        KxBitArray *bits = [KxBitArray bitsFromString: @"11111111"];
        assertThat([bits toArray], equalTo(@[@0, @1, @2, @3, @4, @5, @6, @7]));
        
        bits = [KxBitArray bitsFromString: @"00000000"];
        assertThat([bits toArray], equalTo(@[]));
        
        bits = [KxBitArray bitsFromString: @"10000001"];
        assertThat([bits toArray], equalTo(@[@0, @7]));
    });
    
    it(@"toIndexSet", ^{
        
        KxBitArray *bits = [KxBitArray bitsFromString: @"11111111"];        
        assertThat([bits toIndexSet], equalTo([NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 8)]));
        
        bits = [KxBitArray bitsFromString: @"00000000"];
        assertThat([bits toIndexSet], equalTo([NSIndexSet indexSet]));
        
        bits = [KxBitArray bitsFromString: @"00010000"];
        assertThat([bits toIndexSet], equalTo([NSIndexSet indexSetWithIndex:3]));
    });

});
SPEC_END
