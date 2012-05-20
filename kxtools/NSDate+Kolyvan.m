//
//  ru.kolyvan.repo
//  https://github.com/kolyvan
//  

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.


// 
// Some code and ideas was taken from following projects, thank you.

//
// InnerBand
// Created by John Blanco on 11/15/11.
// Copyright (c) 2011 Rapture In Ven
// github.com/ZaBlanc/InnerBand
// 

// 
// TapkuLibrary 
// Created by Devin Ross on 11/9/10.
// tapku.com || github.com/devinross/tapkulibrary
// TapkuLibrary is licensed under the MIT License. 
//

//
// Cocoa Helpers
// Copyright © 2009 enormego
// github.com/enormego/cocoa-helpers
// Cocoa-Helpers are available under the MIT license
// 


// http://unicode.org/reports/tr35/tr35-6.html#Date_Format_Patterns


#import "NSDate+Kolyvan.h"
#import "KxMacros.h"
#import "KxArc.h"

#define YMD_COMPONENTS NSMonthCalendarUnit|NSDayCalendarUnit|NSYearCalendarUnit
#define HMS_COMPONENTS NSMinuteCalendarUnit|NSSecondCalendarUnit|NSHourCalendarUnit
#define YMDHMS_COMPONENTS YMD_COMPONENTS|HMS_COMPONENTS|NSWeekdayCalendarUnit

static inline NSCalendar* currentCal() { return [NSCalendar currentCalendar]; }

@implementation NSDate (Kolyvan)

- (NSDateComponents *) YMD
{
    return [currentCal() components:YMD_COMPONENTS fromDate:self];
}

- (NSDateComponents *) hms
{
    return [currentCal() components:HMS_COMPONENTS fromDate:self];
}

- (NSDateComponents *) YMDhms
{
    return [currentCal() components:YMDHMS_COMPONENTS fromDate:self];
}

