//
//  KZColorPickerWheel.m
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "KZColorWeamPickerHSWheel.h"
#import "AppConfig.h"

@interface KZColorWeamPickerHSWheel()
@property (nonatomic, retain) UIImageView *wheelImageView;
@property (nonatomic, retain) UIImageView *wheelKnobView;
@end


@implementation KZColorWeamPickerHSWheel
@synthesize wheelImageView;
@synthesize wheelKnobView;
@synthesize currentValue;

- (id)initAtOrigin:(CGPoint)origin
{
    return [self initAtOrigin:origin imageNamed:@"pickerWeamWheel.png"];
}

-(id)initAtOrigin:(CGPoint)origin imageNamed:(NSString*)imageNamed
{
    if ((self = [super initWithFrame:CGRectMake(origin.x, origin.y, 240, 240)]))
	{
        // Initialization code
		// add the imageView for the color wheel
		UIImageView *wheel = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageNamed]];
		wheel.contentMode = UIViewContentModeScaleToFill;
		wheel.frame = CGRectMake(0, 0, 240, 240);
		[self addSubview:wheel];
		self.wheelImageView = wheel;
		[wheel release];
        
		UIImageView *wheelKnob = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"colorPickerKnob.png"]];
		[self addSubview:wheelKnob];
		self.wheelKnobView = wheelKnob;
		[wheelKnob release];
		
		self.userInteractionEnabled = YES;
		self.currentValue = 255;
        
        [self setCurrentColorValue:self.currentValue];
    }
    return self;
}

- (void)dealloc 
{
	[wheelImageView release];
	[wheelKnobView release];
    [super dealloc];
}

//設定位置
- (void) mapPointToColor:(CGPoint) point
{
	CGPoint center = CGPointMake(self.wheelImageView.bounds.size.width * 0.5,
								 self.wheelImageView.bounds.size.height * 0.5);
    double dx = ABS(point.x - center.x);
    double dy = ABS(point.y - center.y);
    double angle = atan(dy / dx);
	if (isnan(angle))
		angle = 0.0;

    double saturation = 0.6;
	
    if (point.x < center.x)
        angle = M_PI - angle;
	
    if (point.y > center.y)
        angle = 2.0 * M_PI - angle;
	
	double radius = self.wheelImageView.bounds.size.width * 0.5 - 3.0f;
	radius *= saturation;
	
	CGFloat x = center.x + cosf(angle) * radius;
	CGFloat y = center.y - sinf(angle) * radius;
	
	x = roundf(x - self.wheelKnobView.bounds.size.width * 0.5) + self.wheelKnobView.bounds.size.width * 0.5;
	y = roundf(y - self.wheelKnobView.bounds.size.height * 0.5) + self.wheelKnobView.bounds.size.height * 0.5;
	self.wheelKnobView.center = CGPointMake(x + self.wheelImageView.frame.origin.x, y + self.wheelImageView.frame.origin.y);
    

    //右邊水平點 ，逆時種 0～1
    double angleRate = angle / (2.0 * M_PI);
    Byte colorValue = [self convertToValueByAngleRate:angleRate];
    self.currentValue = colorValue;
    
    [self sendActionsForControlEvents:UIControlEventValueChanged];
}
-(Byte)convertToValueByAngleRate:(float)angleRate
{
    DebugLog(@"angleRate:%f",angleRate);
    //0度到0.5度 是255到0 
    //0.5度到1度 是0-255
    if (angleRate>0.5)
    {
        float rate = (angleRate-0.5)/0.5;
        return 255*rate;
    }
    else
    {
        float rate = (0.5-angleRate)/0.5;
        return  255*rate;
    }
    //DebugLog(@"setCurrentColorValue:%d",self.currentValue);
}
-(float)convertToAngleRateByColorValue:(float)colorValue
{
    float rate = (colorValue/255) *0.5; // 0~0.5
    
    return 0.5 - rate;
}

