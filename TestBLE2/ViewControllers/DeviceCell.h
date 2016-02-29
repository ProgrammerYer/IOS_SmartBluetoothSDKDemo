//
//  PromoItemCell.h
//  FlashPromo
//
//  Created by Administrator on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LedDeviceInfo.h"

@class DeviceCell;


@interface DeviceCell : UITableViewCell
{
    IBOutlet UIImageView *imageView_;
    IBOutlet UILabel *lblName_;
    IBOutlet UILabel *lblDetailInfo_;
    
    IBOutlet UILabel *_lblLine;
    
}

+(DeviceCell*)deviceCellFromBundle;

-(void)setLedDeviceInfo:(LedDeviceInfo*)dev;
-(void)setNeedSeparator:(BOOL)needshow;

@end