- (NSDateComponents *) YMDhms_GMT
{
    NSCalendar *calendar = currentCal();
    NSTimeZone *old = [calendar timeZone];
    [calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSDateComponents *dc = [calendar components:YMDHMS_COMPONENTS fromDate:self];
    calendar.timeZone = old;
    return dc;
}

- (NSInteger) year 
{
    return [self.YMDhms year];
}

- (NSInteger) month 
{
    return [self.YMDhms month];
}

- (NSInteger) day 
{
    return [self.YMDhms day];
}

- (NSInteger) hour 
{
    return [self.YMDhms hour];
}

- (NSInteger) minute 
{
    return [self.YMDhms minute];
}

- (NSInteger) second 
{
    return [self.YMDhms second];
}

- (NSDate *) addSeconds:(NSInteger) seconds
{
    return [self addYears:0 months:0 days:0 hours:0 minutes:0 seconds:seconds];
}

- (NSDate *) addMinutes:(NSInteger) minutes
{
    return [self addYears:0 months:0 days:0 hours:0 minutes:minutes seconds:0];        
}

- (NSDate *) addHours:(NSInteger) hours
{
    return [self addYears:0 months:0 days:0 hours:hours minutes:0 seconds:0];        
}

- (NSDate *) addDays: (NSInteger)days 
{
    return [self addYears:0 months:0 days:days hours:0 minutes:0 seconds:0];
}

- (NSDate *) addMonths:(NSInteger) months
{    
    return [self addYears:0 months:months days:0 hours:0 minutes:0 seconds:0];    
}

- (NSDate *) addYears:(NSInteger) years
{
    return [self addYears:years months:0 days:0 hours:0 minutes:0 seconds:0];        
}

- (NSDate *) addYears:(NSInteger) years 
               months:(NSInteger) months 
                 days:(NSInteger) days 
                hours:(NSInteger) hours
              minutes:(NSInteger) minutes 
              seconds:(NSInteger) seconds
{
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    [dc setYear: years];
    [dc setMonth: months];
    [dc setDay: days];    
    [dc setHour: hours];
    [dc setMinute: minutes];
    [dc setSecond: seconds];
    NSDate* result = [currentCal() dateByAddingComponents:dc toDate:self options:0];
    KX_RELEASE(dc);
    return result;
}

- (NSDate *) midnight 
{
    NSCalendar *calendar = currentCal();
    NSDateComponents *ymd = [calendar components:YMD_COMPONENTS fromDate:self];
	return [calendar dateFromComponents:ymd];
}

- (BOOL) isSameDay:(NSDate *)other 
{
	NSDateComponents *l = [self  YMDhms];
	NSDateComponents *r = [other YMDhms];    
 
	return [l year] == [r year] && [l month] == [r month] && [l day] == [r day];
}

- (BOOL) isToday
{
    return [self isSameDay:[NSDate date]];
}

- (BOOL) isYesterday
{
    return [self isSameDay:[NSDate yesterday]];
}

- (BOOL) isTomorrow
{
    return [self isSameDay:[NSDate tomorrow]];    
}

- (BOOL) isPast
{
    // return [self isSameDay: [self earlierDate:[NSDate date]]];    
    return [self compare:[NSDate date]] == NSOrderedAscending; 
}

- (NSInteger) daysBetweenDate:(NSDate *) other;
{ 
//    NSDateComponents *comps = [currentCal() components:NSDayCalendarUnit 
//                                              fromDate:self  
//                                                toDate:other  
//                                               options:0]; // NSWrapCalendarComponents?
//    return [comps day];
    
    NSTimeInterval seconds = [other timeIntervalSinceDate:self];
    return round(seconds / 86400);
}

- (NSInteger) dayOfYear
{
    return [currentCal() ordinalityOfUnit:NSDayCalendarUnit
                                   inUnit:NSYearCalendarUnit
                                  forDate:self];
}

+ (NSDate *) yesterday
{
    return [[NSDate date] addDays:-1];
}

+ (NSDate *) tomorrow
{
    return [[NSDate date] addDays:+1];
}

+ (NSDate *) year:(NSUInteger) year
            month:(NSUInteger) month
              day:(NSUInteger) day
             hour:(NSUInteger) hour
           minute:(NSUInteger) minute
           second:(NSUInteger) second
         timeZone:(NSTimeZone *) timeZone;
{
    NSDateComponents *dc = [[NSDateComponents alloc] init];
    [dc setYear: year];
    [dc setMonth: month];
    [dc setDay: day];    
    [dc setHour: hour];
    [dc setMinute: minute];
    [dc setSecond: second];
    NSCalendar * calendar = currentCal();
    NSTimeZone * oldTZ = calendar.timeZone; 
    if (timeZone)
        calendar.timeZone = timeZone;
    NSDate * result = [calendar dateFromComponents:dc];
    if (timeZone)
        calendar.timeZone = oldTZ;    
    KX_RELEASE(dc);
    return result;
}

+ (NSDate *) date:(NSDate *) date time:(NSDate *) time 
{
    NSDateComponents *dc = [date YMDhms];
    NSDateComponents *tc = [time hms];

    return [self year:dc.year 
                month:dc.month 
                  day:dc.day 
                 hour:tc.hour 
               minute:tc.minute 
               second:tc.second 
             timeZone:nil];
}

+ (NSDate *) date:(NSString*) string format:(NSString* ) format
{
    return [self date: string format: format locale: nil timeZone:nil];
}

+ (NSDate *) date:(NSString *) string 
           format:(NSString* ) format 
           locale:(NSLocale *)locale
{
    return [self date: string format: format locale: locale timeZone:nil];    
}

+ (NSDate *) date:(NSString *) string 
           format:(NSString* ) format 
           locale:(NSLocale *)locale          
         timeZone:(NSTimeZone *) tz
{
    if (!string) 
        return nil;
    
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    
    if (locale)
        [formatter setLocale:locale];    
    
    if (tz)
        [formatter setTimeZone:tz];
    
    [formatter setDateFormat:format];    
    
    NSDate *result = [formatter dateFromString:string];
    KX_RELEASE(formatter);
    return result;
}

+ (NSDate *) dateWithISO8601String:(NSString *) string
{
    if(!string) 
        return nil;
    
    if([string hasSuffix:@" 00:00"])
        string = [[string substringToIndex:(string.length-6)] stringByAppendingString:@"GMT"];
    else if ([string hasSuffix:@"Z"])
        string = [[string substringToIndex:(string.length-1)] stringByAppendingString:@"GMT"];
     
    return [NSDate date:string format:@"yyyy-MM-dd'T'HH:mm:ssZZZ" locale:nil];
}

+ (NSDate *) dateWithDateString:(NSString *) string
{
    return [NSDate date:string format:@"yyyy-MM-dd" locale:nil];
}

+ (NSDate *) dateWithDateTimeString:(NSString *) string
{
    return [NSDate date:string format:@"yyyy-MM-dd HH:mm:ss" locale:nil];
}

+ (NSDate *) dateWithLongDateTimeString:(NSString *) string 
{
    return [self dateWithLongDateTimeString: string locale:nil];
}

+ (NSDate *) dateWithLongDateTimeString:(NSString *) string locale:(NSLocale *)locale
{
    return [NSDate date:string format:@"dd MMM yyyy HH:mm:ss" locale:locale];
}

+ (NSDate *) dateWithRSSDateString:(NSString *) string
{
    if ([string hasSuffix:@"Z"])
        string = [[string substringToIndex:(string.length-1)] stringByAppendingString:@"GMT"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSDate * result = [NSDate date:string format:@"EEE, d MMM yyyy HH:mm:ss ZZZ" locale:locale];
    KX_RELEASE(locale);
    return result;
}

+ (NSDate *) dateWithAltRSSDateString:(NSString *) string
{
    if ([string hasSuffix:@"Z"])
        string = [[string substringToIndex:(string.length-1)] stringByAppendingString:@"GMT"];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];    
    NSDate * result = [NSDate date:string format:@"d MMM yyyy HH:mm:ss ZZZ" locale:locale];
    KX_RELEASE(locale);
    return result;    
}

+ (NSDate *) dateWithHTTPDateString:(NSString *) string
{
    // http://www.w3.org/Protocols/rfc2616/rfc2616-sec3.html#sec3.3.1
    // Sun, 06 Nov 1994 08:49:37 GMT  ; RFC 822, updated by RFC 1123
    // Sunday, 06-Nov-94 08:49:37 GMT ; RFC 850, obsoleted by RFC 1036
    // Sun Nov  6 08:49:37 1994       ; ANSI C's asctime() format    
    
    
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    
    NSDate *result;
    
    result = [NSDate date:string format:@"EEE, d MMM yyyy HH:mm:ss zzz" locale:locale];
    if (!result) {
        result = [NSDate date:string format:@"EEEE, d-MMM-yy HH:mm:ss zzz" locale:locale];
        if (!result) {
            result = [NSDate date:string format:@"EEE MMM d HH:mm:ss yyyy" locale:locale];
        }
    }
    
    KX_RELEASE(locale);
    return result;
}



- (NSString *)formattedDateStyle:(NSDateFormatterStyle) dateStyle 
                       timeStyle:(NSDateFormatterStyle) timeStyle
                        timeZone:(NSTimeZone *) tz
                         locale :(NSLocale *)locale; 
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (locale)
        [formatter setLocale:locale];
    [formatter setDateStyle:dateStyle];
    [formatter setTimeStyle:timeStyle];    
    if (tz)
        [formatter setTimeZone:tz];
    
    NSString * s = [formatter stringFromDate:self];    
    KX_RELEASE(formatter);
    return s;
}

