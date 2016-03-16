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
@property (strong, nonatomic) IBOutlet UISlider *redRGB;
@property (strong, nonatomic) IBOutlet UISlider *greenRGB;
@property (strong, nonatomic) IBOutlet UISlider *bluRGB;
@property (strong, nonatomic) IBOutlet UISlider *warmBright;

@property(nonatomic,assign)float red;
@property(nonatomic,assign)float green;
@property(nonatomic,assign)float blue;
@property(nonatomic,assign)float warm;

@end

@implementation RGBWBlubViewController

-(void)dealloc
{

}
#pragma mark -灯的实现
- (IBAction)redSlider:(UISlider *)sender {
    
    _red=sender.value;
    if (_warm>0)
    {
        _warmBright.value=0.0;
        
    }
    [self sendColorCommand:[UIColor colorWithRed:_red/255.0 green:_green/255.0 blue:_blue/255.0 alpha:1.0]];
     
}
- (IBAction)greenSlider:(UISlider *)sender {
    
    _green=sender.value;
    if (_warm>0)
    {
        _warmBright.value=0.0;
        
    }

    [self sendColorCommand:[UIColor colorWithRed:_red/255.0 green:_green/255.0 blue:_blue/255.0 alpha:1.0]];

}
- (IBAction)blueSlider:(UISlider *)sender {
   
    _blue=sender.value;
    if (_warm>0)
    {
        _warmBright.value=0.0;
        
    }

    [self sendColorCommand:[UIColor colorWithRed:_red/255.0 green:_green/255.0 blue:_blue/255.0 alpha:1.0]];
}
- (IBAction)warmSlider:(UISlider *)sender {
    _warm=sender.value;
    
    if (_red>0 || _green>0 || _blue>0)
    {
        self.redRGB.value=0.0;
        self.greenRGB.value=0.0;
        self.bluRGB.value=0.0;
    }
    
    [self sendColorCommandForWarmWhile:sender.value];
}


#pragma mark -三个按钮的
//七彩渐变
- (IBAction)gradual {
    

    [self sendColorCommandForWarmWhile:0x25 speed:28];
    
}
//七彩频闪
- (IBAction)flash {
    
    [self sendColorCommandForWarmWhile:0x30 speed:25];
    
}
//七彩跳变
- (IBAction)saltus {
    
    [self sendColorCommandForWarmWhile:0x38 speed:28];

}


- (IBAction)sendPredefined {
}



//-(IBAction)btnRedClicked:(id)sender
//{
//    [self sendColorCommand:[UIColor redColor]];
//}
//
//-(IBAction)btnBlueClicked:(id)sender
//{
//    [self sendColorCommand:[UIColor blueColor]];
//}

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

#pragma mark -七彩的
-(void)sendColorCommandForWarmWhile:(int)builtIn speed:(int)speed
{

    if (self.deviceType==LED_RGB_W2 || self.deviceType == LED_RGB_Bulb_New || self.deviceType == LED_RGB_Bulb_WithSunn)
    {
       NSData *data= [RGBDeviceCMDMgr getCommondDataForModeBuiltIn:builtIn speed:speed];
        [[ConnectionManager getCurrent] sendDataByUniIDs:self.deviceUniIDs data:data];
        
    }


}



@end
