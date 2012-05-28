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
#import "KxMacros.h"
#import "KxUtils.h"

SPEC_BEGIN(NSArrayKolyvan)
describe(@"NSArray (Kolyvan)", ^{
    
    __block NSArray *array;
    
    beforeEach(^{
        
        array = [NSArray arrayWithObjects:@"primum", @"secundo", @"tertia", @"", @"finem", nil];
    });
    
    it(@"create", ^{        
        assertThat(KxUtils.array(@"primum", @"secundo", @"tertia", @"", @"finem", nil), equalTo(array));
    });

    it(@"properties", ^{        
        assertThatBool(array.nonEmpty, equalToBool(YES));
        assertThatBool(array.isEmpty, equalToBool(NO));        
        assertThatInteger(array.count, equalToInteger(5));                
        assertThat(array.first,  equalTo(@"primum"));
        assertThat(array.second, equalTo(@"secundo"));
        assertThat(array.last,   equalTo(@"finem"));
    });
    
    it(@"tail,take,drop", ^{
        assertThat([array tail],    equalTo(KxUtils.array(@"secundo", @"tertia", @"", @"finem", nil)));      
        assertThat([array take: 3], equalTo(KxUtils.array(@"primum", @"secundo", @"tertia", nil)));
        assertThat([array drop: 2], equalTo(KxUtils.array(@"tertia", @"", @"finem", nil)));              
    });
    
    
    it(@"sort", ^{
        assertThat([array sorted], equalTo(KxUtils.array(@"", @"finem", @"primum", @"secundo", @"tertia", nil)));
        assertThat([array sortWith: ^(id l, id r){ return [(NSString *)r compare: l];  }], 
                   equalTo(KxUtils.array(@"tertia", @"secundo", @"primum", @"finem", @"",  nil)));
    });
    
    it(@"reverse", ^{
        assertThat([array reverse], equalTo(KxUtils.array(@"finem", @"", @"tertia", @"secundo", @"primum",  nil)));
    });

    
    it(@"map, flatMap", ^{
        assertThat([array map: ^(id x) { return $integer([x length]); }],
                   equalTo(KxUtils.array($integer(6), $integer(7), $integer(6), $integer(0), $integer(5), nil)));              
        
        
        NSArray *a = KxUtils.array(KxUtils.array(@"1", @"2", nil), 
                                   [NSArray array], 
                                   KxUtils.array(@"4", @"5", nil), nil);
        assertThat([a flatMap: ^(id x) { return x; }], equalTo(KxUtils.array(@"1", @"2", @"4", @"5", nil)));
    });
    
    
    it(@"reduce, fold", ^{
        
        assertThat([array reduce: ^(id acc, id x) {
                        return ([x isEmpty]) ? acc : KxUtils.format(@"%@,%@", acc, x); 
                    }],
                   equalTo(@"primum,secundo,tertia,finem"));
        
        assertThat([array fold: $integer(1) with: ^(id acc, id x) {
            return $integer([(NSNumber *)acc integerValue] + [x length]); }],
                   equalTo($integer(25)));
    });
    
    it(@"filter, filterNot", ^{
        
        assertThat([array filterNot: ^(id x) { return [x isEmpty]; }],
                   equalTo(KxUtils.array(@"primum",@"secundo",@"tertia",@"finem",nil)));
        
    });
    
    it(@"partition", ^{
        
        KxTuple2 *result = [array partition: ^(id x) { return (BOOL)([x length] > 5); }];
        
        assertThat(result.first,
                   equalTo(KxUtils.array(@"primum", @"secundo", @"tertia", nil)));
        
        assertThat(result.second,
                   equalTo(KxUtils.array(@"", @"finem", nil)));
        
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
        [mb appendAll: KxUtils.array(@"3", @"4", nil)];
        
        assertThat([mb toArray],
                   equalTo(KxUtils.array(@"1", @"2", @"3", @"4", nil)));
        
        
        mb = [NSMutableArray array];
        [mb appendFlat: @"x"];                        
        [mb appendFlat: KxUtils.array(@"A", @"B", nil)];                
        [mb appendFlat: KxUtils.dictionary(@"1", @"a", @"2", @"b", nil)];        
        
        assertThat([mb toArray],
                   equalTo(KxUtils.array(@"x", @"A", @"B", @"a", @"b", nil)));
        
        
    });
    
    
    it(@"pop, push", ^{
        
        NSMutableArray *mb = [NSMutableArray arrayWithObjects:@"1", @"2", nil];
        [mb push: @"3"];
        [mb push: @"4"];        
        assertThat([mb pop], equalTo(@"4"));
        
        assertThat([mb toArray],
                   equalTo(KxUtils.array(@"1", @"2", @"3", nil)));
    });
    
    it(@"zip, unzip", ^{
        
        NSArray * a1 = KxUtils.array(@"1", @"2", @"3", nil);
        NSArray * a2 = KxUtils.array(@"A", @"B", @"C", nil);
        
        NSArray * zipped = [a1 zip: a2];
        
        assertThat(zipped, equalTo(KxUtils.array(KxUtils.tuple(@"1", @"A"), 
                                                  KxUtils.tuple(@"2", @"B"),
                                                  KxUtils.tuple(@"3", @"C"), nil)));
        
        
        assertThat([a1 zipWithIndex], equalTo(KxUtils.array(KxUtils.tuple(@"1", $integer(0)), 
                                                             KxUtils.tuple(@"2", $integer(1)), 
                                                             KxUtils.tuple(@"3", $integer(2)), nil)));
        
        
        assertThat([zipped unzip], equalTo(KxUtils.tuple(a1, a2)));        
    });
    
    it(@"range, fill", ^{
        
        assertThat([NSArray rangeFrom: 2 until: 10 step: 2], 
                   equalTo(KxUtils.array($integer(2), 
                                         $integer(4), 
                                         $integer(6),                                          
                                         $integer(8), nil)));

        assertThat([NSArray rangeFrom: 2 until: 10 step: 3], 
                   equalTo(KxUtils.array($integer(2), 
                                         $integer(5), 
                                         $integer(8), nil)));

        assertThat([NSArray rangeFrom: 4 until: -4 step: -2], 
                   equalTo(KxUtils.array($integer( 4), 
                                         $integer( 2), 
                                         $integer( 0),
                                         $integer(-2), nil)));
        
        
        assertThat([NSArray fill: 3 block: ^() { return @"x"; }], 
                   equalTo(KxUtils.array(@"x", @"x", @"x", nil)));

        
    });
    
});
SPEC_END
