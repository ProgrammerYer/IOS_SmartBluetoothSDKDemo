//
//  AppDelegate.h
//  TestBLE2
//
//  Created by luoke365 on 12/25/13.
//  Copyright (c) 2013 luoke365. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIViewController *viewController;


+(AppDelegate*)Current;
@end
