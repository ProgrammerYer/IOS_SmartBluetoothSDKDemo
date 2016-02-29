//
//  KZColorPickerWheel.h
//
//  Created by Alex Restrepo on 5/11/11.
//  Copyright 2011 KZLabs http://kzlabs.me
//  All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSV.h"

@interface KZColorWeamPickerHSWheel : UIControl
{
	UIImageView *wheelImageView;
	UIImageView *wheelKnobView;
	
	//HSVType currentHSV;
}

@property (nonatomic) Byte currentValue;

- (id)initAtOrigin:(CGPoint)origin;
-(id)initAtOrigin:(CGPoint)origin imageNamed:(NSString*)imageNamed;

- (void) setCurrentColorValue:(double)colorValue;
@end
