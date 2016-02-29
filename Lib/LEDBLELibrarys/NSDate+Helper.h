//
//  NSDate+Helper.h
//  SMBTracer
//
//  Created by  mac on 11-4-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSDate (Helper)

- (NSUInteger)daysAgo;
- (NSUInteger)daysAgoAgainstMidnight;
- (NSString *)stringDaysAgo;
- (NSString *)stringDaysAgoAgainstMidnight:(BOOL)flag;
- (NSUInteger)weekday;

+ (NSDate *)dateFromString:(NSString *)string;
+ (NSDate *)dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date;
+ (NSString *)stringForDisplayFromDate:(NSDate *)date prefixed:(BOOL)prefixed;

- (NSString *)string;
- (NSString *)stringWithFormat:(NSString *)format;
- (NSString *)stringWithDateStyle:(NSDateFormatterStyle)dateStyle timeStyle:(NSDateFormatterStyle)timeStyle;

- (NSDate *)beginningOfWeek;
- (NSDate *)beginningOfDay;
- (NSDate *)endOfWeek;

+ (NSString *)dateFormatString;
+ (NSString *)timeFormatString;
+ (NSString *)timestampFormatString;
+ (NSString *)dbFormatString;


//多少月前的日期
+(NSDate *)getPriousDateFromDate:(NSDate *)date withMonth:(int)mont;
-(NSInteger)DifferentMonthToDate:endDate;
-(NSInteger)DifferentYearsToDate:endDate;

+(NSDate*)ComposeDateAndTime:(NSDate*)time date:(NSDate*)date;

-(NSDateComponents*)getDateComponents;

//返回 1天前（後）  1個月前（後）
-(NSString*)howLondAfterOrBeforeInfo;

-(NSDate*)dateByAddingMinute:(int)minute;

@end





