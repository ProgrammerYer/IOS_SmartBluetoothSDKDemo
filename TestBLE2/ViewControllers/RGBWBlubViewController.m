//
//  SMBViewController.m
//  MyKcal
//
//  Created by luoke on 13-4-17.
//  Copyright (c) 2013年 niji-life. All rights reserved.
//

#import "RGBWBlubViewController.h"
#import "AppConfig.h"
#import "ConnectionManager.h"
#import "RGBDeviceCMDMgr.h"




@interface RGBWBlubViewController ()


@end

@implementation RGBWBlubViewController

-(void)dealloc
{

}

-(IBAction)btnRedClicked:(id)sender
{
    [self sendColorCommand:[UIColor redColor]];
}

-(IBAction)btnBlueClicked:(id)sender
{
    [self sendColorCommand:[UIColor blueColor]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


#pragma mark - 命令
-(void)sendColorCommand:(UIColor*)color
{
    if (self.deviceType == LED_RGB_W2 || self.deviceType==LED_RGB_Bulb_New || self.deviceType == LED_RGB_Bulb_WithSunn)
    {
        NSData *data = [RGBDeviceCMDMgr getCommandDataForRGBW2ByColor:color warmWhile:0];
        [[ConnectionManager getCurrent] sendDataByUniIDs:self.deviceUniIDs data:data];
    }
    else if (self.deviceType ==LED_RGB)
    {
        NSData *data = [RGBDeviceCMDMgr getCommandDataForRGBColor:color];
        [[ConnectionManager getCurrent] sendDataByUniIDs:self.deviceUniIDs data:data];
    }
    else if (self.deviceType == LED_RGBW_UFO)
    {
        NSData *data = [RGBDeviceCMDMgr getCommandDataForRGBWUFOByColor:color];
        [[ConnectionManager getCurrent] sendDataByUniIDs:self.deviceUniIDs data:data];
    }
    else if (self.deviceType == LED_RGB_HighVoltage)
    {
        NSData *data = [RGBDeviceCMDMgr getCommandDataForRGBColor:color];
        [[ConnectionManager getCurrent] sendDataByUniIDs:self.deviceUniIDs data:data];
    }
}


-(void)sendColorCommandForWarmWhile:(int)warmWhile
{
    if (self.deviceType ==LED_RGB_W2 || self.deviceType == LED_RGB_Bulb_New || self.deviceType == LED_RGB_Bulb_WithSunn)
    {
        NSData *data = [RGBDeviceCMDMgr getCommandDataForRGBW2ByWarmWhile:warmWhile color:[UIColor blackColor]];
        [[ConnectionManager getCurrent] sendDataByUniIDs:self.deviceUniIDs data:data];
    }
    else if (self.deviceType == LED_Color_temperature_Bulb || self.deviceType == LED_Color_temperature_Bulb_New)
    {
        NSData *data = [RGBDeviceCMDMgr getCommandDataForWarmWhileForCCT_Bulb:warmWhile];
        [[ConnectionManager getCurrent] sendDataByUniIDs:self.deviceUniIDs data:data];
    }
    else if (self.deviceType == LED_Color_temperature_CCT)
    {
        NSData *data = [RGBDeviceCMDMgr getCommondDataForWarmValue:warmWhile coolValue:0];
        [[ConnectionManager getCurrent] sendDataByUniIDs:self.deviceUniIDs data:data];
    }
    else if (self.deviceType == LED_RGBW_UFO)
    {
        NSData *data = [RGBDeviceCMDMgr getCommandDataForRGBWUFOByWarmWhile:warmWhile];
        [[ConnectionManager getCurrent] sendDataByUniIDs:self.deviceUniIDs data:data];
    }
}

@end
