//
//  BLECentralManager.h
//  LedBLEv2
//
//  Created by luoke365 on 12/27/13.
//  Copyright (c) 2013 luoke365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BLEPeripheral.h"




@class BLECentralManager;

@protocol BLECentralManagerDelegate <NSObject>

-(void)BLECentralManager:(BLECentralManager*)bleManger didDiscoverBLEPeripheral:(BLEPeripheral*)blePeripheral;

-(void)BLECentralManager:(BLECentralManager*)bleManger didDisconnectBLEPeripheral:(BLEPeripheral*)blePeripheral;


@end


@interface BLECentralManager : NSObject<CBCentralManagerDelegate>


@property(assign) id<BLECentralManagerDelegate> delegate;
@property(strong)  NSMutableDictionary *bleBLEPeripheralList;

-(void)startScaning;
-(void)stopScaning;

-(BOOL)connectPeripheralSync:(BLEPeripheral*)blePeripheral  error:(NSError**)error;
-(void)disConnectAllPeripheral;
-(void)disConnectPeripheralByUniIDs:(NSArray*)uniIDs;

@end
