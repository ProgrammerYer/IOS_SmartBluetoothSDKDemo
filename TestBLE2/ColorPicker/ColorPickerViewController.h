//
//  ColorPickerViewController.h
//  LedWifi
//
//  Created by luoke on 12-12-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ColorPickerViewController;

@protocol ColorPickerViewControllerrDelegate <NSObject>

// delegate function which is called on ok button.
- (void)colorPickerViewController:(ColorPickerViewController *)colorPicker
            didSelectColorWithTag:(NSInteger)usertag
                    selectedcolor:(UIColor*)color;

// delegate function which is called on cancel button
- (void)colorPickerViewController:(ColorPickerViewController *)colorPicker
                 didCancelWithTag:(NSInteger)usertag;

@end

@interface ColorPickerViewController : UIViewController
{
    IBOutlet UIView *viewColorWheel_;
    IBOutlet UIView *viewColorSlider_;
    
    IBOutlet UIView *viewSpanColor_;
    
    IBOutlet UIBarButtonItem *barItemCancel_;
    IBOutlet UIBarButtonItem *barItemConfirm_;
    IBOutlet UINavigationItem *navigationItem_;
}

@property NSInteger usertag;
@property(assign) id<ColorPickerViewControllerrDelegate> delegate;
@property(retain) UIColor *selectedColor;

-(IBAction)cancelClick:(id)sender;
-(IBAction)confirmClick:(id)sender;
@end
