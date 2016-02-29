//
//  ListValueItem.m
//  WiFiPHILIPS
//
//  Created by luoke365 on 1/11/14.
//  Copyright (c) 2014 luoke365. All rights reserved.
//

#import "ListValueItem.h"

@implementation ListValueItem

+(ListValueItem*)createListValueItem:(int)value name:(NSString*)name
{
    ListValueItem *itm = [[ListValueItem alloc] init];
    [itm setName:name];
    [itm setVal:value];
    
    return itm;
}

@end
