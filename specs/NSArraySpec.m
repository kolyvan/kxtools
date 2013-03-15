//
//  NSArraySpec.m
//  ru.kolyvan.repo
//
//  Created by admin on 03.04.12.
//  Copyright 2012 Kolyvan. All rights reserved.
//

#import <Cedar/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "NSArray+Kolyvan.h"
#import "KxTuple2.h"
#define NSNUMBER_SHORTHAND
#import "KxUtils.h"

SPEC_BEGIN(NSArrayKolyvan)
describe(@"NSArray (Kolyvan)", ^{
    
    __block NSArray *array;
    
    beforeEach(^{
        
        array = [NSArray arrayWithObjects:@"primum", @"secundo", @"tertia", @"", @"finem", nil];
    });
    
    it(@"properties", ^{        

        assertThat(array.first,  equalTo(@"primum"));
        assertThat(array.second, equalTo(@"secundo"));
        assertThat(array.last,   equalTo(@"finem"));
    });
    
    it(@"tail,take,drop", ^{
        assertThat([array tail],    equalTo(@[@"secundo", @"tertia", @"", @"finem"]));
        assertThat([array take: 3], equalTo(@[@"primum", @"secundo", @"tertia"]));
        assertThat([array drop: 2], equalTo(@[@"tertia", @"", @"finem"]));
    });
    
    it(@"sort", ^{
        assertThat([array sorted], equalTo(@[@"", @"finem", @"primum", @"secundo", @"tertia"]));
        assertThat([array sortWith: ^(id l, id r){ return [(NSString *)r compare: l];  }], 
                   equalTo(@[@"tertia", @"secundo", @"primum", @"finem", @""]));
    });
    
    it(@"reverse", ^{
        assertThat([array reverse], equalTo(@[@"finem", @"", @"tertia", @"secundo", @"primum"]));
    });
    
    it(@"map, flatMap", ^{
        assertThat([array map: ^(id x) { return @([x length]); }],
                   equalTo(@[@(6), @(7), @(6), @(0), @(5)]));
        
        NSArray *a = @[@[@"1", @"2"], @[], @[@"4", @"5"]];
        assertThat([a flatMap: ^(id x) { return x; }], equalTo(@[@"1", @"2", @"4", @"5"]));
    });
  
    it(@"reduce, fold", ^{
     
        NSArray *t = [array reduce: ^id(id acc, id x) {
            return [x length] ? [NSString stringWithFormat:@"%@,%@", acc, x] : acc;
        }];
        
        assertThat(t, equalTo(@"primum,secundo,tertia,finem"));
        
        assertThat([array fold: @(1) with: ^(id acc, id x) {
            return @([(NSNumber *)acc integerValue] + [x length]); }],
                   equalTo(@(25)));
    });
    
    it(@"filter, filterNot", ^{
        
        assertThat([array filterNot: ^BOOL(id x) { return [x length] == 0; }],
                   equalTo(@[@"primum",@"secundo",@"tertia",@"finem"]));
        
    });
    
    it(@"partition", ^{
        
        KxTuple2 *result = [array partition: ^(id x) { return (BOOL)([x length] > 5); }];
        
        assertThat(result.first, equalTo(@[@"primum", @"secundo", @"tertia"]));        
        assertThat(result.second, equalTo(@[@"", @"finem"]));
        
    }); 
    
    it(@"find, exists", ^{
        
        assertThat([array find: ^(id x) { return [x hasPrefix: @"sec" ]; }],
                   equalTo(@"secundo"));
        
        assertThatBool([array exists: ^(id x) { return [x isEqual: @"" ]; }],
                       equalToBool(YES));

        assertThatBool([array exists: ^(id x) { return [x isEqual: @"notfound" ]; }],
                       equalToBool(NO));
    });
    
    it(@"append", ^{        

        NSMutableArray *mb = [NSMutableArray array];
        [mb append: @"1", @"2", nil];
        [mb append: @"3", @"4", nil];
        
        assertThat([mb copy], equalTo(@[@"1", @"2", @"3", @"4"]));
        
        mb = [NSMutableArray array];
        [mb appendFlat: @"x"];                        
        [mb appendFlat: @[@"A", @"B"]];
        [mb appendFlat: @{@"a":@"1", @"b":@"2"}];
        
        assertThat([mb copy],
                   equalTo(@[@"x", @"A", @"B", @"a", @"b"]));
    });
    
    it(@"pop, push", ^{
        
        NSMutableArray *mb = [NSMutableArray arrayWithObjects:@"1", @"2", nil];
        [mb push: @"3"];
        [mb push: @"4"];        
        assertThat([mb pop], equalTo(@"4"));
        
        assertThat([mb copy],
                   equalTo(@[@"1", @"2", @"3"]));
    });
    
    it(@"zip, unzip", ^{
        
        NSArray * a1 = @[@"1", @"2", @"3"];
        NSArray * a2 = @[@"A", @"B", @"C"];
        
        NSArray * zipped = [a1 zip: a2];
        
        assertThat(zipped, equalTo(@[
                                   [KxTuple2 first:@"1" second:@"A"],
                                   [KxTuple2 first:@"2" second:@"B"],
                                   [KxTuple2 first:@"3" second:@"C"]]));
        
        
        assertThat([a1 zipWithIndex], equalTo(@[
                                              [KxTuple2 first:@"1" second: @(0)],
                                              [KxTuple2 first:@"2" second: @(1)],
                                              [KxTuple2 first:@"3" second: @(2)]]));
        
        assertThat([zipped unzip], equalTo([KxTuple2 first:a1 second:a2]));
                   
    });
    
    it(@"range, fill", ^{
        
        assertThat([NSArray rangeFrom: 2 until: 10 step: 2], 
                   equalTo(@[@(2),@(4),@(6),@(8)]));

        assertThat([NSArray rangeFrom: 2 until: 10 step: 3], 
                   equalTo(@[@(2),@(5),@(8)]));

        assertThat([NSArray rangeFrom: 4 until: -4 step: -2], 
                   equalTo(@[@(4),@(2),@(0),@(-2)]));
        
        assertThat([NSArray fill: 3 block: ^() { return @"x"; }], 
                   equalTo(@[@"x", @"x", @"x"]));
        
    });
    
    it(@"unique", ^{

        NSArray *a1 = @[@1, @2, @3, @4, @5];
        NSArray *a2 = @[@1, @2, @1, @1, @2, @3, @4, @4, @5, @3];
        NSArray *a3 = @[@1, @1, @1];

        assertThat([@[] unique], equalTo(@[]));
        assertThat([a3 unique], equalTo(@[@1]));
        assertThat([a1 unique], equalTo(a1));
        assertThat([a2 unique], equalTo(a1));
    });
    
    it(@"toString", ^{
        
        NSArray *a1 = @[@1, @2, @3, @4, @5];        
        assertThat(a1.toString, equalTo(@"12345"));
        assertThat([a1 toString:@","], equalTo(@"1,2,3,4,5"));
    });
    
});

SPEC_END

