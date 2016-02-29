//
//  BLEPeripheral.h
//  LedBLEv2
//
//  Created by luoke365 on 12/27/13.
//  Copyright (c) 2013 luoke365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class BLECentralManager;
@class BLEPeripheral;

#define BLEPeripheralReceiveDataNotification   @"BLEPeripheralReceiveDataNotification"


@interface BLETimerCommandRequest : NSObject<CBPeripheralDelegate>

@property(strong,nonatomic) CBPeripheral *currentCBPeripheral;



-(BOOL)isConnectedDataSevice;
-(BOOL)discoverDataCharacteristics:(NSError**)error;
-(NSDate*)startRequestTimeBytimeout:(int)timeOut  error:(NSError**)error;

//呼叫的
-(void)clearDataCharacteristics;

//-(void)sendData:(NSData*)data;

-(void)sendFireOnceByTime:(NSDate*)date  powerON:(BOOL)powerON;

-(void)sendOpenEventsByHasFireOnce:(BOOL)hasFireOnce  timerEventNos:(NSArray*)timerEventNos;
-(void)sendTimerEventByHour:(int)hour minute:(int)minute  powerON:(BOOL)powerON timerEventNo:(int)timerEventNo;

-(void)sendOpenPorts;

-(void)sendTiming;

@end
