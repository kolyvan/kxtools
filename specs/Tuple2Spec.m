//
//  Tuple2Spec.m
//  ru.kolyvan.repo
//
//  Created by admin on 04.04.12.
//  Copyright 2012 Kolyvan. All rights reserved.
//


#import <Cedar/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "KxTuple2.h"
#import "KxUtils.h"


SPEC_BEGIN(Tuple2Spec)
describe(@"KxTuple2", ^{
    
    __block KxTuple2 * tuple;
    
    beforeEach(^{
        
        tuple = [KxTuple2 first: @"11" second: @"22"];
    });
   
    it(@"create", ^{
        
        assertThat(tuple.first, equalTo(@"11"));
        assertThat(tuple.second, equalTo(@"22"));        
        assertThat(KxUtils.tuple(@"11", @"22"), equalTo(tuple));
    });  
    
    it(@"equal, hash", ^{
        
        assertThat([tuple copy], equalTo(tuple));
        assertThat([tuple swap], isNot(equalTo(tuple)));
        
        assertThatInteger([[tuple copy] hash], equalToInteger([tuple hash]));  
        assertThatInteger([[tuple swap] hash], isNot(equalToInteger([tuple hash])));        
    });  
    
    it(@"nscoding", ^{
        
        NSData *data = [NSKeyedArchiver archivedDataWithRootObject: tuple];
        KxTuple2 *t = [NSKeyedUnarchiver unarchiveObjectWithData: data];
        assertThat(t, equalTo(tuple));
        
        data = [NSArchiver archivedDataWithRootObject: tuple];
        t = [NSUnarchiver unarchiveObjectWithData: data];
        assertThat(t, equalTo(tuple));
        
    });
    
});
SPEC_END
