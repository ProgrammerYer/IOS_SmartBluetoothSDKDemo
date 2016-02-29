//
//  SMBViewController.h
//  該類主要是將常用的功能封裝成我們自己的SMB基類
//  常用功能：照相或選圖片、選擇日期、顯示載入中、
//
//  Created by Mike on 2011/10/3.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SMBViewController : UIViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate,MBProgressHUDDelegate>{
   
    MBProgressHUD *loadingHUD_;
    
}


-(void)showLoading;
-(void)hideLoading;
@end