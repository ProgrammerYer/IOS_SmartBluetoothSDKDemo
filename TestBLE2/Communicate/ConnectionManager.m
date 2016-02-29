//
//  ConnectionManager.m
//  LedWifiMagicColor
//
//  Created by luoke365 on 10/12/13.
//
//

#import "ConnectionManager.h"
#import "LedDeviceInfo.h"
#import "BLECentralManager.h"
#import "BLEPeripheral.h"
#import "RGBDeviceCMDMgr.h"
#import "ListValueItem.h"
#import "NSStringWrapper.h"

//#import "LedControllerClient.h"

__strong static ConnectionManager *_connectionMgr;

@interface ConnectionManager ()

@property(strong) NSLock *lockObject_list;
@property(strong) NSMutableDictionary *deviceInfoList;
@property(strong) BLECentralManager *bleCentralMgr;
//@property(strong) NSMutableDictionary *moduleTCLClients;

@end

@implementation ConnectionManager

-(id)init
{
    self = [super init];
    
    if (self) {
        self.lockObject_list = [[NSLock alloc] init];
        self.deviceInfoList = [[NSMutableDictionary alloc] init] ;
//        self.moduleTCLClients = [[[NSMutableDictionary alloc] init] autorelease];
    }
    
    return self;
}

+(ConnectionManager*)getCurrent
{
    @synchronized(self)
    {
        if (_connectionMgr==nil)
        {
            _connectionMgr = [[ConnectionManager alloc] init];
        }
    }
    return _connectionMgr;
}
-(void)startScanBLEDevice
{
    self.bleCentralMgr = [[BLECentralManager alloc] init];
    [self.bleCentralMgr setDelegate:self];
    [self.bleCentralMgr startScaning];
}
-(void)reScanBLEDevice
{
    if (self.bleCentralMgr!=nil) {
        [self.bleCentralMgr stopScaning];
    }
    
    //取消设备的选择
    [self.lockObject_list lock];
    
    for (LedDeviceInfo *dev  in [self.deviceInfoList allValues]) {
        dev.isSelected = NO;
    }
    [self.lockObject_list unlock];
    
    
    @try
    {
         [self.bleCentralMgr disConnectAllPeripheral];
    }
    @catch (NSException *exception) {
        NSLog(@"==================reScanBLEDevice NSException:%@",exception.description);
    }
    @finally {}
    
    
    [self.lockObject_list lock];
    
    [self.deviceInfoList removeAllObjects];
    
    [self.lockObject_list unlock];
    
    [self startScanBLEDevice];
}

-(void)disConnectAllDevice
{
    NSArray *uniIDs = [self getAllAddedDeviceUnIDs];
    [self.bleCentralMgr disConnectPeripheralByUniIDs:uniIDs];
}
#pragma mark - get devices
-(NSArray*)getAllDeviceList
{
    return [self.deviceInfoList allValues];
}

-(NSArray*)getAllAddedDeviceUnIDs
{
    NSMutableArray *r_uniIDs = [[NSMutableArray alloc] init];
    
    [self.lockObject_list lock];
    
    for (LedDeviceInfo *dev  in [self.deviceInfoList allValues]) {
        if (dev.deviceType != LED_Undown) {
            [r_uniIDs addObject:dev.macAddress];
        }
    }
    [self.lockObject_list unlock];
    
    return r_uniIDs;
}
-(BLEPeripheral*)getBLEPeripheralByUniID:(NSString*)uuID
{
    return [self.bleCentralMgr.bleBLEPeripheralList objectForKey:uuID];
}
-(LedDeviceInfo*)getLedDeviceInfoByUniID:(NSString*)uuID
{
    return [self.deviceInfoList objectForKey:uuID];
}

-(void)cancelAllSelectedDevice
{
    [self.lockObject_list lock];
    
    for (LedDeviceInfo *dev  in [self.deviceInfoList allValues]) {
        dev.isSelected = NO;
    }
    [self.lockObject_list unlock];
}
-(void)setSelectedDeviceByUniIDs:(NSArray*)uniIDs
{
    [self.lockObject_list lock];
    
    for (LedDeviceInfo *dev  in [self.deviceInfoList allValues]) {
        dev.isSelected = NO;
    }
    
    for (NSString* uniID in uniIDs) {
        
        [[self.deviceInfoList objectForKey:uniID] setIsSelected:YES];
    }
    
    [self.lockObject_list unlock];
}
-(NSArray*)getSelectedDevicesUniIDs
{
    NSMutableArray *r_list = [NSMutableArray array];
    
    [self.lockObject_list lock];
    
    for (LedDeviceInfo *dev  in [self.deviceInfoList allValues]) {
        
        if (dev.isSelected) {
            [r_list addObject:dev.macAddress];
        }
    }
    [self.lockObject_list unlock];
    
    return r_list;
}

