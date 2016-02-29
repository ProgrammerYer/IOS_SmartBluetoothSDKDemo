//
//  TimerDetailItem.m
//  LedWiFiMagicUFO
//
//  Created by luoke365 on 4/24/14.
//  Copyright (c) 2014 luoke365. All rights reserved.
//

#import "TimerDetailItem.h"
#import "AppConfig.h"
#import "NSDate+Helper.h"
#import "NSDate+TKCategory.h"

@implementation TimerDetailItem

-(id)init
{
    self = [super init];
    if (self) {
        
        self.enableTimer = YES;
        self.yearFrom2000 = 0;
        self.month = 0;
        self.day = 0;
        self.hour = 0;
        self.mintue = 0;
        self.sec = 0;
        self.week = 0;
        self.modeValue = 0;
        self.value1 = 0;
        self.value2 = 0;
        self.value3 = 0;
        self.value4 = 0;
        self.powerON = NO;
        
        self.uniID = [AppConfig createUUID];
    }
    return self;
}

+(TimerDetailItem*)timerDetailWithCreateForAfterMinute:(int)afterMinute
{
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *ps = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSWeekdayCalendarUnit
                            | NSHourCalendarUnit| NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:[now dateByAddingTimeInterval:60*afterMinute]];
    
    TimerDetailItem *itm = [[TimerDetailItem alloc] init];
    itm.yearFrom2000 = (int)ps.year - 2000;
    itm.month = (int)ps.month;
    itm.day = (int)ps.day;
    itm.hour = (int)ps.hour;
    itm.mintue = (int)ps.minute;
    itm.sec = (int)ps.second;
    itm.week = 0;
    
    itm.modeValue = 0x00;
    
    return itm;
}
+(TimerDetailItem*)timerDetailWithCreateForAfterMinuteForOldBulbVer04:(int)afterMinute
{
    NSDate *now = [NSDate date];
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *ps = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSWeekdayCalendarUnit
                            | NSHourCalendarUnit| NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:[now dateByAddingTimeInterval:60*afterMinute]];
    
    TimerDetailItem *itm = [[TimerDetailItem alloc] init];
    itm.yearFrom2000 = (int)ps.year - 2000;
    itm.month = (int)ps.month;
    itm.day = (int)ps.day;
    itm.hour = (int)ps.hour;
    itm.mintue = (int)ps.minute;
    itm.sec = (int)ps.second;
    itm.week = 0;
    
    itm.modeValue = 0x41;
    itm.value4 = 0xFF;
    
    return itm;
}


-(void)setTimerByhour:(int)hour minute:(int)minute
{
    BOOL *checkWeeks7 = [self getCheckWeeks7_Malloc];
    [self setTimerByhour:hour minute:minute checkWeeks7:checkWeeks7];
    free(checkWeeks7);
}
-(void)setTimerByhour:(int)hour minute:(int)minute   checkWeeks7:(BOOL*)checkWeeks7
{
    if ([TimerDetailItem checkIsOneTimeBycheckWeeks:checkWeeks7]) {
        //设置一次性，要判断再当前时间之前/或者之后
        NSDate *now = [NSDate date];
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *ps = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit
                                | NSHourCalendarUnit| NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
        
        ps.hour = hour;
        ps.minute = minute;
        ps.second = 0;
        
        NSDate *hitDate = [gregorian dateFromComponents:ps];
        if ([hitDate compare:now] ==NSOrderedAscending) {
            hitDate = [hitDate dateByAddingDays:1];
        }

        
        NSDateComponents *psHit = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit
                                | NSHourCalendarUnit| NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:hitDate];
        
        self.yearFrom2000 = (int)psHit.year - 2000;
        self.month = (int)psHit.month;
        self.day = (int)psHit.day;
        self.hour = (int)psHit.hour;
        self.mintue = (int)psHit.minute;
        self.sec = (int)psHit.second;
        self.week = [self getWeekBycheckWeeks7Bit:checkWeeks7];
        
    }
    else if ([TimerDetailItem checkIsEveryDayBycheckWeeks:checkWeeks7])
    {
        self.yearFrom2000 = 0;
        self.month = 0;
        self.day = 0;
        self.hour = hour;
        self.mintue = minute;
        
        self.sec = 0;
        self.week = [self getWeekBycheckWeeks7Bit:checkWeeks7];
    }
    else
    {
        //每星期几
        self.yearFrom2000 = 0;
        self.month = 0;
        self.day = 0;
        self.hour = hour;
        self.mintue = minute;
        
        self.sec = 0;
        self.week = [self getWeekBycheckWeeks7Bit:checkWeeks7];
    }
}

