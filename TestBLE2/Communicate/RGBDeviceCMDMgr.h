//
//  BrightnessInfoReciveCMD.h
//  LedWifi
//
//  Created by luoke on 12-12-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RGBDeviceStateInfo.h"
#import "RGB_WDeviceStateInfo.h"

@class CustomMode;

@interface RGBDeviceCMDMgr : NSObject

+(RGBDeviceStateInfo*)getRGBDeviceStateInfoByData:(NSData*)data;

+(RGB_WDeviceStateInfo*)getRGBWDeviceStateInfoByData:(NSData*)data;

+(DeviceStateInfoBase*)getDeviceStateInfoBaseByData:(NSData*)data;
+(CustomMode*)getCustomModeForShareByData:(NSData*)data;

+(NSDate*)getTimeByData:(NSData*)data;
+(NSDate*)getTimeByDataForTimerBugV5:(NSData*)data;

+(NSData*)getCommondDataForQuery;

//【0XCC】＋【8bit键值】＋【0X33】
+(NSData*)getCommondDataForSwithOpen:(BOOL)open;

//【0XCC】＋【8bit键值】＋【0X33】
+(NSData*)getCommondDataForSwithRunning:(BOOL)running;

+(NSData*)getCommondDataForOpenTimer;

+(NSData*)getCommondDataForCloseTimer;

/**
 * 发送单色设备亮度  【0X56】＋【8bit灰度数据】+【0XAA】
 */
+(NSData*)getCommondDataForLight:(int16_t)value;

//按 色環
//【0X56】＋【8bit红色数据】＋【8bit绿色数据】＋【8bit蓝色数据】＋【0XAA】
+(NSData*)getCommandDataForRGBWColor:(UIColor*)color warmWhile:(Byte)warmWhile;

+(NSData*)getCommandDataForRGBColor:(UIColor*)color;
+(NSData*)getCommandDataForMusicColorRGBW2:(UIColor*)color;
+(NSData*)getCommandDataForMusicColorRGB:(UIColor*)color;

//发送RGB设备模式和速度 (按 + - 模式、速度的Bar)
//命令：【0xBB】＋【8bit模式值】＋【8bit速度值】＋【0X44】
+(NSData*)getCommondDataForModeBuiltIn:(int8_t)modeBuiltin  speed:(int8_t)speed;

+(NSData*)getCommondDataForCustomModeByColors:(CustomMode*)csmode
                                        speed:(int)Speed   
                                     runModel:(LEDRunModeType)runModel;

//+(NSData*)getCommandDataForRGBW2ByColor:(UIColor*)color;
//+(NSData*)getCommandDataForRGBW2ByWarmWhile:(Byte)warmWhile;

+(NSData*)getCommandDataForRGBW2ByColor:(UIColor*)color warmWhile:(Byte)warmWhile;
+(NSData*)getCommandDataForRGBW2ByWarmWhile:(Byte)warmWhile color:(UIColor*)color;

+(NSData*)getCommandDataForWarmWhileForCCT_Bulb:(Byte)warmWhile;
+(NSData*)getCommandDataForCoolWhileForCCT_Bulb:(Byte)coolWhite;

+(NSData*)getCommondDataForWarmValue:(int16_t)warmValue coolValue:(int16_t)coolValue;


+(NSData*)getCommandDataForRGBWUFOByColor:(UIColor*)color;
+(NSData*)getCommandDataForRGBWUFOByWarmWhile:(Byte)warmWhile;
//+(NSData*)getCommandDataForMusicRGBWUFO:(UIColor*)color warmWhile:(Byte)warmWhile;
+(NSData*)getCommandDataForMusicRGBWUFOByColor:(UIColor*)color;

//----------------------新版协议定时
+(NSData*)getCommondDataForQuerySettingTimes;

+(NSArray*)getTimerDetailItemsByData:(NSData*)data;
+(NSData*)getCommondDataForQueryCurrentDataTime;
+(NSData*)getCommondDataForSetTimerItems:(NSArray*)items;
+(NSData*)getCommondDataForSetTimeByyearFrom2000:(int)yearFrom2000 month:(int)month day:(int)day hour:(int)hour  minute:(int)minute sec:(int)sec week:(int)week;

+(NSArray*)getTimerDetailItemsByDataForTimerBugV5:(NSData*)data;

+(NSData*)getCommondDataForSetTimerItemsForTimerBugV5:(NSArray*)items;

+(NSData*)getCommondDataForCustomModeForShareByColors:(CustomMode*)csmode
                                          speedPerent:(float)speedPerent
                                             runModel:(LEDRunModeType)runModel;
@end
