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


@interface BLEPowerCommandRequest : NSObject<CBPeripheralDelegate>

@property(strong,nonatomic) CBPeripheral *currentCBPeripheral;


-(id)initWithCBPeripheral:(CBPeripheral*)cbperipheral;

-(BOOL)isConnectedDataSevice;
-(BOOL)discoverDataCharacteristics:(NSError**)error;
-(BOOL)startRequestIsPowerOnByimeout:(int)timeOut  error:(NSError**)error;

//呼叫的
-(void)clearDataCharacteristics;

//-(void)sendData:(NSData*)data;

-(void)setOpenIO2;
-(void)sendPowerOn:(BOOL)powerOn;

@end
