//
//  LEDWiFiLibsConfig.h
//  LEDWiFiLibs
//
//  Created by zhou mingchang on 15/12/11.
//  Copyright © 2015年 Zhengji. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CustomErrorDomain @"zengge.com"

#define BLEPeripheralReceiveDataNotification   @"BLEPeripheralReceiveDataNotification"

#define DebugLog(log, ...)  NSLog(log, ## __VA_ARGS__)
//#define DebugLog(log, ...)
#define DebugLogT(log, ...) NSLog(log, ## __VA_ARGS__)



// 指定扫描广播UUID
#define kConnectedServiceUUID                   @"FFF0"

// TransmitMoudel Receive Data Service UUID
#define kReceiveDataServiceUUID                 @"FFE0"

// TransmitMoudel Send Data Service UUID
#define kSendDataServiceUUID                    @"FFE5"

// TransmitMoudel characteristics UUID
#define kReceiveDataCharateristicUUID          @"FFE4"

// TransmitMoudel characteristics UUID
#define kSendDataCharateristicUUID             @"FFE9"



//可编程IO (配置 IO2 为输出口)
#define kCodedEnableServiceUUID              @"FFF0"
//可编程IO (配置 IO2 为输出口)
#define kCodedEnableDataCharateristicUUID    @"FFF1"

//可编程IO (配置 IO2 为输出口)
#define kCodedPowerIODataCharateristicUUID    @"FFF2"

#define kCodedPowerIOReceiveDataCharateristicUUID    @"FFF3"

//定时配置服务
#define kTimerSettingServiceUUID             @"FE00"
//设定和读取 定时记录
#define kTimerRecordDataCharateristicUUID    @"FE03"
//设定和读取 开启定时事件
#define kTimerEnableDataCharateristicUUID    @"FE05"
//设定和读取 开启端口定时功能
#define kTimerPortEnableDataCharateristicUUID    @"FE06"
//校时功能
#define kTimerSetTimeDataCharateristicUUID    @"FE01"



@interface BLELibsConfig : NSObject


//+(void)setInitAppWebAddress:(NSString *)webAddress   svcSockB:(NSString*)svcSockB;
//+(NSString*)appWebAddress;
//+(NSString*)appSockInfo;

+(BOOL)checkIsConSmartModleName:(NSString*)name;
@end
