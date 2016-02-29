//
//  UIView+Helper.m
//  LedBLEv2
//
//  Created by zhou mingchang on 7/30/15.
//  Copyright (c) 2015 luoke365. All rights reserved.
//

#import "UIView+Helper.h"

@implementation UIView (ColorOfPoint)

- (UIColor *) colorOfPoint:(CGPoint)point
{
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //NSLog(@"pixel: %d %d %d %d", pixel[0], pixel[1], pixel[2], pixel[3]);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}


- (void)setCornerBorder
{
    CALayer * layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor grayColor] CGColor]];
}
- (void)setCornerBlackBorder
{
    CALayer * layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.0];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[[UIColor blackColor] CGColor]];
}
- (void)setCorner
{
    CALayer * layer = [self layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:5.0];
}

- (void)setCornerRadius:(float)cornerRadius
{
    CALayer * layer = [self layer];
    
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:cornerRadius];
}

- (void)setBorder:(UIColor*)color cornerRadius:(float)cornerRadius
{
    CALayer * layer = [self layer];
    [layer setBorderWidth:1.0];
    [layer setBorderColor:[color CGColor]];
    
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:cornerRadius];
}
@end