//-(NSArray*)getDeviceTypeListItemValuesByUniIDs:(NSArray*)uniIDs
//{
//    NSMutableDictionary *deviceTypes = [[NSMutableDictionary alloc] init];
//    for (NSString *uniID in uniIDs) {
//        
//        LedDeviceInfo *dev = [self.deviceInfoList objectForKey:uniID];
//        NSString *
//        if ([deviceTypes valueForKey:dev.deviceType]) {
//            <#statements#>
//        }
//        [deviceTypes setObject:<#(id)#> forKey:dev.dev]
//        
//    }
//}

//同步连接
-(BOOL)ConnectionDeviceSynaByUUID:(NSString*)uuID error:(NSError**)error
{
    BLEPeripheral *bleDev = [self.bleCentralMgr.bleBLEPeripheralList objectForKey:uuID];
    if (bleDev==nil) {return NO;}  //有可能再其他线程清空了
    
    if (!bleDev.isConnectedDataSevice)
    {
        //连接设备
        BOOL success = FALSE;
        for (int i=0; i<2; i++) {
            *error = nil;
            success = [self.bleCentralMgr connectPeripheralSync:bleDev error:error];
            if (success) {
                break;
            }
        }
        if (!success) {
            return FALSE;
        }
        
        //查找服务以及特征值
        for (int i=0; i<2; i++) {
            *error = nil;
            success = [bleDev discoverDataCharacteristics:error];
            if (success) {
                break;
            }
        }
        
        if (!success) {
            return FALSE;
        }
        
        //连接后立刻查询，目的是 清除通道 留存的数据，不知道为什么？？
//        NSData *cmdData = [RGBDeviceCMDMgr getCommondDataForQuery];
//        [bleDev sendData:cmdData];
    }
    return TRUE;
}

-(void)CheckAndProcessConnectionLimitByWillConnectUniIDs:(NSArray*)uniIDs
{
    //[uniID已连接的部分] 加上  [其他以连接部分]  >= 5的话，清除其他连接
    //目前做法 [其他以连接部分] + [uniIDs所有的] > 4 的话
    NSArray *otherUniIDs = [self getOtherConnectedDeviceUniIDsExclude:uniIDs];
    if (otherUniIDs.count + 1 >MAX_Connection) {
        
        [self.bleCentralMgr disConnectPeripheralByUniIDs:otherUniIDs];
        NSLog(@"------==============disConnectPeripheralByUniIDs");
    }
}


-(BOOL)ConnectionDevicesSynaByUniIDs:(NSArray*)uniIDs error:(NSError**)error
{
    //uniIDs 必须小于等于 5
    for (NSString *uuID in uniIDs) {
        
        BOOL sucees = [self ConnectionDeviceSynaByUUID:uuID error:error];
        if (!sucees || *error!=nil)
        {
            return FALSE;
        }
    }
    return TRUE;
}
-(void)TryConnectionDevicesSynaByUniIDs:(NSArray*)uniIDs error:(NSError**)error
{
    for (NSString *uuID in uniIDs) {  [self ConnectionDeviceSynaByUUID:uuID error:error]; }
}


-(NSArray*)getOtherConnectedDeviceUniIDsExclude:(NSArray*)uniIDs
{
    NSMutableArray *r_uniIDs = [[NSMutableArray alloc] init];
    
    [self.lockObject_list lock];
    for (NSString *uniID in self.bleCentralMgr.bleBLEPeripheralList.allKeys)
    {
        if (![uniIDs containsObject:uniID])
        {
            BLEPeripheral *bleDev = [self.bleCentralMgr.bleBLEPeripheralList objectForKey:uniID];
            if (bleDev.isConnectedDataSevice) {
                [r_uniIDs addObject:uniID];
            }
        }
    }
    

    [self.lockObject_list unlock];
    
    return r_uniIDs;
}

-(void)sendDataByUUID:(NSString*)uuID data:(NSData*)data
{
    //NSLog(@"===================sendDataByUUID:%@   %@",data,uuID);
    BLEPeripheral *bleDev = [self.bleCentralMgr.bleBLEPeripheralList objectForKey:uuID];
    if (bleDev!=nil && bleDev.currentCBPeripheral.state == CBPeripheralStateConnected)
    {
        [bleDev sendData:data];
    }
    else
    {
        NSLog(@"===================sendDataByUUID failed:%@",data);
    }
}

