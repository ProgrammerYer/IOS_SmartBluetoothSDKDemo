//
//  TimerDetailItem.h
//  LedWiFiMagicUFO
//
//  Created by luoke365 on 4/24/14.
//  Copyright (c) 2014 luoke365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerDetailItem : NSObject

@property(assign,nonatomic) BOOL enableTimer;
@property(assign,nonatomic) int yearFrom2000;
@property(assign,nonatomic) int month;
@property(assign,nonatomic) int day;
@property(assign,nonatomic) int hour;
@property(assign,nonatomic) int mintue;
@property(assign,nonatomic) int sec;
@property(assign,nonatomic) Byte week;
@property(assign,nonatomic) Byte modeValue;
@property(assign,nonatomic) Byte value1;
@property(assign,nonatomic) Byte value2;
@property(assign,nonatomic) Byte value3;
@property(assign,nonatomic) Byte value4;
@property(assign,nonatomic) BOOL powerON;

@property(strong,nonatomic) NSString *uniID;


+(TimerDetailItem*)timerDetailWithCreateForAfterMinute:(int)afterMinute;
+(TimerDetailItem*)timerDetailWithCreateForAfterMinuteForOldBulbVer04:(int)afterMinute;

-(void)setTimerByhour:(int)hour minute:(int)minute   checkWeeks7:(BOOL*)checkWeeks7;

-(void)setModeValue:(Byte)modeValue value1:(Byte)value1 value2:(Byte)value2 value3:(Byte)value3 value4:(Byte)value4;
-(void)setTimerByhour:(int)hour minute:(int)minute;

-(void)setPowerON:(BOOL)powerON;
-(void)setPowerONForOlbBulbVer04:(BOOL)powerON;

-(BOOL*)getCheckWeeks7_Malloc;

-(BOOL)isCheckEffective;

-(Byte)getWeekBycheckWeeks7Bit:(BOOL*)checkWeeks7;

+(BOOL)checkIsEveryDayBycheckWeeks:(BOOL*)checkWeeks7;
+(BOOL)checkIsOneTimeBycheckWeeks:(BOOL*)checkWeeks7;
@end
