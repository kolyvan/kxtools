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
    
    it(@"gzip", ^{
       
        NSString *s = @"The quick brown fox jumps over the lazy dog";
        NSData *data = [s dataUsingEncoding:NSUTF8StringEncoding];        
        assertThat(s, equalTo([NSString stringWithUTF8String:data.gzip.gunzip.bytes]));
    });
    
    it(@"sha", ^{
        
        char bytes[] = {'k', 'o', 'l', 'y', 'v', 'a', 'n'};
        NSData *d = [[NSData dataWithBytes: bytes length:sizeof(bytes)] sha1];
        NSString *s = [d base64EncodedString];
        assertThat(s, equalTo(@"QIeHjvqhJTMwdP9xyLIKRPBDNe8="));
    });
    
    it(@"md5", ^{
        
        char bytes[] = {'k', 'o', 'l', 'y', 'v', 'a', 'n'};
        NSData *d = [[NSData dataWithBytes: bytes length:sizeof(bytes)] md5];
        NSString *s = [d base64EncodedString];
        assertThat(s, equalTo(@"+hIseCmZchyee4Ypjwf+Lg=="));
    });
    
    it(@"toString", ^{
        
        Byte bytes[] = {0xde, 0xad, 0xc0, 0xde};
        NSData *d = [NSData dataWithBytes: bytes length:sizeof(bytes)];
        assertThat([d toString], equalTo(@"deadc0de"));
    });
});
SPEC_END
