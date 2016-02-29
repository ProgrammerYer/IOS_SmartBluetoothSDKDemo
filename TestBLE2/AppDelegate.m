//
//  AppDelegate.m
//  TestBLE2
//
//  Created by luoke365 on 12/25/13.
//  Copyright (c) 2013 luoke365. All rights reserved.
//

#import "AppDelegate.h"
#import "DeviceListVCtlrler.h"
#import "ConnectionManager.h"
#import "NSStringWrapper.h"
#import "RGBDeviceCMDMgr.h"
#import "CustomMode.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

+(AppDelegate*)Current
{
    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    return delegate;
}

-(void)goToDeviceListVCtlrler
{
    
    UINavigationController *nav = [[UINavigationController alloc] init];
    //[nav setNavigationBarHidden:YES];
    DeviceListVCtlrler *ctr = [[DeviceListVCtlrler alloc] init] ;
    [nav setViewControllers:[NSArray arrayWithObject:ctr]];
    self.viewController = nav;
        self.window.rootViewController = self.viewController;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    if (Style_IsBlackDark) {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
    }
    else
    {
        [application setStatusBarStyle:UIStatusBarStyleDefault];
    }
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[ConnectionManager getCurrent] startScanBLEDevice];
    
    [self goToDeviceListVCtlrler];
    

    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}



@end
