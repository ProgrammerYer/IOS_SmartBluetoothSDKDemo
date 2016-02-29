//
//  ScanView.h
//  LedBLEv2
//
//  Created by zhou mingchang on 15/7/9.
//  Copyright (c) 2015年 luoke365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanView : UIView

@property(nonatomic) CGRect cropRect;

- (void) start;
- (void) stop;
@end
