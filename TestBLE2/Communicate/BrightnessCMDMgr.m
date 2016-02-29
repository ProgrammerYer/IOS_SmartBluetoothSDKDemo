//
//  BrightnessInfoReciveCMD.m
//  LedWifi
//
//  Created by luoke on 12-12-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BrightnessCMDMgr.h"
#import "BrightnessStateInfo.h"
#import "ColorTemperatureStateInfo.h"



@implementation BrightnessCMDMgr


//【0X66】+【8bit设备名(0x02)，若返回（0X03）则禁用色温滑条】+【8bit开/关机】+【8bit模式值】+【8bit运行/暂停状态】+ 【8bit速度值】＋【8bit灰度数据】＋【8bit色温数据，若返回设备值为0x03，则该值为0x00】＋【0x00】+【0x00】＋【0X99】
//【0X66】+【8bit设备名(0x01)】+【8bit开/关机】+【8bit模式值】+【8bit运行/暂停状态】+ 【8bit速度值】＋【8bit灰度数据】＋【0x00】＋【0x00】+【0x00】+【0x00】＋【0X99】
+(BrightnessStateInfo*)getBrightnessStateInfoByData:(NSData*)data
{
    BrightnessStateInfo *dev = nil;
    
    Byte *buff = (Byte*)[data bytes];
    if (buff[0] == 0x66 && buff[11]==0x99)
    {
        dev = [[[BrightnessStateInfo alloc] init] autorelease];
        if (buff[2]==0x23) {
            [dev setIsOpen:YES];
        }
        else {
            [dev setIsOpen:NO];
        }
        
        //【8bit模式值】定義：gradual漸變 (0x3A)        FLASH频闪=60 (0x3C)      NONE(定义为0x41)
        if (buff[3] == 0x3A) {
            [dev setRunModeType:LEDRunMode_gradual];
        }
        else if (buff[3] == 0x3C)
        {
            [dev setRunModeType:LEDRunMode_FLASH];
        }else {
            [dev setRunModeType:LEDRunMode_NONE];
        }
        
        
        if (buff[4]==0x21) {
            [dev setIsRunning:YES];
        }
        else {
            [dev setIsRunning:NO];
        }
        
        //【8bit速度值】定義：0x01--0x1F   (0~31)
        [dev setSpeed:32-buff[5]];

        //【8bit灰度数据】定義：(就是亮度)   0x00--0xFF  (0~256)
        [dev setLightValue:buff[6]];
    }
    return dev;
}

//【0X66】+【8bit设备名(0x02)】+【8bit开/关机】+【8bit模式值】+【8bit运行/暂停状态】+ 【8bit速度值】＋【8bit暖色数据】＋【8bit冷色数据】＋【0x00】＋【0x00】+【0x00】＋【0X99】
+(ColorTemperatureStateInfo*)getColorTemperatureStateInfoByData:(NSData*)data
{
    ColorTemperatureStateInfo *dev = nil;
    
    Byte *buff = (Byte*)[data bytes];
    if (buff[0] == 0x66 && buff[11]==0x99)
    {
        dev = [[[ColorTemperatureStateInfo alloc] init] autorelease];
        if (buff[2]==0x23) {
            [dev setIsOpen:YES];
        }
        else {
            [dev setIsOpen:NO];
        }
        
        //【8bit模式值】定義：
//        warm gradual	0x3A
//        cool gradual	0x4A
//        warm flash	0x3C
//        cool flash	0x4C
        if (buff[3] == 0x3A) {
            [dev setRunModeType:LEDColorTempMode_warm_gradual];
        }
        else if (buff[3] == 0x4A)
        {
            [dev setRunModeType:LEDColorTempMode_cool_gradual];
        }
        else if (buff[3] == 0x3C)
        {
            [dev setRunModeType:LEDColorTempMode_warm_flash];
        }
        else if (buff[3] == 0x4C)
        {
            [dev setRunModeType:LEDColorTempMode_cool_flash];
        }
        else {
            [dev setRunModeType:LEDColorTempMode_NONE];
        }
        
        
        if (buff[4]==0x21) {
            [dev setIsRunning:YES];
        }
        else {
            [dev setIsRunning:NO];
        }
        
        //【8bit速度值】定義：0x01--0x1F   (0~31)
        [dev setSpeed:32-buff[5]];
        
        //【8bit暖色数据】   0x00--0xFF  (0~256)
        [dev setWarmValue:buff[6]];
        
        //【8bit冷色数据】   0x00--0xFF  (0~256)
        [dev setCoolValue:buff[7]];
    }
    return dev;
}

