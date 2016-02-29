//
//  CustomMode.m
//  LedWifi
//
//  Created by luoke on 12-12-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "CustomMode.h"
#import "AppConfig.h"

@implementation ColorItem

@synthesize  color;
@synthesize  csModeUniID;
@synthesize  itemNo;
@synthesize  uniID;


@end

@implementation CustomMode

@synthesize  colorItems;
@synthesize  itemName;
@synthesize runModeType;
@synthesize  speed;
@synthesize  uniID;

-(id)init
{
    self = [super init];
    if (self) {
        self.colorItems = [NSMutableArray array];
    }
    return self;
}



-(ColorItem*)findColorItemByItemNo:(int)itemNo
{
    ColorItem *r_itm =nil;
    for (ColorItem *itm in self.colorItems) {
        if (itm.itemNo.intValue == itemNo ) {
            r_itm = itm;
            break;
        }
    }
    return r_itm;
}
-(ColorItem*)getnewColorItem
{
    ColorItem *itm = [[ColorItem alloc] init] ;
    [itm setCsModeUniID:self.uniID];
    
    [self.colorItems addObject:itm];
    
    return itm;
}

@end


