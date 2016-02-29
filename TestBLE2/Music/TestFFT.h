//
//  TestFFT.h
//  WiFiPHILIPS
//
//  Created by luoke365 on 1/15/14.
//  Copyright (c) 2014 luoke365. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TheAmazingAudioEngine.h"

@protocol TestFFTDelegate <NSObject>

-(void)TestFFTdidChangeLight:(int)lightValue;

@end


@interface TestFFT : NSObject <AEAudioReceiver>

@property(assign) id<TestFFTDelegate> detegate;

- (id)initWithAudioController:(AEAudioController*)audioController;

- (void)start;

- (void)stop;

- (AEAudioControllerAudioCallback)receiverCallback;

@end