+(NSData*)getCommondDataForQuery
{
    //【0XEF】+【0X01】+【0X77】
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    
    Byte *bytes = malloc(3);
    bytes[0] = 0xEF;
    bytes[1] = 0X01;
    bytes[2] = 0X77;
    
    [data appendBytes:bytes length:3];

    free(bytes);
    
    return data;
}

//【0XCC】＋【8bit键值】＋【0X33】
+(NSData*)getCommondDataForSwithOpen:(BOOL)open
{
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    
    Byte *bytes = malloc(3);
    bytes[0] = 0xCC;
    bytes[1] = (open)? 0x23 : 0x24 ;
    bytes[2] = 0X33;
    
    [data appendBytes:bytes length:3];
    
    free(bytes);
    
    return data;
}

//【0XCC】＋【8bit键值】＋【0X33】
+(NSData*)getCommondDataForSwithRunning:(BOOL)running
{
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    
    Byte *bytes = malloc(3);
    bytes[0] = 0xCC;
    bytes[1] = (running)? 0x21 : 0x20 ;
    bytes[2] = 0X33;
    
    [data appendBytes:bytes length:3];
    
    free(bytes);
    
    return data;
}

/**
 * 发送单色设备亮度  【0X56】＋【8bit灰度数据】+【0XAA】
 */
+(NSData*)getCommondDataForLight:(int16_t)value
{
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    
    Byte *bytes = malloc(3);
    bytes[0] = 0x56;
    bytes[1] = value;
    bytes[2] = 0XAA;
    
    [data appendBytes:bytes length:3];
    
    free(bytes);
    
    return data;
}

//【0xBB】＋【8bit模式值】＋【8bit速度值】＋【0X44】
//gradual漸變 (0x3A)        FLASH频闪=60 (0x3C)      NONE(定义为0x41)
+(NSData*)getCommondDataForMode:(LEDRunModeType)mode  speed:(int16_t)speed
{
    speed = 32 - speed;//显示数字左边1，但发31给我，右边显示31，但发1给我。
    
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    
    Byte *bytes = malloc(4);
    bytes[0] = 0xBB;
    if (mode == LEDRunMode_FLASH) {
        bytes[1] = 0x3C;
    }
    else if (mode == LEDRunMode_gradual)
    {
        bytes[1] = 0x3A;
    }
    else {
        bytes[1] = 0x41;
    }
    
    bytes[2] = speed;
    bytes[3] = 0X44;
    
    [data appendBytes:bytes length:4];
    
    free(bytes);
    
    return data;
}

//【【0xBB】＋【8bit模式值】＋【8bit速度值】＋【0X44】
//        warm gradual	0x3A
//        cool gradual	0x4A
//        warm flash	0x3C
//        cool flash	0x4C
+(NSData*)getCommondDataForColorTemperatureMode:(LEDRunModeType)mode  speed:(int16_t)speed
{
    speed = 32 - speed;//显示数字左边1，但发31给我，右边显示31，但发1给我。
    
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    
    Byte *bytes = malloc(4);
    bytes[0] = 0xBB;
    if (mode == LEDColorTempMode_warm_gradual) {
        bytes[1] = 0x3A;
    }
    else if (mode == LEDColorTempMode_cool_gradual)
    {
        bytes[1] = 0x4A;
    }
    else if (mode == LEDColorTempMode_warm_flash)
    {
        bytes[1] = 0x3C;
    }
    else {
        bytes[1] = 0x4C;
    }
    
    bytes[2] = speed;
    bytes[3] = 0X44;
    
    [data appendBytes:bytes length:4];
    
    free(bytes);
    
    return data;
}

/**
 * 发送 暖冷色 【0X56】＋【8bit暖色数据】＋【8bit冷色数据】+【0XAA】
 */
+(NSData*)getCommondDataForWarmValue:(int16_t)warmValue coolValue:(int16_t)coolValue
{
    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
    
    Byte *bytes = malloc(4);
    bytes[0] = 0x56;
    bytes[1] = warmValue;
    bytes[2] = coolValue;
    bytes[3] = 0XAA;
    
    [data appendBytes:bytes length:4];
    
    free(bytes);
    
    return data;
}


//+(NSData*)getCommondDataForWarmValueTest:(int16_t)warmValue coolValue:(int16_t)coolValue
//{
//    NSMutableData *data = [[[NSMutableData alloc] init] autorelease];
//    
//    Byte *bytes = malloc(5);
//    bytes[0] = 0x56;
//    bytes[1] = warmValue;
//    bytes[2] = coolValue;
//    bytes[3] = 0XAA;
//    bytes[4] = 0XAA;
//    
//    [data appendBytes:bytes length:5];
//    
//    free(bytes);
//    
//    return data;
//}


@end
