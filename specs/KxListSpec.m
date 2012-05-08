//
//  KxListSpec.m
//  ru.kolyvan.repo
//
//  Created by admin on 09.04.12.
//  Copyright 2012 Kolyvan. All rights reserved.
//


#import <Cedar/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "KxList.h"
#import "KxUtils.h"
#define NSNUMBER_SHORTHAND
#import "KxMacros.h"


SPEC_BEGIN(KxListSpec)
describe(@"KxList", ^{
    
    __block KxList *list;
            
    beforeEach(^{
        
        list = [KxList list: @"1", @"2", @"3", nil];
        
    });

    it(@"create", ^{        
        
        assertThat(KxUtils.list(@"1", @"2", @"3", nil), equalTo(list));
        assertThat([KxList head: list.head tail: list.tail], equalTo(list));        
        assertThat([KxList fromArray: KxUtils.array(@"1", @"2", @"3", nil)], equalTo(list));

        assertThat([KxList rangeFrom: 2 until: 10 step: 2], 
                   equalTo(KxUtils.list($integer(2), 
                                         $integer(4), 
                                         $integer(6),                                          
                                         $integer(8), nil)));
        
        assertThat([KxList rangeFrom: 2 until: 10 step: 3], 
                   equalTo(KxUtils.list($integer(2), 
                                         $integer(5), 
                                         $integer(8), nil)));
        
        assertThat([KxList rangeFrom: 4 until: -4 step: -2], 
                   equalTo(KxUtils.list($integer( 4), 
                                         $integer( 2), 
                                         $integer( 0),
                                         $integer(-2), nil)));
        
        
        assertThat([KxList fill: 3 block: ^() { return @"x"; }], 
                   equalTo(KxUtils.list(@"x", @"x", @"x", nil)));

        
        assertThat([list toArray], equalTo(KxUtils.array(@"1", @"2", @"3", nil)));
        
    });

    it(@"head, tail, last, butlast", ^{        
        assertThat(list.head, equalTo(@"1"));
        assertThat(list.tail, equalTo(KxUtils.list(@"2", @"3", nil)));
        
        assertThat([list last], equalTo(@"3"));                
        assertThat([list butlast], equalTo(KxUtils.list(@"1", @"2", nil)));        
    });    
    
    it(@"count", ^{        
        assertThatInteger([list count], equalToInteger(3));
    });
    
    it(@"isEqualToList", ^{    
        assertThatBool([list isEqualToList: KxUtils.list(@"1", nil)], equalToBool(NO));
        assertThatBool([list isEqualToList: KxUtils.list(@"1", @"2", @"3", nil)], equalToBool(YES));        
        assertThatBool([list isEqualToList: KxUtils.list(@"1", @"22", @"3", nil)], equalToBool(NO));                
        assertThatBool([list isEqualToList: KxUtils.list(@"1", @"2", @"3", @"4", nil)], equalToBool(NO));                
    });    
    
    it(@"contains", ^{    
        assertThatBool([list contains: @"x"], equalToBool(NO));        
        assertThatBool([list contains: list.head], equalToBool(YES));
        assertThatBool([list contains: list.last], equalToBool(YES));
    });    

    it(@"reverse", ^{
        assertThat([list reverse], equalTo(KxUtils.list(@"3", @"2", @"1",  nil)));
    });
      
    it(@"take,drop", ^{
        assertThat([list take: 2], equalTo(KxUtils.list(@"1", @"2", nil)));
        assertThat([list drop: 2], equalTo(KxUtils.list(@"3", nil)));              
    });
        
    it(@"sort", ^{
        assertThat([KxUtils.list(@"b", @"z", @"f", nil) sorted], 
                   equalTo(KxUtils.list(@"b", @"f", @"z", nil)));
    });
    
    it(@"map, flatMap", ^{

        assertThat([list map: ^(id x) { return $integer([x integerValue]); }],
                   equalTo(KxUtils.list($integer(1), $integer(2), $integer(3), nil)));              
        
        
        KxList *a = KxUtils.list(KxUtils.list(@"1", @"2", nil), 
                                 KxUtils.list(@"4", @"5", nil), nil);
        assertThat([a flatMap: ^(id x) { return x; }], equalTo(KxUtils.list(@"1", @"2", @"4", @"5", nil)));
    });
     
    it(@"reduce, fold", ^{
        
        assertThat([list reduce: ^(id acc, id x) {
            return KxUtils.format(@"%@,%@", acc, x); 
        }],
                    equalTo(@"1,2,3"));
        
        assertThat([list fold: $integer(0) with: ^(id acc, id x) {
            return $integer( [acc integerValue] + [x integerValue]); }],
                   equalTo($integer(6)));            
    });
      
    it(@"filter, filterNot", ^{
        
        assertThat([list filter: ^(id x) { return (BOOL)([x integerValue] > 1); }],
                   equalTo(KxUtils.list(@"2",@"3",nil)));        
        
        assertThat([list filterNot: ^(id x) { return (BOOL)([x integerValue] < 2); }],
                   equalTo(KxUtils.list(@"2",@"3",nil)));
        
    });

    it(@"find, exists", ^{
        
        assertThat([list find: ^(id x) { return [x isEqualToString: @"2" ]; }],
                   equalTo(@"2"));
        
        assertThatBool([list exists: ^(id x) { return [x isEqual: @"1" ]; }],
                       equalToBool(YES));
        
        assertThatBool([list exists: ^(id x) { return [x isEqual: @"notfound" ]; }],
                       equalToBool(NO));
    });
 
    it(@"zip, unzip", ^{        

        KxList * abc = KxUtils.list(@"A", @"B", @"C", nil);
        
        KxList * zipped = [list zip: abc];
        
        assertThat(zipped, equalTo(KxUtils.list(KxUtils.tuple(@"1", @"A"), 
                                                KxUtils.tuple(@"2", @"B"),
                                                KxUtils.tuple(@"3", @"C"), nil)));
        
        assertThat([zipped unzip], equalTo(KxUtils.tuple(list, abc)));        
    });
    
});
SPEC_END