-(void)sendDataByUniIDs:(NSArray*)uniIDs data:(NSData*)data
{
    for (NSString *uniID in uniIDs) {
        [self sendDataByUUID:uniID data:data];
    }
}


-(void)sendDataForOver20CharByUUID:(NSString*)uuID data:(NSData*)data
{
    //NSLog(@"===================sendDataByUUID:%@   %@",data,uuID);
    BLEPeripheral *bleDev = [self.bleCentralMgr.bleBLEPeripheralList objectForKey:uuID];
    if (bleDev!=nil && bleDev.currentCBPeripheral.state == CBPeripheralStateConnected)
    {
        //当是BLE并且是版本号大于7,代表 欧洲蓝牙芯片
        LedDeviceInfo *dev = [self.deviceInfoList objectForKey:uuID];
        if (dev!=nil && [dev.localName startsWith:@"LEDBLE"] && dev.levVersionNum >=7)
        {
            [bleDev sendDataWithSplitData:data];
        }
        else
        {
            [bleDev sendData:data];
        }
    }
    else
    {
        NSLog(@"===================sendDataByUUID failed:%@",data);
    }
}
//-(void)sendPowerONForIO2ByUUID:(NSString*)uuID powerOn:(BOOL)powerON
//{
//    BLEPeripheral *bleDev = [self.bleCentralMgr.bleBLEPeripheralList objectForKey:uuID];
//    if (bleDev!=nil) {
//        
//        //[bleDev sendData:data];
//        [bleDev sendPowerOn:powerON];
//    }
//}

-(void)sendDataUUIDForOver20CharByUniIDs:(NSArray*)uniIDs data:(NSData*)data
{
    for (NSString *uniID in uniIDs) {
        [self sendDataForOver20CharByUUID:uniID data:data];
    }
}


-(void)sendDeviceCurrentTimeByUniIDs:(NSArray*)uniIDs
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *ps = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSWeekdayCalendarUnit
                            | NSHourCalendarUnit| NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:[NSDate date]];
    
    int yearFrom2000 = (int)ps.year - 2000;
    int week = [self getWeekNumbyDayOfWeek:(int)ps.weekday];
    
    
    NSData *data = [RGBDeviceCMDMgr getCommondDataForSetTimeByyearFrom2000:yearFrom2000
                                                                     month:(int)ps.month day:(int)ps.day
                                                                      hour:(int)ps.hour minute:(int)ps.minute sec:(int)ps.second
                                                                      week:week];
    
    [self sendDataByUniIDs:uniIDs data:data];
}
-(void)sendDeviceCurrentTimeByUniIDsForTimerBugV5:(NSArray*)uniIDs
{
    NSCalendar *gregorian = [NSCalendar currentCalendar];
    NSDateComponents *ps = [gregorian components:NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit |NSWeekdayCalendarUnit
                            | NSHourCalendarUnit| NSMinuteCalendarUnit|NSSecondCalendarUnit fromDate:[NSDate date]];
    
    int yearFrom2000 = (int)ps.year - 2000;
    int week = [self getWeekNumbyDayOfWeek:(int)ps.weekday];
    
    if (ps.month==12) {
        ps.month =1;
    }
    NSData *data = [RGBDeviceCMDMgr getCommondDataForSetTimeByyearFrom2000:yearFrom2000
                                                                     month:(int)ps.month day:(int)ps.day
                                                                      hour:(int)ps.hour minute:(int)ps.minute sec:(int)ps.second
                                                                      week:week];
    
    [self sendDataByUniIDs:uniIDs data:data];
}

//1代表星期天， num就是7
-(int)getWeekNumbyDayOfWeek:(int)dayOfWeek
{
    if (dayOfWeek==1)
    {
        return 7;
    }
    else
    {
        return dayOfWeek - 1;
    }
    
}


