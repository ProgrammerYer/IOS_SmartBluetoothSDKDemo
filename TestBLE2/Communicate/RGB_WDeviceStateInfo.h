//
//  DeviceStateInfo.h
//  LedWifi
//
//  Created by luoke on 12-12-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConfig.h"
#import "DeviceStateInfoBase.h"

//【【0X66】+【8bit设备名(0x04)】+【8bit开/关机】+【8bit模式值】+【8bit运行/暂停状态】+ 【8bit速度值】＋【8bit红色数据】＋【8bit绿色数据】＋【8bit蓝色数据】+【8bit暖白数据】+【0X00】＋【0X99】
//【8bit模式值】  为1--20/MANUAL和NONE(定义为0x41)   
//1	0x25
//2	0x26
//3	0x27
//4	0x28
//5	0x29
//6	0x2A
//7	0x2B
//8	0x2C
//9	0x2D
//10	0x2E
//11	0x2F
//12	0x30
//13	0x31
//14	0x32
//15	0x33
//16	0x34
//17	0x35
//18	0x36
//19	0x37
//20	0x38
//Manual	0x39
//None	0x41


@interface RGB_WDeviceStateInfo : DeviceStateInfoBase


@property int Speed;
@property int lightValue;  //亮度
@property (strong) UIColor *color;
@property Byte modeValue;   //内置模式（1～20）

@property(nonatomic) Byte warmWhite;
@end
