//
//  ListValueItem.h
//  WiFiPHILIPS
//
//  Created by luoke365 on 1/11/14.
//  Copyright (c) 2014 luoke365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ListValueItem : NSObject

@property(strong,nonatomic) NSString *name;
@property(assign,nonatomic) int val;

+(ListValueItem*)createListValueItem:(int)value name:(NSString*)name;

@end