#pragma mark - BLECentralManagerDelegate
-(void)BLECentralManager:(BLECentralManager*)bleManger didDiscoverBLEPeripheral:(BLEPeripheral*)blePeripheral
{

    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (![AppConfig checkIsBLEModleByName:blePeripheral.deviceName]) {
            return ;
        }
        
        [self.lockObject_list lock];
        
        LedDeviceInfo *dev = [[LedDeviceInfo alloc] init];
        [dev setMacAddress:blePeripheral.uniID];
        [dev setLocalName:blePeripheral.deviceName];
        
//        CDLedDeviceInfo *cd_obj = [GroupInfoMgr findCDLedDeviceInfoByUniID:dev.macAddress];
//        if (cd_obj!=nil) {
//            
//            [dev setDeviceType:cd_obj.deviceType.intValue];
//            [dev setDeviceName:cd_obj.deviceName];
//            [dev setGroupUniID:cd_obj.groupUniID];
//            [dev setLevVersionNum:cd_obj.levVersionNum.intValue];
//        }
        
        [self.deviceInfoList setObject:dev forKey:dev.macAddress];
        
        [self.lockObject_list unlock];
        
        [self onConnectionManagerDataSetChangedNotification];
        
        
    });
}
-(void)BLECentralManager:(BLECentralManager*)bleManger didDisconnectBLEPeripheral:(BLEPeripheral*)blePeripheral
{
    //通知
    //[self performSelectorOnMainThread:@selector(onConnectionManagerDisconnectPeripheralNotification:) withObject:blePeripheral.uniID waitUntilDone:NO];
    NSLog(@"ConnectionManager didDisconnectBLEPeripheral:%@",blePeripheral.uniID);
    
    //如果进入后台背景,则不需要进行重连接
    if([UIApplication sharedApplication].applicationState ==UIApplicationStateBackground){
        NSLog(@"didDisconnectBLEPeripheral 再背景中");
        return;
    }
    
    LedDeviceInfo *dev  = [self.deviceInfoList objectForKey:blePeripheral.uniID];
    if (dev.isSelected) {
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self reConnectByLedDeviceInfo:dev];
            
        });
    }
}

-(void)reConnectByLedDeviceInfo:(LedDeviceInfo*)dev
{
    for (int i =0 ; i<10000; i++)
    {
        if  (!dev.isSelected) {break;}
        NSError *error = nil;
        BOOL success = [self ConnectionDeviceSynaByUUID:dev.macAddress error:&error];
        if (success && error==nil)
        {
            break;
        }
        
        NSLog(@"ConnectionManager ConnectionDeviceSynaByUUID failed:%@",[error debugDescription]);
    }
}

//-------


-(void)onConnectionManagerDataSetChangedNotification
{
    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectionManagerDataSetChangedNotification  object:nil];

}
//-(void)onConnectionManagerDisconnectPeripheralNotification:(NSString*)uuID
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:ConnectionManagerDisconnectPeripheralNotification  object:uuID];
//    
//}


@end


//-(void)fillModules:(NSArray*)modules
//{
//    [self.lockObject_list lock];
//
//    for (WifiModule *module in modules) {
//
//        LedDeviceInfo *dev = [[LedDeviceInfo alloc] init];
//        [dev setDeviceIP:module.moduleIP];
//        [dev setMacAddress:module.macAddress];
//        [dev setDeviceName:[[AppSetting current] getdeviceNameByMacAddress:module.macAddress]];
//        [dev setModuleID:module.moduleID];
//
//        [self.deviceInfoList setObject:dev forKey:dev.deviceIP];
//
//        [dev release];
//    }
//
//    //測試
////    LedDeviceInfo *dev = [[LedDeviceInfo alloc] init];
////    [dev setDeviceIP:@"192.168.0.4"];
////    [dev setMacAddress:@"ACCFFFTTTTTT"];
////    [dev setDeviceName:[[AppSetting current] getdeviceNameByMacAddress:@"ACCFFFTTTTTT"]];
////
////    [self.deviceInfoList setObject:dev forKey:dev.deviceIP];
////
////    [dev release];
//
//    [self.lockObject_list unlock];
//}
//-(void)close
//{
//    [self.lockObject_list lock];
//
//    for (LedControllerClient *client in  self.moduleTCLClients.allValues)
//    {
//        [client setDelegate:nil];
//        [client disConnectionHost];
//    }
//
//    [self.lockObject_list unlock];
//}
//
//

