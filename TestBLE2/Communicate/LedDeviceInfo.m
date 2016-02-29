//
//  DeviceInfo.m
//  LedWifi
//
//  Created by luoke on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LedDeviceInfo.h"

@implementation LedDeviceInfo


-(id)init
{
    self = [super init];
    if (self) {
        
        self.levVersionNum = 0;
        //self.tryConnectonCount = 0;
        self.isSelected = false;
        //self.connection_status = Connection_status_Connecting;
        self.deviceType = LED_Undown;
        
    }
    return self;
}



+(NSArray*)sortByDevcieMac:(NSArray*)srcDeviceList
{
    return  [srcDeviceList sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        
        LedDeviceInfo *dev1 = obj1;
        LedDeviceInfo *dev2 = obj2;
        
        if (dev1.deviceType==dev2.deviceType)
        {
            return [dev1.localName compare:dev2.localName];
        }
        else
        {
            if (dev1.deviceType>dev2.deviceType) {
                return NSOrderedAscending;
            }
            else if (dev1.deviceType== dev2.deviceType)
            {
                return NSOrderedSame;
            }
            else
            {
                return NSOrderedDescending;
            }
        }
    }];
}


@end
