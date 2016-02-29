//
//  LEDCommandService.m
//  LedBLEv2
//
//  Created by luoke365 on 12/30/13.
//  Copyright (c) 2013 luoke365. All rights reserved.
//

#import "LEDCommandService.h"
#import "ConnectionManager.h"
#import "RGBDeviceCMDMgr.h"
#import "BLECommandRequest.h"
#import "AppConfig.h"
#import "BLETimerCommandRequest.h"
#import "BLEPowerCommandRequest.h"
#import "TimerItem.h"
#import "TimerMaster.h"
#import "BLECommandRequestLong.h"


@implementation LEDCommandService

//V02及以下版本使用 阿达单片机作为开关
+(BOOL)togglePowerForVersion2ByUniID:(NSString*)uuID error:(NSError**)error
{
    ConnectionManager *mgr = [ConnectionManager getCurrent];
    
    DeviceStateInfoBase *obj = [self getDeviceStateInfoBaseByUniID:uuID error:error];
    if (obj!=nil)
    {
        NSData *data = [RGBDeviceCMDMgr getCommondDataForSwithOpen:!obj.isOpen];
        [mgr sendDataByUUID:uuID data:data];
        return YES;
    }
    else
    {
        return FALSE;
    }
}
//V02以上版本使用蓝牙模块IO2进行开关
+(BOOL)togglePowerForNewVersionByUniID:(NSString*)unID error:(NSError**)error
{
    ConnectionManager *mgr = [ConnectionManager getCurrent];
    BOOL success = [mgr ConnectionDeviceSynaByUUID:unID error:error];
    if (!success || *error!=nil)
    {
        return FALSE;
    }
    BLEPeripheral *per = [mgr getBLEPeripheralByUniID:unID];
    BLEPowerCommandRequest *powerQequest = [[BLEPowerCommandRequest alloc] initWithCBPeripheral:per.currentCBPeripheral];
    //搜索服务及通道
    success = [powerQequest discoverDataCharacteristics:error];
    if (success)
    {
        BOOL powerON =[powerQequest startRequestIsPowerOnByimeout:2 error:error];
        [powerQequest setOpenIO2];
        [powerQequest sendPowerOn:!powerON];
    }
    [powerQequest clearDataCharacteristics];
    
    return success;
}
+(BOOL)getLoadPowerForNewByUniIDByUniID:(NSString*)unID error:(NSError**)error
{
    BOOL r_powerON = NO;
    
    ConnectionManager *mgr = [ConnectionManager getCurrent];
    BOOL success = [mgr ConnectionDeviceSynaByUUID:unID error:error];
    if (!success || *error!=nil)
    {
        return FALSE;
    }
    BLEPeripheral *per = [mgr getBLEPeripheralByUniID:unID];
    BLEPowerCommandRequest *powerQequest = [[BLEPowerCommandRequest alloc] initWithCBPeripheral:per.currentCBPeripheral];
    //搜索服务及通道
    success = [powerQequest discoverDataCharacteristics:error];
    if (!success || *error!=nil)
    {
        return FALSE;
    }
    r_powerON =[powerQequest startRequestIsPowerOnByimeout:2 error:error];
    if (*error!=nil)
    {
        return FALSE;
    }
    [powerQequest clearDataCharacteristics];
    
    return r_powerON;
}


+(BOOL)togglePowerByUniID:(NSString*)uuID error:(NSError**)error
{
    ConnectionManager *mgr = [ConnectionManager getCurrent];
    LedDeviceInfo *dev = [mgr getLedDeviceInfoByUniID:uuID];
    if (dev==nil)
    {
        return FALSE;
    }
    if (dev.levVersionNum>=3) {
        
        //V03（20140211）：软件全新改版，硬件取消开关命令，开关根据IO2决定，加入定时模式，对应协议版本号：140211
         return [self togglePowerForNewVersionByUniID:uuID error:error];
    }
    else
    {
        //旧的版本
        return [self togglePowerForVersion2ByUniID:uuID error:error];
    }
}


+(BOOL)togglePowerByUniIDForConSmart:(NSString*)uuID error:(NSError**)error
{
    ConnectionManager *mgr = [ConnectionManager getCurrent];
    
    DeviceStateInfoBase *obj = [self getDeviceStateInfoBaseByUniID:uuID error:error];
    if (obj!=nil)
    {
        NSData *data = [RGBDeviceCMDMgr getCommondDataForSwithOpen:!obj.isOpen];
        [mgr sendDataByUUID:uuID data:data];
        return YES;
    }
    else
    {
        return FALSE;
    }
}


