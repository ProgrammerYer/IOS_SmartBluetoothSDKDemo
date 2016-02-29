//
//  LEDCommandService.h
//  LedBLEv2
//
//  Created by luoke365 on 12/30/13.
//  Copyright (c) 2013 luoke365. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RGB_WDeviceStateInfo;
@class DeviceStateInfoBase;
@class BLEPeripheral;
@class TimerMaster;


@interface LEDCommandService : NSObject

//+(BOOL)SendPowerByUniID:(NSString*)uuID powerOn:(BOOL)powerON error:(NSError**)error;
//+(BOOL)TrySendAllPowerByUniIDs:(NSArray*)uuIDs powerOn:(BOOL)powerON error:(NSError**)error;
+(void)TrySendAllPowerByUniIDsForConnected:(NSArray*)uuIDs powerOn:(BOOL)powerON;

+(RGB_WDeviceStateInfo*)getRGB_WDeviceStateInfoForConnectedByUniID:(NSString*)uuID error:(NSError**)error;
+(DeviceStateInfoBase*)getDeviceStateInfoBaseByUniID:(NSString*)uuID error:(NSError**)error;

//+(int)getLEDDevieTypeByUniID:(NSString*)uuID error:(NSError**)error;
+(BOOL)getLoadPowerForConnectedByUniID:(NSString*)uniID error:(NSError**)error;

//+(void)SendDevicesPowerTryByUniID:(NSString*)uuID powerOn:(BOOL)powerON;
//+(void)SendDevicesPowerTryByUniIDs:(NSArray*)uuIDs powerOn:(BOOL)powerON;

+(BOOL)togglePowerByUniID:(NSString*)uuID error:(NSError**)error;
+(BOOL)togglePowerByUniIDForConSmart:(NSString*)uuID error:(NSError**)error;

+(BOOL)setTimerToIO2ByUniID:(NSString*)uuID fireTime:(NSDate*)fireTime powerON:(BOOL)powerON timerItems:(NSArray*)timerItems error:(NSError**)error;

+(NSDate*)getDeviceTimeByUniID:(NSString*)uuID error:(NSError**)error;

+(BOOL)sendDeviceTimeByByBLEPeripheral:(BLEPeripheral*)per error:(NSError**)error;

+(NSDate*)getDeviceTimeByUniIDForConSmartModle:(NSString*)uuID error:(NSError**)error;

+(TimerMaster*)getCurrentTimerMasterByUniID:(NSString*)uuID error:(NSError**)error;

+(TimerMaster*)getCurrentTimerMasterByUniIDForTimerBugV5:(NSString*)uuID error:(NSError**)error;
@end
