//
//  BLEPeripheral.h
//  LedBLEv2
//
//  Created by luoke365 on 12/27/13.
//  Copyright (c) 2013 luoke365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@class BLEPeripheral;




@interface BLEPeripheral : NSObject<CBPeripheralDelegate>

@property(strong,nonatomic) NSString *deviceName;
@property(strong,nonatomic) NSString *uniID;
@property(strong,nonatomic) CBPeripheral *currentCBPeripheral;



-(BOOL)isConnectedDataSevice;
-(BOOL)discoverDataCharacteristics:(NSError**)error;

//呼叫的
-(void)clearDataCharacteristics;

-(void)sendData:(NSData*)data;
-(void)sendDataWithResponse:(NSData*)data;

-(void)sendDataWithSplitData:(NSData*)data;
@end
