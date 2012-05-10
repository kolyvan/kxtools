//
//  ru.kolyvan.repo
//  https://github.com/kolyvan
//  

//  Copyright (C) 2012, Konstantin Boukreev (Kolyvan)

//  Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

#import <Foundation/Foundation.h>


@interface NSDate (Kolyvan)

@property (nonatomic, readonly) NSInteger year;
@property (nonatomic, readonly) NSInteger month;
@property (nonatomic, readonly) NSInteger day;
@property (nonatomic, readonly) NSInteger hour;
@property (nonatomic, readonly) NSInteger minute;
@property (nonatomic, readonly) NSInteger second;

@property (nonatomic, readonly) NSDateComponents * YMD;
@property (nonatomic, readonly) NSDateComponents * hms;
@property (nonatomic, readonly) NSDateComponents * YMDhms; // year, month, day, hour, minute, seconds
@property (nonatomic, readonly) NSDateComponents * YMDhms_GMT;


- (NSDate *) addSeconds:(NSInteger) seconds;
- (NSDate *) addMinutes:(NSInteger) minutes;
- (NSDate *) addHours:(NSInteger) hours;
- (NSDate *) addDays:(NSInteger) days;
- (NSDate *) addMonths:(NSInteger) months;
- (NSDate *) addYears:(NSInteger) years;

- (NSDate *) addYears:(NSInteger) years 
               months:(NSInteger) months 
                 days:(NSInteger) days 
                hours:(NSInteger) hours
              minutes:(NSInteger) minutes 
              seconds:(NSInteger) seconds;


- (NSDate *) midnight;

- (BOOL) isSameDay:(NSDate *) other;
- (BOOL) isToday;
- (BOOL) isPast;
- (BOOL) isYesterday;
- (BOOL) isTomorrow;

- (NSInteger) daysBetweenDate:(NSDate *) other;
- (NSInteger) dayOfYear;

+ (NSDate *) yesterday;
+ (NSDate *) tomorrow;
 
+ (NSDate *) year:(NSUInteger) year
            month:(NSUInteger) month
              day:(NSUInteger) day
             hour:(NSUInteger) hour
           minute:(NSUInteger) minute
           second:(NSUInteger) second              
         timeZone:(NSTimeZone *) tz;

+ (NSDate *) date:(NSDate *) date time:(NSDate *) time; 

//// from string

+ (NSDate *) date:(NSString *) string format:(NSString *) format;

+ (NSDate *) dateWithISO8601String:(NSString *) str;        // ISO8610 format, aka ATOM: yyyy-MM-dd'T'HH:mm:ssZZZ 
+ (NSDate *) dateWithDateString:(NSString *) str;           // 'yyyy-MM-dd'
+ (NSDate *) dateWithDateTimeString:(NSString *) str;       // 'yyyy-MM-dd HH:mm:ss'
+ (NSDate *) dateWithLongDateTimeString:(NSString *) str;   // 'dd MMM yyyy HH:mm:ss'
+ (NSDate *) dateWithRSSDateString:(NSString *) str;        // RSS (RFC 822): 'EEE, d MMM yyyy HH:mm:ss ZZZ'
+ (NSDate *) dateWithAltRSSDateString:(NSString *) str;     // alternative RSS: 'd MMM yyyy HH:mm:ss ZZZ'
+ (NSDate *) dateWithHTTPDateString:(NSString *) str; 

+ (NSDate *) date:(NSString *) string 
           format:(NSString* ) format 
           locale:(NSLocale *)locale
         timeZone:(NSTimeZone *) tz;

+ (NSDate *) date:(NSString *) string 
           format:(NSString* ) format 
           locale:(NSLocale *)locale;


+ (NSDate *) dateWithLongDateTimeString:(NSString *) str locale:(NSLocale *)locale;

//// to string

- (NSString *) formattedDateStyle:(NSDateFormatterStyle) dateStyle 
                        timeStyle:(NSDateFormatterStyle) timeStyle 
                         timeZone:(NSTimeZone *) tz;

- (NSString *) formattedDatePattern:(NSString *) datePattern 
                           timeZone:(NSTimeZone *) tz;


- (NSString *) shortRelativeFormatted;
- (NSString *) daysRelativeFormatted;

- (NSString *) iso8601Formatted; // ISO8601/ATOM: yyyy-MM-dd'T'HH:mm:ssZZZ
- (NSString *) dateFormatted;
- (NSString *) dateTimeFormatted; 
- (NSString *) longDateTimeFormatted; 
- (NSString *) RSSFormatted; 
- (NSString *) AltRSSFormatted; 

- (NSString *) formattedDateStyle:(NSDateFormatterStyle) dateStyle 
                        timeStyle:(NSDateFormatterStyle) timeStyle 
                         timeZone:(NSTimeZone *) tz
                          locale :(NSLocale *)locale;

- (NSString *) formattedDatePattern:(NSString *) datePattern 
                           timeZone:(NSTimeZone *) tz
                            locale :(NSLocale *)locale;

- (NSString *) longDateTimeFormatted: (NSLocale *)locale ; 


@end
