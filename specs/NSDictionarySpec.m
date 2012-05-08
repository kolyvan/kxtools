//
//  NSDictionarySpec.m
//  ru.kolyvan.repo
//
//  Created by admin on 04.04.12.
//  Copyright 2012 Kolyvan. All rights reserved.
//

#import <Cedar/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "NSDictionary+Kolyvan.h"
#import "KxTuple2.h"
#define NSNUMBER_SHORTHAND
#import "KxMacros.h"
#import "KxUtils.h"



SPEC_BEGIN(NSDictionaryKolyvan)
describe(@"NSDictionary (Kolyvan)", ^{
    __block NSDictionary *dict;
    
    beforeEach(^{
        
        dict = [NSDictionary dictionaryWithObjectsAndKeys:@"apple", @"red", @"sumbarine", @"yellow", nil];
    });
    
    it(@"create", ^{
        
        assertThat(KxUtils.dictionary(@"apple", @"red", @"sumbarine", @"yellow", nil), equalTo(dict));        
    });    
    
    it(@"properties", ^{        
        assertThatBool(dict.isEmpty, equalToBool(NO));        
        assertThatBool(dict.nonEmpty, equalToBool(YES));
        assertThatInteger(dict.count, equalToInteger(2));        
    });
        
    it(@"contains", ^{
        assertThatBool([dict contains: @"red"], equalToBool(YES));     
        assertThatBool([dict contains: @"yellow"], equalToBool(YES));
        assertThatBool([dict contains: @"blue"], equalToBool(NO));
    });
    
    it(@"get", ^{
        assertThat([dict get: @"red"], equalTo(@"apple"));
        assertThat([dict get: @"blue"], equalTo(nil));        
        assertThat([dict get: @"yellow" orElse: @"fail"], equalTo(@"sumbarine"));     
        assertThat([dict get: @"blue" orElse: @"sky"], equalTo(@"sky"));     
    });
    
    it(@"map", ^{
        assertThat([dict map: ^(id key, id obj) { return $integer([obj length]); }],
                   equalTo(KxUtils.dictionary($integer(5), @"red", $integer(9), @"yellow", nil)));
    }); 
    
    it(@"toArray", ^{
        assertThat(dict.toArray,
                   equalTo(KxUtils.array(KxUtils.tuple(@"red", @"apple"), 
                                         KxUtils.tuple(@"yellow", @"sumbarine"), nil)));
    });
    
    it(@"mutable update", ^{
        
        NSMutableDictionary *md = [[[NSMutableDictionary alloc] init] autorelease];
        
        [md update: @"red" value: @"apple"];
        assertThat([md get: @"red"], equalTo(@"apple"));
        
        [md toggle: @"red" value: nil];
        assertThatBool([md contains: @"red"], equalToBool(NO));        

        [md toggle: @"red" value: @"sand"];
        assertThat([md get: @"red"], equalTo(@"sand"));

        [md updateOnly: @"yellow" valueNotNil: nil];
        assertThatBool([md contains: @"yellow"], equalToBool(NO));        

        [md updateOnly: @"yellow" valueNotNil: @"sumbarine"];
        assertThat([md get: @"yellow"], equalTo(@"sumbarine"));

        [md updateSafe: @"blue" value: nil];
        assertThat([md get: @"blue"], equalTo([NSNull null]));
        
        [md updateSafe: @"blue" value: @"sky"];
        assertThat([md get: @"blue"], equalTo(@"sky"));
        
        [md updateOnce: @"black" with: ^{ return (id)nil; }];
        assertThatBool([md contains: @"black"], equalToBool(NO));        

        [md updateOnce: @"black" with: ^{ return @"night"; }];        
        assertThat([md get: @"black"], equalTo(@"night"));

        [md updateOnce: @"black" with: ^{ return @"car"; }];        
        assertThat([md get: @"black"], equalTo(@"night"));                
        
    });
    
    it(@"get:orSet:", ^{
        
        NSMutableDictionary *md = [[[NSMutableDictionary alloc] init] autorelease];
        
        [md get:@"red" orSet: ^{ return (id)nil; }];
        assertThat([md get: @"red"], equalTo(nil));        
        
        [md get:@"red" orSet: ^{ return @"apple"; }];
        assertThat([md get: @"red"], equalTo(@"apple"));        
        
        [md get:@"red" orSet: ^{ return @"sand"; }];
        assertThat([md get: @"red"], equalTo(@"apple"));        

        [md get:@"yellow" orSet: ^{ return (id)nil; }];
        assertThat([md get: @"yellow"], equalTo(nil));
        
        [md get:@"yellow" orSet: ^{ return @"sand"; }];
        assertThat([md get: @"yellow"], equalTo(@"sand"));        
        
    });
    
});
SPEC_END
