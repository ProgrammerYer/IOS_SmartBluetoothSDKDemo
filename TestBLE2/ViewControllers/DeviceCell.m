//
//  PromoItemCell.m
//  FlashPromo
//
//  Created by Administrator on 9/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DeviceCell.h"
#import "AppConfig.h"

@interface DeviceCell ()

@end

@implementation DeviceCell


-(void)initView
{
    //mu地
    UIView *tempView = [[UIView alloc] init];
    [self setBackgroundView:tempView];
    [self setBackgroundColor:[UIColor clearColor]];
    //[viewSpanChecked_ setExclusiveTouch:YES];
    
    [imageView_ setBorder:LineDivider cornerRadius:5];

    //颜色定义----------
    [lblName_ setTextColor:ContentFontColor];
    [lblDetailInfo_ setTextColor:ContentDetailColor];
    [_lblLine setBackgroundColor:LineDivider];
}

+(DeviceCell*)deviceCellFromBundle
{
    DeviceCell *cell;
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"DeviceCell" owner:self options:nil] ;
    cell = [nib objectAtIndex:0];
    [cell initView];
    return cell;
}


-(void)setLedDeviceInfo:(LedDeviceInfo *)dev
{
    [lblName_ setText:dev.localName];
    
    if (AppForFlux || AppForRyanSchultze)
    {
        [lblDetailInfo_ setText:[NSString stringWithFormat:@"Hardware V%d",dev.levVersionNum]];
    }
    else
    {
        [lblDetailInfo_ setText:dev.macAddress];
    }
    
    
    //圖標
    [imageView_ setImage:[UIImage imageNamed:@"icon_led_rgb.png"]];
}

-(void)setNeedSeparator:(BOOL)needshow
{
    if (needshow) {
        [_lblLine setHidden:NO];
    }
    else
    {
        [_lblLine setHidden:YES];
    }
}

@end