-(void)setModeValue:(Byte)modeValue value1:(Byte)value1 value2:(Byte)value2 value3:(Byte)value3 value4:(Byte)value4
{
    self.modeValue = modeValue;
    self.value1 = value1;
    self.value2 = value2;
    self.value3 = value3;
    self.value4 = value4;
}

-(void)setPowerON:(BOOL)powerON
{
    _powerON = powerON;
    if (!self.powerON) {
        self.modeValue = 0;
        self.value1 = 0;
        self.value2 = 0;
        self.value3 = 0;
        self.value4 = 0;
    }
}
-(void)setPowerONForOlbBulbVer04:(BOOL)powerON
{
    _powerON = powerON;
    if (!self.powerON)
    {
        self.modeValue = 0x41;
        self.value1 = 0;
        self.value2 = 0;
        self.value3 = 0;
        self.value4 = 0xFF;
    }
}



-(BOOL*)getCheckWeeks7_Malloc
{
    BOOL *checkWeeks7 = malloc(7);
    checkWeeks7[0] = (self.week & (Byte)pow(2, 1))==pow(2, 1);
    checkWeeks7[1] = (self.week & (Byte)pow(2, 2))==pow(2, 2);
    checkWeeks7[2] = (self.week & (Byte)pow(2, 3))==pow(2, 3);
    checkWeeks7[3] = (self.week & (Byte)pow(2, 4))==pow(2, 4);
    checkWeeks7[4] = (self.week & (Byte)pow(2, 5))==pow(2, 5);
    checkWeeks7[5] = (self.week & (Byte)pow(2, 6))==pow(2, 6);
    checkWeeks7[6] = (self.week & (Byte)pow(2, 7))==pow(2, 7);

    
    return checkWeeks7;
}


-(BOOL)isCheckEffective
{
//    if (!self.enableTimer) {
//        return NO;
//    }
    BOOL isEffective = YES;
    BOOL *checkWeeks7 = [self getCheckWeeks7_Malloc];
    if ([TimerDetailItem checkIsOneTimeBycheckWeeks:checkWeeks7]) {
        
        NSDate *now = [NSDate date];
        NSCalendar *gregorian = [NSCalendar currentCalendar];
        NSDateComponents *ps = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit
                                | NSHourCalendarUnit| NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:now];
        
        ps.year = self.yearFrom2000 + 2000;
        ps.month = self.month;
        ps.day = self.day;
        ps.hour = self.hour;
        ps.minute = self.mintue;
        ps.second = self.sec;
        
        NSDate *hitDate = [gregorian dateFromComponents:ps];
        if ([hitDate compare:now] ==NSOrderedAscending) {
            isEffective = FALSE;
            goto destroy;
        }
    }
    
destroy:
    free(checkWeeks7);
    
    
    
    return isEffective;
}

-(Byte)getWeekBycheckWeeks7Bit:(BOOL*)checkWeeks7
{
    Byte b0_8 = 0;
    int bitIndex = 1;
    for (int i =0; i<7; i++) {
        BOOL ischeck = checkWeeks7[i];
        if (ischeck) {
            Byte b = 1<<bitIndex;
            b0_8 = b0_8 | b;
        }
        bitIndex ++;
    }
    return b0_8;
}

+(BOOL)checkIsEveryDayBycheckWeeks:(BOOL*)checkWeeks7
{
    for (int i=0; i<7; i++) {
        BOOL ischeck = checkWeeks7[i];
        if (!ischeck) {
            return NO;
        }
    }
    return YES;
}

+(BOOL)checkIsOneTimeBycheckWeeks:(BOOL*)checkWeeks7
{
    for (int i=0; i<7; i++) {
        BOOL ischeck = checkWeeks7[i];
        if (ischeck) {
            return NO;
        }
    }
    return YES;
}



-(id)copyWithZone:(NSZone *)zone
{
    TimerDetailItem *copy = [[[self class] allocWithZone:zone] init];
    copy.enableTimer = self.enableTimer;
    copy.yearFrom2000 = self.yearFrom2000;
    copy.month = self.month;
    copy.day = self.day;
    copy.hour = self.hour;
    copy.mintue = self.mintue;
    copy.sec = self.sec;
    copy.week = self.week;
    copy.modeValue = self.modeValue;
    copy.value1 = self.value1;
    copy.value2 = self.value2;
    copy.value3 = self.value3;
    copy.value4 = self.value4;
    copy.powerON = self.powerON;
    
    copy.uniID = self.uniID;
    return copy;
}
@end
