//
//  ColorPickerViewController.m
//  LedWifi
//
//  Created by luoke on 12-12-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ColorPickerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "KZColorPicker.h"
#import "KZColorPickerHSWheel.h"
#import "KZColorPickerBrightnessSlider.h"
#import "KZColorPickerAlphaSlider.h"
#import "HSV.h"
#import "UIColor-Expanded.h"
#import "KZColorPickerSwatchView.h"
#import "KZColorCompareView.h"
#import "RGBColorView.h"
#import "AppConfig.h"

@interface ColorPickerViewController ()

@property(retain) KZColorPickerHSWheel *colorWheel;
@property(retain) KZColorPickerBrightnessSlider *colorSlider;
@property(retain) RGBColorView *viewRGBColor;


@end

@implementation ColorPickerViewController

@synthesize colorWheel = _colorWheel;
@synthesize colorSlider = _colorSlider;
@synthesize viewRGBColor = _viewRGBColor;

@synthesize usertag;
@synthesize delegate;
@synthesize selectedColor = _selectedColor;

-(void)dealloc
{
    MCRelease(barItemCancel_);
    MCRelease(barItemConfirm_);
    MCRelease(navigationItem_);

    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(IBAction)cancelClick:(id)sender
{
    if (delegate!=nil) {
        [delegate colorPickerViewController:self didCancelWithTag:self.usertag];
    }
}
-(IBAction)confirmClick:(id)sender
{
    if (delegate!=nil) {
        [delegate colorPickerViewController:self didSelectColorWithTag:self.usertag selectedcolor:self.selectedColor];
    }
}


#pragma mark color change
- (void) setCurrentSelectedColor:(UIColor *)c
{
    //[self.viewRGBColor setColor:c];
    
    RGBType rgb = rgbWithUIColor2(c);
       [self.viewRGBColor setColorByRed:rgb.r green:rgb.g blue:rgb.b];
    
    HSVType hsv = RGB_to_HSV(rgb);
    self.colorWheel.currentHSV = hsv;
    
    
    self.colorSlider.value = hsv.v;
    UIColor *keyColor = [UIColor colorWithHue:hsv.h 
                                   saturation:hsv.s
                                   brightness:1.0
                                        alpha:1.0];
    [self.colorSlider setKeyColor:keyColor];
    [self setSelectedColor:c];
}
RGBType rgbWithUIColor2(UIColor *color)
{
	const CGFloat *components = CGColorGetComponents(color.CGColor);
	
	CGFloat r,g,b;
	
	switch (CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor))) 
	{
		case kCGColorSpaceModelMonochrome:
			r = g = b = components[0];
			break;
		case kCGColorSpaceModelRGB:
			r = components[0];
			g = components[1];
			b = components[2];
			break;
		default:	// We don't know how to handle this model
			return RGBTypeMake(0, 0, 0);
	}
	
	return RGBTypeMake(r, g, b);
}
- (void) colorWheelColorChanged:(KZColorPickerHSWheel *)wheel
{
	HSVType hsv = wheel.currentHSV;
	UIColor *color = [UIColor colorWithHue:hsv.h
                                saturation:hsv.s
                                brightness:hsv.v  //self.colorSlider.value
                                     alpha:1];		
    [self setCurrentSelectedColor:color];
}
- (void) brightnessChanged:(KZColorPickerBrightnessSlider *)slider
{
	HSVType hsv = self.colorWheel.currentHSV;
	
	UIColor *color = [UIColor colorWithHue:hsv.h
                                saturation:hsv.s
                                brightness:self.colorSlider.value
                                     alpha:1];
    //[self setCurrentSelectedColor:color];
    RGBType rgb = rgbWithUIColor2(color);
    [self.viewRGBColor setColorByRed:rgb.r green:rgb.g blue:rgb.b];
    [self setSelectedColor:color];
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    [barItemCancel_ setTitle:NSLocalizedString(@"Cancel", nil)];
    [barItemConfirm_ setTitle:NSLocalizedString(@"Confirm", nil)];
    [navigationItem_ setTitle:NSLocalizedString(@"Select_color", nil)];
    
    [self initView];
    [self setCurrentSelectedColor:[UIColor whiteColor]];
}
-(void)initView
{
    KZColorPickerHSWheel *wheel = [[KZColorPickerHSWheel alloc] initAtOrigin:CGPointMake(0, 0)];
    [wheel addTarget:self action:@selector(colorWheelColorChanged:) forControlEvents:UIControlEventValueChanged];
    [viewColorWheel_ addSubview:wheel];
    self.colorWheel = wheel;
    [wheel release];
    
    //brightness slider
    KZColorPickerBrightnessSlider *colorSlider = [[KZColorPickerBrightnessSlider alloc] initWithFrame:CGRectMake(0,0,272,38)];
    [colorSlider addTarget:self action:@selector(brightnessChanged:) forControlEvents:UIControlEventValueChanged];
    [viewColorSlider_ addSubview:colorSlider];
    self.colorSlider = colorSlider;
    [self.colorSlider setValue:1];
    [colorSlider release];
    
    
    //Color View
    NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"RGBColorView" owner:nil options:nil] ;
    self.viewRGBColor = [nib objectAtIndex:0];
    [viewSpanColor_ addSubview:self.viewRGBColor];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
