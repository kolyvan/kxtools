//
//  NSDateSpec.m
//  ru.kolyvan.repo
//
//  Created by admin on 05.04.12.
//  Copyright 2012 Kolyvan. All rights reserved.
//


#import <Cedar/SpecHelper.h>
#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "NSDate+Kolyvan.h"
#import "KxArc.h"

SPEC_BEGIN(NSDateKolyvan)
describe(@"NSDate (Kolyvan)", ^{    
    
    __block NSDate * foolsDay;
    __block NSDate * today;
    
    beforeEach(^{
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        foolsDay = [formatter dateFromString:@"2012-04-01 11:41:21"];
        KX_RELEASE(formatter);
        
        NSAssert(foolsDay, @"date formatter failed!");
        
        today = [NSDate date];
    });    
 
    it(@"properties", ^{
       
        assertThatInteger([foolsDay year],  equalToInteger(2012));
        assertThatInteger([foolsDay month], equalToInteger(4));
        assertThatInteger([foolsDay day],   equalToInteger(1));        
        assertThatInteger([foolsDay hour],  equalToInteger(11));
        assertThatInteger([foolsDay minute],  equalToInteger(41));        
        assertThatInteger([foolsDay second],  equalToInteger(21));
    });
    
    it(@"is", ^{
        
        assertThatBool([foolsDay isSameDay: today],  equalToBool(NO));
        assertThatBool([today isSameDay: today],  equalToBool(YES));                

        assertThatBool([foolsDay isPast],  equalToBool(YES));
        assertThatBool([[NSDate distantFuture] isPast],  equalToBool(NO));        
        assertThatBool([[NSDate distantPast] isPast],  equalToBool(YES));

        assertThatBool([foolsDay isToday],  equalToBool(NO));
        
        assertThatBool([today isYesterday],  equalToBool(NO));
        assertThatBool([today isToday],  equalToBool(YES));
        assertThatBool([today isTomorrow],  equalToBool(NO));
        
        assertThatBool([[NSDate yesterday] isYesterday],  equalToBool(YES));
        assertThatBool([[NSDate yesterday] isToday],  equalToBool(NO));
        assertThatBool([[NSDate yesterday] isTomorrow],  equalToBool(NO));
                
        assertThatBool([[NSDate tomorrow] isYesterday],  equalToBool(NO));
        assertThatBool([[NSDate tomorrow] isToday],  equalToBool(NO));
        assertThatBool([[NSDate tomorrow] isTomorrow],  equalToBool(YES));
        
    });
    
    
    it(@"ctors, format", ^{
       
        NSDate *td = [NSDate year:[foolsDay year]
                            month:[foolsDay month] 
                              day:[foolsDay day] 
                             hour:[foolsDay hour] 
                           minute:[foolsDay minute] 
                           second:[foolsDay second] 
                         timeZone:nil];
        
        assertThat(td, equalTo(foolsDay));
        assertThat(td, isNot(equalTo(today)));
        
        td = [NSDate dateWithISO8601String:[foolsDay iso8601Formatted]]; 
        
        assertThat(td, equalTo(foolsDay));
        assertThat(td, isNot(equalTo(today)));
        
        td = [NSDate dateWithDateTimeString:[foolsDay dateTimeFormatted]]; 
        
        assertThat(td, equalTo(foolsDay));
        assertThat(td, isNot(equalTo(today)));

        td = [NSDate dateWithLongDateTimeString:[foolsDay longDateTimeFormatted]]; 
        
        assertThat(td, equalTo(foolsDay));
        assertThat(td, isNot(equalTo(today)));

        td = [NSDate dateWithRSSDateString:[foolsDay RSSFormatted]]; 
        
        assertThat(td, equalTo(foolsDay));
        assertThat(td, isNot(equalTo(today)));

        td = [NSDate dateWithAltRSSDateString:[foolsDay AltRSSFormatted]]; 
        
        assertThat(td, equalTo(foolsDay));
        assertThat(td, isNot(equalTo(today)));  
    });
    
    it(@"locale", ^{
        NSDate *td;
        
        NSLocale *enUS = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        NSLocale *ruRU = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];        
        
        td = [NSDate dateWithLongDateTimeString:@"01 Apr 2012 11:41:21" locale:enUS]; 
        assertThat(td, equalTo(foolsDay));
        assertThat([td longDateTimeFormatted: enUS], equalTo(@"01 Apr 2012 11:41:21"));
        
        td = [NSDate dateWithLongDateTimeString:@"01 апр. 2012 11:41:21" locale:ruRU]; 
        assertThat(td, equalTo(foolsDay));
        assertThat([td longDateTimeFormatted: ruRU], equalTo(@"01 апр. 2012 11:41:21"));
    });
    
    it(@"add", ^{
        assertThatInteger([[foolsDay addSeconds:5] second], equalToInteger([foolsDay second] + 5));
        assertThatInteger([[foolsDay addMinutes:5] minute], equalToInteger([foolsDay minute] + 5));        
        assertThatInteger([[foolsDay addHours:5] hour], equalToInteger([foolsDay hour] + 5));                
        assertThatInteger([[foolsDay addDays:5] day], equalToInteger([foolsDay day] + 5));                
        assertThatInteger([[foolsDay addMonths:5] month], equalToInteger([foolsDay month] + 5));                
        assertThatInteger([[foolsDay addYears:5] year], equalToInteger([foolsDay year] + 5)); 
    });

    it(@"midnight", ^{
        
        assertThatBool([foolsDay isSameDay: [foolsDay midnight]], equalToBool(YES));
        assertThatInteger([[foolsDay midnight] hour], equalToInteger(0));        
        assertThatInteger([[foolsDay midnight] minute], equalToInteger(0));              
        assertThatInteger([[foolsDay midnight] second], equalToInteger(0));
    });
       
    
    it(@"daysBetweenDate", ^{        
        assertThatInteger([foolsDay daysBetweenDate: [foolsDay addDays:+100]], equalToInteger(+100));
        assertThatInteger([foolsDay daysBetweenDate: [foolsDay addDays:-100]], equalToInteger(-100));        
    });
    
    
    it(@"dayOfYear", ^{
        assertThatInteger([foolsDay dayOfYear], equalToInteger(92));        
    });
    
    
    it(@"http date", ^{
        
        // @"Sun, 06 Nov 1994 08:49:37 GMT"
        NSDate *date = [NSDate year:1994 month:11 day:6 hour:8 minute:49 second:37 
                           timeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];        
        
        NSDate * td;
        td = [NSDate dateWithHTTPDateString:@"Sun, 06 Nov 1994 08:49:37 GMT"]; 
        assertThat(td, equalTo(date));

        td = [NSDate dateWithHTTPDateString:@"Sunday, 06-Nov-94 08:49:37 GMT"]; 
        assertThat(td, equalTo(date));

        date = [NSDate year:1994 month:11 day:6 hour:8 minute:49 second:37 
                   timeZone:[NSTimeZone localTimeZone]];        
        
        td = [NSDate dateWithHTTPDateString:@"Sun Nov  6 08:49:37 1994"]; 
        assertThat(td, equalTo(date));        
    });
     
    
});
SPEC_END
