//
//  TimerMaster.h
//  LedWiFiMagicUFO
//
//  Created by luoke365 on 4/24/14.
//  Copyright (c) 2014 luoke365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimerMaster : NSObject

@property (strong,nonatomic) NSDate *currentTime;
@property (strong,nonatomic) NSArray *timerItems;

@end
