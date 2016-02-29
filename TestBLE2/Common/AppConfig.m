//
//  AppConfig.m
//  MyKcal
//
//  Created by  mac on 11-8-30.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "AppConfig.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <SystemConfiguration/SCNetworkReachability.h>
#include <arpa/inet.h>

#include <netdb.h>
#include <net/if.h>
#include <ifaddrs.h>
#import <dlfcn.h>
#import <SystemConfiguration/SystemConfiguration.h>




@implementation AppConfig

+(BOOL)connectedToNetWork
{
    //创建0地址
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = AF_INET;
    
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
    
}


+ (NSString *)createUUID
{
    // Create universally unique identifier (object)
    CFUUIDRef uuidObject = CFUUIDCreate(kCFAllocatorDefault);
    
    // Get the string representation of CFUUID object.
    NSString *uuidStr = (NSString *)CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, uuidObject));

    // If needed, here is how to get a representation in bytes, returned as a structure
    // typedef struct {
    //   UInt8 byte0;
    //   UInt8 byte1;
    //   ...
    //   UInt8 byte15;
    // } CFUUIDBytes;
    //CFUUIDBytes bytes = CFUUIDGetUUIDBytes(uuidObject);
    
    CFRelease(uuidObject);
    DebugLog(@"guid:%@",uuidStr);
    return uuidStr;
}

+(float)getIOSVersion
{
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    return version;
}


//逻辑说明
//智联纬创  LEDDeviceType = 15
//   时间查询或者设置 时，通过 [AppConfig checkISConSmartModeName:LedDeviceInfo.localName]  或者 if ([AppConfig checkIsConSmartModleName:self.blePeripheral.deviceName])判断
//   如果返回true，则使用阿达协议透传方式
//   如果返回false,则使用信迟达 蓝牙服务协议方式；
//   开关方式 时，如果是false，还需要进一步判断 版本号，如果小于等于2，则也使用透传的方式
+(BOOL)checkIsConSmartModleName:(NSString*)name
{
    if ([name startsWith:@"LEDBLE"] || [name startsWith:@"LEDBlue"]
         || [name startsWith:@"FluxBlue"]) {
        return YES;
    }
    else
    {
        return NO;
    }
}

+(BOOL)checkIsBLEModleByName:(NSString*)name
{
    if ([name startsWith:@"LEDBLE"]
        || [name startsWith:@"LEDBlue"]
        || [name startsWith:@"LEDnet"]
        || ( [name startsWith:@"FluxBlue"] && AppForFlux)
        ) {
        return YES;
    }
    else
    {
        return NO;
    }
}


+(NSString*)getAppDisplayName
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
    return name;
}
+(NSString*)getAppVersionString
{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    return version;
}
+(NSString*)getBuildVersionString
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *version = [infoDictionary objectForKey:@"CFBundleVersion"];
    return version;
}

+(float)countValueFromRangeMin:(float)minFrom  maxFrom:(float)maxFrom
                         minTo:(float)minTo maxTo:(float)maxTo
                  withOgrValue:(float)orgValue
{
    float persent = (orgValue - minFrom) / ( maxFrom - minFrom );
    float r_value = (maxTo - minTo)*1.0f*persent + minTo;
    if (r_value > maxTo) {
        r_value = maxTo;
    }
    
    if (r_value < minTo) {
        r_value = minTo;
    }
    return r_value;
}

+(int)getRandomNumber:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to - from + 1)));
}

@end
