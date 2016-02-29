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

//【0X66】+【8bit设备名(0x02)】+【8bit开/关机】+【8bit模式值】+【8bit运行/暂停状态】+ 【8bit速度值】＋【8bit暖色数据】＋【8bit冷色数据】＋【0x00】＋【0x00】+【0x00】＋【0X99】

@interface ColorTemperatureStateInfo : DeviceStateInfoBase


@property LEDColorTempModeType runModeType; 
@property int Speed;
@property int WarmValue;  //暖色
@property int CoolValue;  //冷色

@end
