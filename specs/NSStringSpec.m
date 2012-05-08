//
//  StringSpec.m
//  ru.kolyvan.repo
//
//  Created by admin on 02.04.12.
//  Copyright 2012 Kolyvan. All rights reserved.
//


#import <Cedar/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "NSString+Kolyvan.h"
#define NSNUMBER_SHORTHAND
#import "KxMacros.h"
#import "KxUtils.h"
#import "KxTuple2.h"


SPEC_BEGIN(NSStringKolyvan)
describe(@"NSString (Kolyvan)", ^{
    beforeEach(^{
        
    });

    
    it(@"compute md5", ^{
        assertThat([@"" md5], equalTo(@"d41d8cd98f00b204e9800998ecf8427e"));
        assertThat([@"kolyvan" md5], equalTo(@"fa122c782999721c9e7b86298f07fe2e"));        
    });
    
    it(@"compare uniqueString", ^{        
        assertThat([NSString uniqueString], isNot(equalTo([NSString uniqueString])));        
    });
        
    it(@"empty", ^{
        assertThatBool(YES, equalToBool([@"" isEmpty]));
        assertThatBool(NO, equalToBool([@"moo" isEmpty]));        
        
        assertThatBool(NO, equalToBool([@"" nonEmpty]));
        assertThatBool(YES, equalToBool([@"moo" nonEmpty]));        
        
        assertThatBool(YES, equalToBool(@"".isEmpty));        
        assertThatBool(NO, equalToBool(@"".nonEmpty));
    });
    
    it(@"contains", ^{
       assertThatBool(YES, equalToBool([@"" contains: @""]));
       assertThatBool(YES, equalToBool([@"foobar" contains: @""]));        
       assertThatBool(YES, equalToBool([@"foobar" contains: @"foo"]));
       assertThatBool(YES, equalToBool([@"foobar" contains: @"bar"])); 
    });

    it(@"not contains", ^{
        assertThatBool(NO,  equalToBool([@"" contains: @"moo"]));
        assertThatBool(NO,  equalToBool([@"foobar" contains: @"moo"]));
    });

    it(@"valid email ", ^{
        assertThatBool(YES,  equalToBool([@"test@example.com" isEmail]));
        assertThatBool(YES,  equalToBool([@"test@example.com.nu" isEmail]));        
        assertThatBool(YES,  equalToBool([@"-test+@example.com" isEmail]));      
        assertThatBool(YES,  equalToBool([@"test@xn--example.com" isEmail]));      
        assertThatBool(YES,  equalToBool([@"test@192.168.0.1" isEmail]));              
        assertThatBool(YES,  equalToBool([@"first.abc.def.last@iana.org" isEmail]));
    });
    
    it(@"invalid email ", ^{
        
        assertThatBool(NO,  equalToBool([@"" isEmail]));
        assertThatBool(NO,  equalToBool([@"first.last@sub.do,com" isEmail]));
        assertThatBool(NO,  equalToBool([@"first\\@last@iana.org" isEmail]));
        assertThatBool(NO,  equalToBool([@"first.last" isEmail]));
        assertThatBool(NO,  equalToBool([@"first.last@" isEmail]));
        assertThatBool(NO,  equalToBool([@"first.last@-xample.com" isEmail]));
        assertThatBool(NO,  equalToBool([@"@iana.org" isEmail]));
        assertThatBool(NO,  equalToBool([@"doug@" isEmail]));
        assertThatBool(NO,  equalToBool([@"test.@iana.org" isEmail]));        
        assertThatBool(NO,  equalToBool([@"test@test@iana.org " isEmail]));
        assertThatBool(NO,  equalToBool([@"test@@iana.org" isEmail]));
        assertThatBool(NO,  equalToBool([@"-- test --@iana.org" isEmail]));
        assertThatBool(NO,  equalToBool([@"[test]@iana.org" isEmail]));
    });
    
    it(@"escaping html", ^{
        NSString * html = @"<script>alert('you are hacked!')</script>";
        NSString * escaped = @"&lt;script&gt;alert('you are hacked!')&lt;/script&gt;";
        assertThat(escaped, equalTo([html escapeHTML]));
        assertThat(html, equalTo([escaped unescapeHTML]));        
    });
        
    it(@"removing html", ^{
        assertThat([@"" removeHTML], equalTo(@""));
        assertThat([@"foo" removeHTML], equalTo(@"foo"));
        assertThat([@"<br />" removeHTML], equalTo(@""));
        assertThat([@"<div>foo</div>" removeHTML], equalTo(@"foo"));
        assertThat([@"<br />foo" removeHTML], equalTo(@"foo"));
        assertThat([@"foo<br />" removeHTML], equalTo(@"foo"));        
        assertThat([@"abc<div>123<span><b>+</b></span></div>456<br />def" removeHTML], equalTo(@"abc123+456def")); 
    });

    it(@"trimmed", ^{
        assertThat([@"" trimmed], equalTo(@""));
        assertThat([@"foo" trimmed], equalTo(@"foo"));
        assertThat([@" \r foo \t\n " trimmed], equalTo(@"foo"));
    });
        
    it(@"split", ^{
       NSArray * array = [NSArray arrayWithObjects: @"foo", @"bar", @"moo", nil];
       assertThat([@"foo bar moo" split], equalTo(array));
       assertThat([@"foo|bar|moo" split: @"|"], equalTo(array));
    });
    
    it(@"split at poostion", ^{
        assertThat([@"foo bar moo" splitAt: 7], equalTo([KxTuple2 first: @"foo bar" second: @" moo"]));
    });
    
    it(@"lines", ^{

        assertThat([@"foo\nbar\nmoo" lines], equalTo([NSArray arrayWithObjects: @"foo", @"bar", @"moo", nil]));        
        
        assertThat([@"foo bar\nbuzz\nby space" lines: 4], 
                   equalTo([NSArray arrayWithObjects: @"foo", @" bar", @"buzz", @"by", @" spa", @"ce", nil]));                

    });
    
    
    it(@"slice", ^{
        assertThat([@"0123456789" sliceFrom: 1 until: 3], equalTo(@"12"));
        assertThat([@"0123456789" sliceFrom: -1 until: 10], equalTo(@"0123456789"));        
    });
        
    it(@"base64 encode", ^{
        NSString * string =  @"The quick brown fox jumps over the lazy dog"; 
        NSString * encoded = @"VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZw==";
        
        assertThat([string base64encode], equalTo(encoded));        
        assertThat([@" " base64encode], equalTo(@"IA=="));
        assertThat([@"" base64encode], equalTo(@""));
        
    });
    
    it(@"base64 decode", ^{
        NSString * string =  @"The quick brown fox jumps over the lazy dog"; 
        NSString * encoded = @"VGhlIHF1aWNrIGJyb3duIGZveCBqdW1wcyBvdmVyIHRoZSBsYXp5IGRvZw==";
        
        assertThat([encoded base64decode], equalTo(string));        
        assertThat([@"IA==" base64decode], equalTo(@" "));
        assertThat([@"" base64decode], equalTo(@""));
    });
    
    it(@"toArray", ^{

        assertThat(@"abcd".toArray, equalTo(KxUtils.array($uchar('a'), 
                                                           $uchar('b'), 
                                                           $uchar('c'), 
                                                           $uchar('d'), nil)));
    });  
    
    it(@"first, last, tail, butlast, take, drop", ^{

        assertThatChar(@"a".first, equalToChar('a'));                   
        assertThatChar(@"ab".first, equalToChar('a'));                           

        assertThatChar(@"a".last, equalToChar('a'));                   
        assertThatChar(@"ab".last, equalToChar('b'));                           

        assertThat(@"a".tail, equalTo(@""));                   
        assertThat(@"ab".tail, equalTo(@"b"));                           

        assertThat(@"a".butlast, equalTo(@""));                   
        assertThat(@"ab".butlast, equalTo(@"a"));                           

        assertThat([@"a"  take:1], equalTo(@"a")); 
        assertThat([@"ab" take:1], equalTo(@"a"));         
        assertThat([@"a"  drop:1], equalTo(@""));                           
        assertThat([@"ab" drop:1], equalTo(@"b"));
    });
    
});
SPEC_END
