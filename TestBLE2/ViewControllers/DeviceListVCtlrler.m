//
//  DeviceListVCtlrler.m
//  LedWifi
//
//  Created by luoke on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "DeviceListVCtlrler.h"
#import "AppConfig.h"
#import "LedDeviceInfo.h"
#import "ConnectionManager.h"
#import "LEDCommandService.h"
#import "DeviceStateInfoBase.h"
#import "UIColor-Expanded.h"
#import "RGBWBlubViewController.h"

typedef NS_ENUM(NSUInteger, EnableAddToGroupType) {
    EnableAddToGroupType_Disable = 0,
    EnableAddToGroupType_Same = 1,
    EnableAddToGroupType_Different = 2,
};

@interface DeviceListVCtlrler ()

@property(strong) NSArray *devicelist;
@property(strong) NSTimer *timer;

@property(assign) int selectedDeviceType;

@end

@implementation DeviceListVCtlrler


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        self.selectedDeviceType = LED_Undown;
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onDidConnectionManagerDataSetChanged)
                                                     name:ConnectionManagerDataSetChangedNotification object:nil];
    }
    return self;
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(void)btnRefreshClick:(id)sender
{
    [[ConnectionManager getCurrent] reScanBLEDevice];
    [self DisplayList];
}

-(IBAction)btnHelpClick:(id)sender
{
}
#pragma mark - 主邏輯
-(void)Refresh
{
    [[ConnectionManager getCurrent] reScanBLEDevice];
    [self DisplayList];
}
-(void)DisplayList
{
    self.devicelist = [[ConnectionManager getCurrent] getAllDeviceList];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
  
    [_tableView reloadData];
}

-(void)onDidConnectionManagerDataSetChanged
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(DisplayList) object:nil];
    [self performSelector:@selector(DisplayList) withObject:nil afterDelay:1];
    
    [self DisplayList];
}
-(void)onDidDisconnectPeripheral:(NSNotification *)notification
{
    NSString *uuID = [notification object];
    NSLog(@"onDidDisconnectPeripheral uuID :%@",uuID);
    
}


-(void)onEnterDeviceInfo:(LedDeviceInfo*)dev
{
    [self showLoading];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //执行长时间操作
        NSError *error = nil;
        DeviceStateInfoBase *devState = [LEDCommandService getDeviceStateInfoBaseByUniID:dev.macAddress error:&error];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self hideLoading];
            
            if (devState!=nil && error==nil)
            {
                dev.deviceType = devState.deviceType;
                [self startLEDControlTabVCtrllerByTitle:dev.localName deviceUniIDs:[NSArray arrayWithObject:dev.macAddress] deviceType:dev.deviceType];
            }
            else
            {
                //失败
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"LIST_Connecting_failed_Note", nil) message:NSLocalizedString(@"LIST_Connecting_failed", nil) delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                [alert show];
                NSLog(@"getRGB_WDeviceStateInfoByUniID failed:%@",[error debugDescription]);
            }
        });
    });
}



#pragma mark - Enter Control

-(void)startLEDControlTabVCtrllerByTitle:(NSString*)title deviceUniIDs:(NSArray*)deviceUniIDs deviceType:(LEDDeviceType)deviceType
{
    if (deviceType == LED_RGB || deviceType == LED_RGB_HighVoltage) {
//        RGBTabVCtrller *ctr = [[RGBTabVCtrller alloc] init];
//        [ctr setDeviceUniIDs:deviceUniIDs];
//        [ctr setDeviceType:deviceType];
//        [ctr setTitle:title];
//        [self.navigationController pushViewController:ctr animated:YES];
    }
    else if (deviceType == LED_RGB_W2 || deviceType == LED_RGB_Bulb_New || deviceType == LED_RGB_Bulb_WithSunn
             || deviceType == LED_RGBW_UFO)
    {
        RGBWBlubViewController *ctr = [[RGBWBlubViewController alloc] init];
        [ctr setDeviceUniIDs:deviceUniIDs];
        [ctr setDeviceType:deviceType];
        [ctr setTitle:title];
        [self.navigationController pushViewController:ctr animated:YES];
    }
    else if (deviceType == LED_Color_temperature_Bulb || deviceType == LED_Color_temperature_Bulb_New)
    {
//        ColorTemp_BulbTabVCtrller *ctr = [[ColorTemp_BulbTabVCtrller alloc] init];
//        [ctr setDeviceUniIDs:deviceUniIDs];
//        [ctr setDeviceType:deviceType];
//        [ctr setTitle:title];
//        [self.navigationController pushViewController:ctr animated:YES];
    }
    else if (deviceType == LED_Brightness)
    {
//        BrightnessTabVCtrller *ctr = [[BrightnessTabVCtrller alloc] init];
//        [ctr setDeviceUniIDs:deviceUniIDs];
//        [ctr setDeviceType:deviceType];
//        [ctr setTitle:title];
//        [self.navigationController pushViewController:ctr animated:YES];
    }
    else if (deviceType == LED_Color_temperature_CCT)
    {
//        ColorTempTabVCtrller *ctr = [[ColorTempTabVCtrller alloc] init];
//        [ctr setDeviceUniIDs:deviceUniIDs];
//        [ctr setDeviceType:deviceType];
//        [ctr setTitle:title];
//        [self.navigationController pushViewController:ctr animated:YES];
        
    }
}
#pragma mark - scan ip




#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return self.devicelist.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LedDeviceInfo *itm = [self.devicelist objectAtIndex:indexPath.row];

        DeviceCell *cell = [DeviceCell deviceCellFromBundle];
        [cell setLedDeviceInfo:itm];
        [cell setNeedSeparator:YES];
        return cell;
}


#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    LedDeviceInfo *dev = [self.devicelist objectAtIndex:indexPath.row];
    [self onEnterDeviceInfo:dev];
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - ViewLife
-(void)initView
{
    //颜色定义----------
    [_tableView setBackgroundColor:ContentBgColor];

    
    //颜色定义----------
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initView];
    
    self.navigationItem.title = @"Device List";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(btnRefreshClick:)];

    [_tableView setSeparatorColor:[UIColor clearColor]];
    [self DisplayList];
}

@end