- (void) setCurrentColorValue:(double)colorValue
{
    self.currentValue = colorValue;
    
    double s = 0.6;   //固定在中間
    float angleRate = [self convertToAngleRateByColorValue:colorValue];
    DebugLog(@"angleRate:%f",angleRate);
    double angle = angleRate * 2.0 * M_PI;
    
    DebugLog(@"curentVaue:%d",self.currentValue);
    
	CGPoint center = CGPointMake(self.wheelImageView.bounds.size.width * 0.5,
								 self.wheelImageView.bounds.size.height * 0.5);
	double radius = self.wheelImageView.bounds.size.width * 0.5 - 3.0f;
	radius *= s;
	
	CGFloat x = center.x + cosf(angle) * radius;
	CGFloat y = center.y - sinf(angle) * radius;
	
	x = roundf(x - self.wheelKnobView.bounds.size.width * 0.5) + self.wheelKnobView.bounds.size.width * 0.5;
	y = roundf(y - self.wheelKnobView.bounds.size.height * 0.5) + self.wheelKnobView.bounds.size.height * 0.5;
	self.wheelKnobView.center = CGPointMake(x + self.wheelImageView.frame.origin.x, y + self.wheelImageView.frame.origin.y);
}
//- (void) mapPointToColor:(CGPoint) point
//{	
//	CGPoint center = CGPointMake(self.wheelImageView.bounds.size.width * 0.5, 
//								 self.wheelImageView.bounds.size.height * 0.5);
//    double radius = self.wheelImageView.bounds.size.width * 0.5;
//    double dx = ABS(point.x - center.x);
//    double dy = ABS(point.y - center.y);
//    double angle = atan(dy / dx);
//	if (isnan(angle))
//		angle = 0.0;
//	
//    double dist = sqrt(pow(dx, 2) + pow(dy, 2));
//    double saturation = MIN(dist/radius, 1.0);
//    
//	//DebugLog(@"on click dist:%f angle:%f", dist, angle);
//    saturation = 0.6;
////	if (dist < 10)
////        saturation = 0; // snap to center	
//	
//    if (point.x < center.x)
//        angle = M_PI - angle;
//	
//    if (point.y > center.y)
//        angle = 2.0 * M_PI - angle;
//	
//	DebugLog(@"on click h:%f s:%f", angle / (2.0 * M_PI), saturation);
//	
//	//self.currentHSV = HSVTypeMake(angle / (2.0 * M_PI), saturation, 1.0);
//    double h = angle / (2.0 * M_PI);
//    double a = 1 - h;
//    if (a<=0.25)
//    {a = a + 0.75;}
//    else
//    { a = a - 0.25;}
//    double colorValue = 256*a;
//    
//    //[self setCurrentAngle:angle h:angle / (2.0 * M_PI) s:saturation];
//    [self setCurrentColorValue:colorValue];
//	[self sendActionsForControlEvents:UIControlEventValueChanged];
//}
//- (void) setCurrentColorValue:(double)colorValue
//{
//    self.currentValue = colorValue;
//    
//    double s = 0.6;   //固定在中間
//    double a = colorValue/256;
//    if (a>=0.75)
//    {a = a - 0.75;}
//    else
//    { a = a + 0.25;}
//    double h = 1 - a;
//    double angle = h * 2.0 * M_PI;
//
//    DebugLog(@"curentVaue:%d",self.currentValue);
//
//	CGPoint center = CGPointMake(self.wheelImageView.bounds.size.width * 0.5,
//								 self.wheelImageView.bounds.size.height * 0.5);
//	double radius = self.wheelImageView.bounds.size.width * 0.5 - 3.0f;
//	radius *= s;
//	
//	CGFloat x = center.x + cosf(angle) * radius;
//	CGFloat y = center.y - sinf(angle) * radius;
//	
//	x = roundf(x - self.wheelKnobView.bounds.size.width * 0.5) + self.wheelKnobView.bounds.size.width * 0.5;
//	y = roundf(y - self.wheelKnobView.bounds.size.height * 0.5) + self.wheelKnobView.bounds.size.height * 0.5;
//	self.wheelKnobView.center = CGPointMake(x + self.wheelImageView.frame.origin.x, y + self.wheelImageView.frame.origin.y);
//}
//- (void) setCurrentHSV:(HSVType)hsv
//{
//	currentHSV = hsv;
//	currentHSV.v = 1.0;
//	double angle = currentHSV.h * 2.0 * M_PI;
//	CGPoint center = CGPointMake(self.wheelImageView.bounds.size.width * 0.5, 
//								 self.wheelImageView.bounds.size.height * 0.5);
//	double radius = self.wheelImageView.bounds.size.width * 0.5 - 3.0f;
//	radius *= currentHSV.s;
//	
//	CGFloat x = center.x + cosf(angle) * radius;
//	CGFloat y = center.y - sinf(angle) * radius;
//	
//	x = roundf(x - self.wheelKnobView.bounds.size.width * 0.5) + self.wheelKnobView.bounds.size.width * 0.5;
//	y = roundf(y - self.wheelKnobView.bounds.size.height * 0.5) + self.wheelKnobView.bounds.size.height * 0.5;
//	self.wheelKnobView.center = CGPointMake(x + self.wheelImageView.frame.origin.x, y + self.wheelImageView.frame.origin.y);
//}

//- (CGFloat) hue
//{
//	return currentHSV.h;
//}
//
//- (CGFloat) saturation
//{
//	return currentHSV.s;
//}
//
//- (CGFloat) brightness
//{
//	return currentHSV.v;
//}

#pragma mark -
#pragma mark Touches
- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	CGPoint mousepoint = [touch locationInView:self];
	if (!CGRectContainsPoint(self.wheelImageView.frame, mousepoint)) 
		return NO;
	
	[self mapPointToColor:[touch locationInView:self.wheelImageView]];
	return YES;
}

- (BOOL)continueTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self mapPointToColor:[touch locationInView:self.wheelImageView]];
	return YES;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event
{
	[self continueTrackingWithTouch:touch withEvent:event];
}

@end
