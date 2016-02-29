//
//  BrightnessInfoReciveCMD.h
//  LedWifi
//
//  Created by luoke on 12-12-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BrightnessStateInfo.h"

@class BrightnessStateInfo;
@class ColorTemperatureStateInfo;

@interface BrightnessCMDMgr : NSObject

+(BrightnessStateInfo*)getBrightnessStateInfoByData:(NSData*)data;

+(NSData*)getCommondDataForQuery;
+(NSData*)getCommondDataForSwithOpen:(BOOL)open;
+(NSData*)getCommondDataForSwithRunning:(BOOL)running;

/**
 * 发送单色设备亮度  【0X56】＋【8bit灰度数据】+【0XAA】
 */
+(NSData*)getCommondDataForLight:(int16_t)value;
//【0xBB】＋【8bit模式值】＋【8bit速度值】＋【0X44】
//gradual漸變 (0x3A)        FLASH频闪=60 (0x3C)      NONE(定义为0x41)
+(NSData*)getCommondDataForMode:(LEDRunModeType)mode  speed:(int16_t)speed;

//【【0xBB】＋【8bit模式值】＋【8bit速度值】＋【0X44】
//        warm gradual	0x3A
//        cool gradual	0x4A
//        warm flash	0x3C
//        cool flash	0x4C
+(NSData*)getCommondDataForColorTemperatureMode:(LEDRunModeType)mode  speed:(int16_t)speed;

//【0X66】+【8bit设备名(0x02)】+【8bit开/关机】+【8bit模式值】+【8bit运行/暂停状态】+ 【8bit速度值】＋【8bit暖色数据】＋【8bit冷色数据】＋【0x00】＋【0x00】+【0x00】＋【0X99】
+(ColorTemperatureStateInfo*)getColorTemperatureStateInfoByData:(NSData*)data;

+(NSData*)getCommondDataForWarmValue:(int16_t)warmValue coolValue:(int16_t)coolValue;


//+(NSData*)getCommondDataForWarmValueTest:(int16_t)warmValue coolValue:(int16_t)coolValue;
@end