//已经连接过的，不需要再连接了
+(void)TrySendAllPowerByUniIDsForConnected:(NSArray*)uuIDs powerOn:(BOOL)powerON
{
    ConnectionManager *mgr = [ConnectionManager getCurrent];
    
    for (NSString *unID in uuIDs)
    {
        BLEPeripheral *per = [mgr getBLEPeripheralByUniID:unID];
        if (per.currentCBPeripheral.state !=CBPeripheralStateConnected) {
            return;
        }
        LedDeviceInfo *dev = [mgr getLedDeviceInfoByUniID:unID];
        if (dev!=nil)
        {
            if ([AppConfig checkIsConSmartModleName:dev.localName])
            {
                //自连纬创 发送开关
                NSData *data = [RGBDeviceCMDMgr getCommondDataForSwithOpen:powerON];
                [per sendData:data];
            }
            else
            {
                if (dev.levVersionNum>=3) {
                    
                    //V03（20140211）：软件全新改版，硬件取消开关命令，开关根据IO2决定，加入定时模式，对应协议版本号：140211
                    NSError *error = nil;
                    BLEPowerCommandRequest *powerQequest = [[BLEPowerCommandRequest alloc] initWithCBPeripheral:per.currentCBPeripheral];
                    //搜索服务及通道
                    BOOL success = [powerQequest discoverDataCharacteristics:&error];
                    if (success)
                    {
                        [powerQequest setOpenIO2];
                        [powerQequest sendPowerOn:powerON];
                    }
                    [powerQequest clearDataCharacteristics];
                }
                else
                {
                    //旧的版本
                    //发送开关
                    NSData *data = [RGBDeviceCMDMgr getCommondDataForSwithOpen:powerON];
                    [per sendData:data];
                    
                }
            }
        }
    }
}


+(BOOL)getLoadPowerForConnectedByUniID:(NSString*)uniID error:(NSError**)error
{
    ConnectionManager *mgr = [ConnectionManager getCurrent];
    LedDeviceInfo *dev = [mgr getLedDeviceInfoByUniID:uniID];
    if (dev!=nil)
    {
//        if (dev.levVersionNum>=3) {
//            //V03（20140211）：软件全新改版，硬件取消开关命令，开关根据IO2决定，加入定时模式，对应协议版本号：140211
//            return [self getLoadPowerForNewByUniIDByUniID:uniID error:error];
//        }
//        else
//        {
            //旧的版本
            DeviceStateInfoBase *obj = [self getDeviceStateInfoBaseByUniID:uniID error:error];
            if (obj!=nil)
            {
                return obj.isOpen;
            }
            else
            {
                return FALSE;
            }
//        }
    }
    return FALSE;
}




+(RGB_WDeviceStateInfo*)getRGB_WDeviceStateInfoForConnectedByUniID:(NSString*)uuID error:(NSError**)error
{
    ConnectionManager *mgr = [ConnectionManager getCurrent];

    //请求数据
    BLEPeripheral *per = [mgr getBLEPeripheralByUniID:uuID];
    
    BLECommandRequest *request = [[BLECommandRequest alloc] initWithBLEPeripheral:per];
    NSData *cmdData = [RGBDeviceCMDMgr getCommondDataForQuery];
    
    NSData *resp = [request startRequest:cmdData error:error];
    
    if (*error==nil && resp!=nil)
    {
        return [RGBDeviceCMDMgr getRGBWDeviceStateInfoByData:resp];
    }
    return nil;
}




+(DeviceStateInfoBase*)getDeviceStateInfoBaseByUniID:(NSString*)uuID error:(NSError**)error
{
    ConnectionManager *mgr = [ConnectionManager getCurrent];
    //连接
    BOOL success = [mgr ConnectionDeviceSynaByUUID:uuID error:error];
    if (!success || *error!=nil)
    {
        return nil;
    }
    
    //请求数据
    BLEPeripheral *per = [mgr getBLEPeripheralByUniID:uuID];
    
    BLECommandRequest *request = [[BLECommandRequest alloc] initWithBLEPeripheral:per];
    NSData *cmdData = [RGBDeviceCMDMgr getCommondDataForQuery];
    
    NSData *resp = [request startRequest:cmdData timeout:3 error:error];
    
    if (*error==nil && resp!=nil)
    {
        return [RGBDeviceCMDMgr getDeviceStateInfoBaseByData:resp];
    }
    return nil;
}