- (NSString *)formattedDateStyle:(NSDateFormatterStyle) dateStyle 
                       timeStyle:(NSDateFormatterStyle) timeStyle
                        timeZone:(NSTimeZone *) tz
{
    return [self formattedDateStyle:dateStyle 
                          timeStyle:timeStyle 
                           timeZone:tz 
                             locale:nil];
}

- (NSString *)formattedDatePattern:(NSString *) datePattern                              
                          timeZone:(NSTimeZone *) tz 
                            locale:(NSLocale *)locale;
{        
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];    
    
    if (locale)
        [formatter setLocale:locale];
    [formatter setDateFormat:datePattern];    
    if (tz)
        [formatter setTimeZone:tz];
    
    NSString * s = [formatter stringFromDate:self];    
    KX_RELEASE(formatter);
    return s;
}

- (NSString *)formattedDatePattern:(NSString *) datePattern                              
                          timeZone:(NSTimeZone *) tz;
{        
    return [self formattedDatePattern:datePattern timeZone:tz locale:nil];
}

- (NSString *) shortRelativeFormatted
{
    NSTimeInterval time = [self timeIntervalSince1970];
    NSTimeInterval now  = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval seconds = time - now;
    
    BOOL inPast = seconds < 0;
    
    seconds = fabs(seconds);
    
    if (seconds < 10)
        return locString(@"now");	
    
    if (seconds < 60)
        return [NSString stringWithFormat: inPast ? @"%ds" : @"+%ds", (int)seconds];
    
    int minutes = round(seconds/60);
    
    if (minutes < 75)
        return [NSString stringWithFormat: inPast ? @"%dm" : @"+%dm", minutes];
    
    if ([self isToday]) 
        return [self formattedDatePattern:@"today HH:mm" timeZone:nil];    
    
    return [self dateFormatted];	
}

