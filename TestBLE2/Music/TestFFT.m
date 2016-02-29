//
//  TestFFT.m
//  WiFiPHILIPS
//
//  Created by luoke365 on 1/15/14.
//  Copyright (c) 2014 luoke365. All rights reserved.
//

#import "TestFFT.h"
#import "TheAmazingAudioEngine.h"
#import <Accelerate/Accelerate.h>
#include <libkern/OSAtomic.h>
#import "AppDelegate.h"

#define kRingBufferLength 256 // In frames; higher values mean oscilloscope spans more time
#define kMaxConversionSize 4096


@interface TestFFT () {
    id           _timer;
    float       *_scratchBuffer;
    AudioBufferList *_conversionBuffer;
    float       *_ringBuffer;
    int          _ringBufferHead;
    
    
    int _frames;
    float _audio;
    
}
@property (nonatomic, assign) AEAudioController *audioController;
@property (nonatomic, retain) AEFloatConverter *floatConverter;
@end

static void audioCallback(id THIS, AEAudioController *audioController, void *source, const AudioTimeStamp *time, UInt32 frames, AudioBufferList *audio);


@implementation TestFFT


- (id)initWithAudioController:(AEAudioController*)audioController
{
    if (self) {
        
        self.audioController = audioController;
        self.floatConverter = [[[AEFloatConverter alloc] initWithSourceFormat:self.audioController.audioDescription] autorelease];
        _conversionBuffer = AEAllocateAndInitAudioBufferList(_floatConverter.floatingPointAudioDescription, kMaxConversionSize);
        _ringBuffer = (float*)calloc(kRingBufferLength, sizeof(float));
        _scratchBuffer = (float*)malloc(kRingBufferLength * sizeof(float) * 2);

        
        _frames = 0;
        _audio = 0;
    }
    return self;
}

- (void)start
{
    if ( _timer ) return;
    _timer = [NSTimer scheduledTimerWithTimeInterval:0.10 target:self selector:@selector(doTimer) userInfo:nil repeats:YES];
}

-(void)doTimer
{
    float val =  (_ringBuffer[0]*_ringBuffer[0] + _ringBuffer[1]*_ringBuffer[1])*10;
    //NSLog(@"_ringBuffer value:%f  _ringBuffer[0]:%f",val, _ringBuffer[0]);
    if (self.detegate!=nil) {
        [self.detegate TestFFTdidChangeLight:val*255];
    }
}

- (void)stop {
    if ( !_timer ) return;
    [_timer invalidate];
    _timer = nil;
}


-(AEAudioControllerAudioCallback)receiverCallback {
    return &audioCallback;
}

#pragma mark - Callback

static void audioCallback(id THISptr, AEAudioController *audioController, void *source, const AudioTimeStamp *time, UInt32 frames, AudioBufferList *audio) {
    TestFFT *THIS = (TestFFT*)THISptr;
    
    // Convert audio
    AEFloatConverterToFloatBufferList(THIS->_floatConverter, audio, THIS->_conversionBuffer, frames);
    
    // Get a pointer to the audio buffer that we can advance
    float *audioPtr = THIS->_conversionBuffer->mBuffers[0].mData;
    
    THIS->_audio = *audioPtr;
    THIS->_frames = frames;
    // Copy in contiguous segments, wrapping around if necessary
    int remainingFrames = frames;
    while ( remainingFrames > 0 ) {
        int framesToCopy = MIN(remainingFrames, kRingBufferLength - THIS->_ringBufferHead);
        
        memcpy(THIS->_ringBuffer + THIS->_ringBufferHead, audioPtr, framesToCopy * sizeof(float));
        audioPtr += framesToCopy;
        
        int buffer_head = THIS->_ringBufferHead + framesToCopy;
        if ( buffer_head == kRingBufferLength ) buffer_head = 0;
        OSMemoryBarrier();
        THIS->_ringBufferHead = buffer_head;
        remainingFrames -= framesToCopy;
    }
}
@end