+(BOOL)setTimerToIO2ByUniID:(NSString*)uuID fireTime:(NSDate*)fireTime powerON:(BOOL)powerON timerItems:(NSArray*)timerItems error:(NSError**)error
{
    ConnectionManager *mgr = [ConnectionManager getCurrent];
    //连接
    BOOL success = [mgr ConnectionDeviceSynaByUUID:uuID error:error];
    if (!success || *error!=nil)
    {
        return FALSE;
    }
    
    //请求数据
    BLEPeripheral *per = [mgr getBLEPeripheralByUniID:uuID];
    
    //配置 IO2 为输出口
    BLEPowerCommandRequest *powerQequest = [[BLEPowerCommandRequest alloc] initWithCBPeripheral:per.currentCBPeripheral];
    //搜索服务及通道
    success = [powerQequest discoverDataCharacteristics:error];
    if (!success || *error!=nil)
    {
        return FALSE;
    }
    
    BOOL power_org = [powerQequest startRequestIsPowerOnByimeout:3 error:nil];
    [powerQequest setOpenIO2];   //第一次时会导致关闭,如果原来是开启的，需要发送开启
    if (power_org) {
        [powerQequest sendPowerOn:YES];
    }
    [powerQequest clearDataCharacteristics];
    
    
    
    //定时服务
    BLETimerCommandRequest *request = [[BLETimerCommandRequest alloc] init];
    [request setCurrentCBPeripheral:per.currentCBPeripheral];
   
    //搜索服务及通道
    success = [request discoverDataCharacteristics:error];
    if (!success || *error!=nil)
    {
        return FALSE;
    }
    
    //设置 延时事件(事件0 的定时时间)
    BOOL hasFireOnce = NO;
    if (fireTime!=nil) {
        hasFireOnce = YES;
        [request sendFireOnceByTime:fireTime powerON:powerON];
    }
    
    //开启 定时事件
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (int i = 1; i<=timerItems.count; i++)
    {
        TimerItem *itm = [timerItems objectAtIndex:i-1];
        [arr addObject:[NSNumber numberWithInt:i]];
        
        //设置其他定时时间(循环的)
        [request sendTimerEventByHour:itm.hour.intValue minute:itm.minute.intValue powerON:itm.isTurnON.boolValue timerEventNo:i];
    }
    [request sendOpenEventsByHasFireOnce:hasFireOnce timerEventNos:arr];
    
    //开启 端口定时事件
    [request sendOpenPorts];
    
    //更新时钟
    [request sendTiming];
    
    
    
    [request clearDataCharacteristics];
    
//    NSData *data = [RGBDeviceCMDMgr getCommondDataForOpenTimer];
//    [per sendData:data];
    
    return YES;
}

+(BOOL)sendDeviceTimeByByBLEPeripheral:(BLEPeripheral*)per error:(NSError**)error
{
    //定时服务
    BLETimerCommandRequest *request = [[BLETimerCommandRequest alloc] init];
    [request setCurrentCBPeripheral:per.currentCBPeripheral];
    
    //搜索服务及通道
    BOOL success = [request discoverDataCharacteristics:error];
    
    if (!success || *error!=nil)
    {
        return NO;
    }
    
    [request sendTiming];
    
    [request clearDataCharacteristics];
    
    return success;
}
+(NSDate*)getDeviceTimeByUniID:(NSString*)uuID error:(NSError**)error
{
    ConnectionManager *mgr = [ConnectionManager getCurrent];
    //连接
    BOOL success = [mgr ConnectionDeviceSynaByUUID:uuID error:error];
    if (!success || *error!=nil)
    {
        return nil;
    }
    
    //请求数据
    BLEPeripheral *per = [mgr getBLEPeripheralByUniID:uuID];
    
    
    //定时服务
    BLETimerCommandRequest *request = [[BLETimerCommandRequest alloc] init];
    [request setCurrentCBPeripheral:per.currentCBPeripheral];
    
    //搜索服务及通道
    success = [request discoverDataCharacteristics:error];
    if (!success || *error!=nil)
    {
        return nil;
    }
    
    NSDate *r_time = [request startRequestTimeBytimeout:5 error:error];
    
    [request clearDataCharacteristics];
    
    return r_time;
}