- (NSString*) daysRelativeFormatted
{       
    NSInteger days = [[NSDate date] daysBetweenDate:self];
    
    if (days > -2 && days < 2) {
    
        if ([self isToday])
            return locString(@"today");
        
        if ([self isYesterday])
            return locString(@"yesterday");
        
        if ([self isTomorrow])
            return locString(@"tomorrow");
        
        // BugCheck(@"Bugcheck, the data must be today, yesterday or tomorrow");
    }
    
    NSDateFormatter * formatter;
    formatter = KX_AUTORELEASE([[NSDateFormatter alloc] init]);
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterNoStyle];        
    
    if (days > 0 && days < 7) {
        NSInteger weekday = [[self YMDhms] weekday];
        return [[formatter weekdaySymbols] objectAtIndex: weekday - 1];
    }
    
    return [formatter stringFromDate:self];	
}

- (NSString *) iso8601Formatted 
{
    return [self formattedDatePattern:@"yyyy-MM-dd'T'HH:mm:ssZ" timeZone:nil];
}

- (NSString *) dateFormatted 
{
    return [self formattedDatePattern:@"yyyy-MM-dd" timeZone:nil];
}

- (NSString *) dateTimeFormatted 
{
    return [self formattedDatePattern:@"yyyy-MM-dd HH:mm:ss" timeZone:nil];
}

- (NSString *) longDateTimeFormatted 
{
    return [self longDateTimeFormatted:nil];
}

- (NSString *) longDateTimeFormatted:(NSLocale *)locale
{
    return [self formattedDatePattern:@"dd MMM yyyy HH:mm:ss" timeZone:nil locale:locale];
}

- (NSString *) RSSFormatted //:(NSLocale *)locale
{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    NSString * result = [self formattedDatePattern:@"EEE, d MMM yyyy HH:mm:ss ZZZ" 
                                          timeZone:nil 
                                            locale:locale];    
    KX_RELEASE(locale);
    return result;
}

- (NSString *) AltRSSFormatted
{
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];    
    NSString * result = [self formattedDatePattern:@"d MMM yyyy HH:mm:ss ZZZ" 
                                          timeZone:nil 
                                            locale:locale];    
    KX_RELEASE(locale);
    return result;    
}

@end
