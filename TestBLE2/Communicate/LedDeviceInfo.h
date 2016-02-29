//
//  DeviceInfo.h
//  LedWifi
//
//  Created by luoke on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConfig.h"

typedef NS_ENUM(NSInteger, Connection_status) {
    Connection_status_Connected,                   // don't show any acces
    Connection_status_Connecting,
    Connection_status_Failed
};
@interface LedDeviceInfo : NSObject


@property(strong) NSString *macAddress;
@property(strong) NSString *localName;
//@property(assign) int connection_status;
@property(assign) BOOL isSelected;
//@property(assign) int tryConnectonCount;
@property(strong) NSString *moduleID;
@property(assign) int levVersionNum;


@property LEDDeviceType deviceType;
//@property(strong,nonatomic) NSString *deviceName;
@property(strong,nonatomic) NSString *groupUniID;

//-(BOOL)isEnable;
//
//-(BOOL)isZJ001Mode;


+(NSArray*)sortByDevcieMac:(NSArray*)srcDeviceList;
@end
