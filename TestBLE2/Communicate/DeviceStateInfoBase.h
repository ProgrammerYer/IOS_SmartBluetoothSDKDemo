//
//  DeviceStateInfoBase.h
//  LedBLEv2
//
//  Created by luoke365 on 1/2/14.
//  Copyright (c) 2014 luoke365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConfig.h"

@interface DeviceStateInfoBase : NSObject


@property BOOL isOpen;
@property BOOL isRunning;
@property int versionNum;
@property LEDDeviceType deviceType;

@end
