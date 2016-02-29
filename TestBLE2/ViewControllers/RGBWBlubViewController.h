//
//  SMBViewController.h
//  MyKcal
//
//  Created by luoke on 13-4-17.
//  Copyright (c) 2013年 niji-life. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppConfig.h"

@interface RGBWBlubViewController : UIViewController
{
}


@property(nonatomic) LEDDeviceType deviceType;
@property(strong) NSArray *deviceUniIDs;
@property(readonly,nonatomic) int minDeviceVersion;


-(IBAction)btnRedClicked:(id)sender;
-(IBAction)btnBlueClicked:(id)sender;
@end
