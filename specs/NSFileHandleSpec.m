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

#import "NSFileHandle+Kolyvan.h"
#import "KxUtils.h"

SPEC_BEGIN(NSFileHandleKolyvan)
describe(@"NSFileHandle+Kolyvan)", ^{
    
    it(@"create file", ^{

        NSString *path = KxUtils.pathForTemporaryFile(@"specs/test1");
        
        NSFileHandle *fh;
        fh = [NSFileHandle createFileAtPath:path overwrite:YES error:nil];
        assertThatBool(fh != nil, equalToBool(YES));
        [fh closeFile];
        
        fh = [NSFileHandle createFileAtPath:path overwrite:NO error:nil];
        assertThat(fh, equalTo(nil));
        [fh closeFile];
                
        [[[NSFileManager alloc] init] removeItemAtPath:path error:nil];
    });
    
    it(@"write format", ^{
        
        NSString *path = KxUtils.pathForTemporaryFile(@"specs/test1");
        NSFileHandle *fh = [NSFileHandle createFileAtPath:path overwrite:YES error:nil];
        
        [fh writeFormat:@"%@ %@", @"The quick brown", @"fox jumps over the lazy dog"];
        [fh closeFile];
        
        assertThat([NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil],
                   equalTo(@"The quick brown fox jumps over the lazy dog"));
        
        [[[NSFileManager alloc] init] removeItemAtPath:path error:nil];
    });
    
});
SPEC_END
