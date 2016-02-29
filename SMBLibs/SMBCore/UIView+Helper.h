//
//  UIView+Helper.h
//  LedBLEv2
//
//  Created by zhou mingchang on 7/30/15.
//  Copyright (c) 2015 luoke365. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIView (ColorOfPoint)

- (UIColor *) colorOfPoint:(CGPoint)point;

- (void)setCornerBlackBorder;
- (void)setCornerBorder;
- (void)setCorner;

- (void)setCornerRadius:(float)cornerRadius;

- (void)setBorder:(UIColor*)color cornerRadius:(float)cornerRadius;
@end
