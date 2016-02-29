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

//【0X66】+【8bit设备名(0x02)，若返回（0X03）则禁用色温滑条】+【8bit开/关机】+【8bit模式值】+【8bit运行/暂停状态】+ 【8bit速度值】＋【8bit灰度数据】＋【8bit色温数据，若返回设备值为0x03，则该值为0x00】＋【0x00】+【0x00】＋【0X99】

@interface BrightnessStateInfo : DeviceStateInfoBase



@property LEDRunModeType runModeType;  //【8bit模式值】定義：gradual漸變 (0x3A)        FLASH频闪=60 (0x3C)      NONE(定义为0x41)
@property int Speed;
@property int lightValue;  //亮度


@end