//
//-(LedDeviceInfo*)getLedDeviceInfoOneOnly
//{
//    LedDeviceInfo *r_obj = nil;
//    [self.lockObject_list lock];
//
//    if (self.deviceInfoList.count==1) {
//        r_obj = [[self.deviceInfoList allValues] objectAtIndex:0];
//    }
//
//    [self.lockObject_list unlock];;
//
//    return r_obj;
//}
//
//-(void)ConnectionALL
//{
//    [self.lockObject_list lock];
//
//    for (LedDeviceInfo *dev  in  self.deviceInfoList.allValues) {
//
//        LedControllerClient *client = [[LedControllerClient alloc] initWithIP:dev.deviceIP];
//        [client setDelegate:self];
//        [client connectHost];
//
//        [self.moduleTCLClients setObject:client forKey:dev.deviceIP];
//
//        [client release];
//    }
//
//
//    [self.lockObject_list unlock];
//}
//-(void)ReConnection:(NSString*)ip
//{
//    [self.lockObject_list lock];
//
//    LedControllerClient *client = [self.moduleTCLClients objectForKey:ip];
//    if (client!=nil) {
//        [client disConnectionHost];
//    }
//
//    client = [[LedControllerClient alloc] initWithIP:ip];
//    [client setDelegate:self];
//    [client connectHost];
//
//    [self.moduleTCLClients setObject:client forKey:ip];
//
//
//    [self.lockObject_list unlock];
//}
//-(void)NotifyChanged
//{
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationConnectionStateChange"  object:nil];
//}
//
//#pragma mark - Selection
//
//-(void)UnSelectAllDevice
//{
//    [self.lockObject_list lock];
//
//    for (LedDeviceInfo *dev  in  self.deviceInfoList.allValues)
//    {
//        dev.isSelected = FALSE;
//    }
//
//    [self.lockObject_list unlock];
//}
//
//-(NSMutableArray*)getSelectedDevices
//{
//    NSMutableArray *r_lst = [NSMutableArray array];
//    [self.lockObject_list lock];
//
//    for (LedDeviceInfo *dev  in  self.deviceInfoList.allValues)
//    {
//        if (dev.isSelected) {
//            [r_lst addObject:dev];
//        }
//    }
//
//    [self.lockObject_list unlock];
//
//    return  r_lst;
//}
//
//
//#pragma mark - SendData
//
//-(void)SendSelectDeviceData:(NSData*)data
//{
//    [self.lockObject_list lock];
//
//    for (LedDeviceInfo *dev  in  self.deviceInfoList.allValues)
//    {
//        if (dev.isSelected) {
//            LedControllerClient *client = [self.moduleTCLClients objectForKey:dev.deviceIP];
//            if (client!=nil) {
//                [client SendData:data];
//            }
//        }
//    }
//
//    [self.lockObject_list unlock];
//}
//-(void)SendAllDeviceData:(NSData*)data
//{
//    [self.lockObject_list lock];
//
//    for (LedControllerClient *client in  self.moduleTCLClients.allValues)
//    {
//        [client SendData:data];
//    }
//
//    [self.lockObject_list unlock];
//}
//
//#pragma mark - LedControllerClientDelegate
//-(void)ledControllerClientConnected:(LedControllerClient*)client deviceType:(int)deviceType ledVersionNum:(int)ledVersionNum;
//{
//    LedDeviceInfo *dev = [self.deviceInfoList objectForKey:client.hostIp];
//    if (dev==nil) {
//        return;
//    }
//
//    dev.connection_status = Connection_status_Connected;
//    dev.deviceType = deviceType;
//    dev.levVersionNum = ledVersionNum;
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationConnectionStateChange"  object:nil];
//
//    DebugLog(@"deviceType:%d    ledVersionNum:%d",deviceType,ledVersionNum);
//}
//-(void)ledControllerClientFailed:(LedControllerClient*)client didFailed:(NSError*)error
//{
//    [client setDelegate:nil];
//    LedDeviceInfo *dev = [self.deviceInfoList objectForKey:client.hostIp];
//    if (dev==nil) {
//        return;
//    }
//
//    if (dev.tryConnectonCount<3) {
//        dev.connection_status = Connection_status_Connecting;
//        dev.tryConnectonCount = dev.tryConnectonCount +1;
//        [self ReConnection:client.hostIp];
//    }
//    else
//    {
//        dev.connection_status = Connection_status_Failed;
//    }
//
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationConnectionStateChange"  object:nil];
//}
//-(void)ledControllerClientLosted:(LedControllerClient*)client didLosted:(NSError*)error
//{
//    [client setDelegate:nil];
//    LedDeviceInfo *dev = [self.deviceInfoList objectForKey:client.hostIp];
//    if (dev==nil) {
//        return;
//    }
//
//    dev.connection_status = Connection_status_Failed;
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationConnectionStateChange"  object:nil];
//}
