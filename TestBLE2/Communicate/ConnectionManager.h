//
//  ConnectionManager.h
//  LedWifiMagicColor
//
//  Created by luoke365 on 10/12/13.
//
//

#import <Foundation/Foundation.h>
//#import "LedControllerClient.h"
#import "LedDeviceInfo.h"
#import "BLECentralManager.h"

#define ConnectionManagerDataSetChangedNotification   @"ConnectionManagerDataSetChangedNotification"
//#define ConnectionManagerDisconnectPeripheralNotification @"ConnectionManagerDisconnectPeripheralNotification"


@interface ConnectionManager : NSObject<BLECentralManagerDelegate>


//+(ConnectionManager*)createConnectionManager:(NSArray*)modules;

+(ConnectionManager*)getCurrent;

-(void)startScanBLEDevice;
-(void)reScanBLEDevice;
-(void)disConnectAllDevice;

-(NSArray*)getAllDeviceList;
-(NSArray*)getAllAddedDeviceUnIDs;
-(BLEPeripheral*)getBLEPeripheralByUniID:(NSString*)uuID;
-(LedDeviceInfo*)getLedDeviceInfoByUniID:(NSString*)uuID;
-(void)setSelectedDeviceByUniIDs:(NSArray*)uniIDs;
-(void)cancelAllSelectedDevice;
-(NSArray*)getSelectedDevicesUniIDs;

-(void)CheckAndProcessConnectionLimitByWillConnectUniIDs:(NSArray*)uniIDs;
-(BOOL)ConnectionDeviceSynaByUUID:(NSString*)uuID error:(NSError**)error;
-(BOOL)ConnectionDevicesSynaByUniIDs:(NSArray*)uniIDs error:(NSError**)error;
-(void)TryConnectionDevicesSynaByUniIDs:(NSArray*)uniIDs error:(NSError**)error;

//-(void)disConnectAllPeripheral;

-(void)sendDataByUUID:(NSString*)uuID data:(NSData*)data;
-(void)sendDataByUniIDs:(NSArray*)uniIDs data:(NSData*)data;
-(void)sendDataForOver20CharByUUID:(NSString*)uuID data:(NSData*)data;
-(void)sendDataUUIDForOver20CharByUniIDs:(NSArray*)uniIDs data:(NSData*)data;

-(void)sendDeviceCurrentTimeByUniIDs:(NSArray*)uniIDs;
-(void)sendDeviceCurrentTimeByUniIDsForTimerBugV5:(NSArray*)uniIDs;
//-(void)sendPowerONForIO2ByUUID:(NSString*)uuID powerOn:(BOOL)powerON;

//-(void)ConnectionALL;
//-(void)ReConnection:(NSString*)ip;

//-(void)NotifyChanged;

//-(void)UnSelectAllDevice;
//-(NSMutableArray*)getSelectedDevices;
//
//
//-(void)SendSelectDeviceData:(NSData*)data;
//-(void)SendAllDeviceData:(NSData*)data;
//
//-(LedDeviceInfo*)getLedDeviceInfoOneOnly;
@end