+(NSDate*)getDeviceTimeByUniIDForConSmartModle:(NSString*)uuID error:(NSError**)error
{
    ConnectionManager *mgr = [ConnectionManager getCurrent];
    //连接
    BOOL success = [mgr ConnectionDeviceSynaByUUID:uuID error:error];
    if (!success || *error!=nil)
    {
        return nil;
    }
    
    //请求数据
    BLEPeripheral *per = [mgr getBLEPeripheralByUniID:uuID];
    
    
    //定时服务
    BLECommandRequest *request = [[BLECommandRequest alloc] initWithBLEPeripheral:per];
    NSData *cmdData = [RGBDeviceCMDMgr getCommondDataForQueryCurrentDataTime];

    NSData *resp = [request startRequest:cmdData error:error];
    if (resp==nil) {
        return nil;
    }
    return [RGBDeviceCMDMgr getTimeByData:resp];
}


//-----------------------新版定时方法协议


+(TimerMaster*)getCurrentTimerMasterByUniID:(NSString*)uuID error:(NSError**)error
{
    ConnectionManager *mgr = [ConnectionManager getCurrent];
    
    TimerMaster *r_obj =nil;
    NSDate *r_date = nil;
    NSArray *r_items = nil;
    
    NSData *cmdData = nil;
    NSData *resp = nil;
    BLEPeripheral *per = [mgr getBLEPeripheralByUniID:uuID];
    BLECommandRequestLong *request = [[BLECommandRequestLong alloc] initWithBLEPeripheral:per];

    
    cmdData = [RGBDeviceCMDMgr getCommondDataForQuerySettingTimes];
    resp = [request startRequest:cmdData reponseCount:87 error:error];
    if (*error!=nil || resp==nil)
    {
        goto closeTCP;
    }
    r_items = [RGBDeviceCMDMgr getTimerDetailItemsByData:resp];
    if (r_items==nil) {
        goto closeTCP;
    }
    
    cmdData = [RGBDeviceCMDMgr getCommondDataForQueryCurrentDataTime];
    resp = [request startRequest:cmdData reponseCount:11  error:error];
    if (*error!=nil || resp==nil)
    {
        goto closeTCP;
    }
    
    r_date = [RGBDeviceCMDMgr getTimeByData:resp];
    
    if (r_date!=nil && r_items!=nil) {
        
        r_obj = [[TimerMaster alloc] init];
        [r_obj setTimerItems:r_items];
        [r_obj setCurrentTime:r_date];
    }
    
    
closeTCP:
    {

    }
    return r_obj;
}


+(TimerMaster*)getCurrentTimerMasterByUniIDForTimerBugV5:(NSString*)uuID error:(NSError**)error
{
    ConnectionManager *mgr = [ConnectionManager getCurrent];
    
    TimerMaster *r_obj =nil;
    NSDate *r_date = nil;
    NSArray *r_items = nil;
    
    NSData *cmdData = nil;
    NSData *resp = nil;
    BLEPeripheral *per = [mgr getBLEPeripheralByUniID:uuID];
    BLECommandRequestLong *request = [[BLECommandRequestLong alloc] initWithBLEPeripheral:per];
    
    
    cmdData = [RGBDeviceCMDMgr getCommondDataForQuerySettingTimes];
    resp = [request startRequest:cmdData reponseCount:87 error:error];
    if (*error!=nil || resp==nil)
    {
        goto closeTCP;
    }
    r_items = [RGBDeviceCMDMgr getTimerDetailItemsByDataForTimerBugV5:resp];
    if (r_items==nil) {
        goto closeTCP;
    }
    
    cmdData = [RGBDeviceCMDMgr getCommondDataForQueryCurrentDataTime];
    resp = [request startRequest:cmdData reponseCount:11  error:error];
    if (*error!=nil || resp==nil)
    {
        goto closeTCP;
    }
    
    r_date = [RGBDeviceCMDMgr getTimeByDataForTimerBugV5:resp];
    
    if (r_date!=nil && r_items!=nil) {
        
        r_obj = [[TimerMaster alloc] init];
        [r_obj setTimerItems:r_items];
        [r_obj setCurrentTime:r_date];
    }
    
    
closeTCP:
    {
        
    }
    return r_obj;
}


@end
