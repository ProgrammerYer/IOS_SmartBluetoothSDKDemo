//
//  DeviceListVCtlrler.h
//  LedWifi
//
//  Created by luoke on 12-12-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeviceCell.h"
#import "SMBViewController.h"

@interface DeviceListVCtlrler : SMBViewController<UITableViewDelegate,UITableViewDataSource>
{
    
    IBOutlet UITableView *_tableView;
    IBOutlet UIButton *_btnEnter;
    
    //IBOutlet UIView *_headerView;

    //IBOutlet UILabel *_lblTitle;
}

-(void)Refresh;


@end
