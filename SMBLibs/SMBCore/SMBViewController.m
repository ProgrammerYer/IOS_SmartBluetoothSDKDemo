//
//  SMBViewController.m
//  SMBLibIos
//
//  Created by Mike on 2011/10/3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SMBViewController.h"


@implementation SMBViewController

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}



- (void)viewDidUnload
{
    [super viewDidUnload];
}






#pragma mark 
-(void)showLoading
{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (loadingHUD_==nil)
    {

        loadingHUD_ = [[MBProgressHUD alloc] initWithView:keyWindow];
        [keyWindow addSubview:loadingHUD_];
    }
    [keyWindow bringSubviewToFront:loadingHUD_];
    [loadingHUD_ show:YES];
}
-(void)hideLoading
{
    if (loadingHUD_!=nil) {
        [loadingHUD_ hide:YES];
    }
}

@end