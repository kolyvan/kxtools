//
//  NSDataSpec.m
//  ru.kolyvan.repo
//
//  Created by admin on 02.04.12.
//  Copyright 2012 Kolyvan. All rights reserved.
//

#import <Cedar/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "NSData+Kolyvan.h"


SPEC_BEGIN(NSDataKolyvan)
describe(@"NSData (Kolyvan)", ^{
    beforeEach(^{
        
    });
    
    it(@"base64", ^{
        
        char bytes[] = {0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8};
        NSData *d = [NSData dataWithBytes: bytes length:sizeof(bytes)];
        NSString *s = [d base64EncodedString];
        
        assertThat([NSData dataFromBase64String:s], equalTo(d));
    });
   
    
});
SPEC_END
