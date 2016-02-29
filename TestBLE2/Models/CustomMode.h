//
//  CustomMode.h
//  LedWifi
//
//  Created by luoke on 12-12-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppConfig.h"


@interface ColorItem : NSObject

@property (nonatomic, retain) UIColor * color;
@property (nonatomic, retain) NSString * csModeUniID;
@property (nonatomic, retain) NSNumber * itemNo;
@property (nonatomic, retain) NSString * uniID;

@end

@interface CustomMode : NSObject

-(id)init;

@property (retain) NSMutableArray *colorItems;

@property (nonatomic, retain) NSString * itemName;
@property  LEDRunModeType runModeType;
@property  int  speed;
@property (nonatomic, retain) NSString * uniID;


-(ColorItem*)findColorItemByItemNo:(int)itemNo;
-(ColorItem*)getnewColorItem;
@end
