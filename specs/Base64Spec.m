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

#import "KxBase64.h"

SPEC_BEGIN(KxBase64)
describe(@"Base64", ^{
        
    it(@"NSData+Base64", ^{
        
        char bytes[] = {0x1, 0x2, 0x3, 0x4, 0x5, 0x6, 0x7, 0x8};
        NSData *d = [NSData dataWithBytes: bytes length:sizeof(bytes)];
        NSString *s = [d base64EncodedString];        
        assertThat([NSData dataFromBase64String:s], equalTo(d));
        
        NSData *dstring = [@"The quick brown fox jumps over the lazy dog" dataUsingEncoding:NSUTF8StringEncoding];
        NSData *dencoded = [@"VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZw==" dataUsingEncoding:NSUTF8StringEncoding];
        
        assertThat([dstring base64encode], equalTo(dencoded));
        assertThat([dencoded base64decode], equalTo(dstring));
        assertThat([[dstring base64encode] base64decode], equalTo(dstring));
        
    });
    
    it(@"NString+Base64", ^{
        
        NSString * string =  @"The quick brown fox jumps over the lazy dog";
        NSString * encoded = @"VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZw==";
        
        assertThat([string base64encode], equalTo(encoded));
        assertThat([@" " base64encode], equalTo(@"IA=="));
        assertThat([@"" base64encode], equalTo(@""));
        
        assertThat([encoded base64decode], equalTo(string));
        assertThat([@"IA==" base64decode], equalTo(@" "));
        assertThat([@"" base64decode], equalTo(@""));
        
        NSString *nonascii = @"Нежной поступью надвьюжной, Снежной россыпью жемчужной,";
        assertThat([[nonascii base64encode] base64decode], equalTo(nonascii));        
    });
    
});
SPEC_END
