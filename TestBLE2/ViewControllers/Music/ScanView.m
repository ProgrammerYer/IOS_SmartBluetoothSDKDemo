//
//  ScanView.m
//  LedBLEv2
//
//  Created by zhou mingchang on 15/7/9.
//  Copyright (c) 2015年 luoke365. All rights reserved.
//

#import "ScanView.h"
#import <AVFoundation/AVFoundation.h>


static inline double radians (double degrees) {return degrees * M_PI/180;}

@interface ScanView()<AVCaptureVideoDataOutputSampleBufferDelegate>

@property AVCaptureVideoPreviewLayer* previewLayer;
@property AVCaptureSession* session;
@property AVCaptureDevice* videoDevice;
@property dispatch_queue_t camera_sample_queue;
@property CALayer* coverLayer;
@property CAShapeLayer* cropLayer;
@property CALayer* stillImageLayer;
@property  AVCaptureStillImageOutput* stillImageOutput;

@property UIImageView* stillImageView;
@property UIImage* cropImage;

@property BOOL hasSetFocus;



@end

@implementation ScanView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.hasSetFocus = NO;
        [self initAVCaptuer];
        [self initOtherLayers];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */
-(void)layoutSubviews
{
    [self.previewLayer setFrame:self.bounds];
    [self.coverLayer setFrame:self.bounds];
    self.coverLayer.mask = self.cropLayer;
}

- (void) initAVCaptuer{
    
    self.cropRect = CGRectZero;
    
    self.videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput* input = [[AVCaptureDeviceInput alloc]initWithDevice:self.videoDevice error:nil];
    
    AVCaptureVideoDataOutput* output = [[AVCaptureVideoDataOutput alloc]init];
    output.alwaysDiscardsLateVideoFrames = YES;
    self.camera_sample_queue = dispatch_queue_create ("com.scan.video.sample_queue", DISPATCH_QUEUE_SERIAL);
    [output setSampleBufferDelegate:self queue:self.camera_sample_queue];
    
    NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
    NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
    NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
    [output setVideoSettings:videoSettings];
    
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc]init];
    NSDictionary* outputSettings = @{AVVideoCodecKey:AVVideoCodecJPEG};
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    self.session = [[AVCaptureSession alloc]init];
    self.session.sessionPreset = AVCaptureSessionPresetHigh;
    
    if ([self.session canAddInput:input])
    {
        [self.session addInput:input];
        
        if ([self.session canAddOutput:output])
        {
            [self.session addOutput:self.stillImageOutput];
            [self.session addOutput:output];
            
            self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
            self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            
            [self.layer addSublayer: self.previewLayer];
            
            return; // success
        }
    }
    
    self.session = nil;
}

- (void)setCropRect:(CGRect)cropRect
{
    _cropRect = cropRect;
    if(!CGRectEqualToRect(CGRectZero, self.cropRect)){
        
        self.cropLayer = [[CAShapeLayer alloc] init];
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathAddRect(path, nil, self.cropRect);
        CGPathAddRect(path, nil, self.bounds);
        
        [self.cropLayer setFillRule:kCAFillRuleEvenOdd];
        [self.cropLayer setPath:path];
        [self.cropLayer setFillColor:[[UIColor whiteColor] CGColor]];
        
        [self.cropLayer setNeedsDisplay];
        
        //[self setVideoFocus];
        
    }
    
    [self.stillImageLayer setFrame:CGRectMake(100, 450, CGRectGetWidth(cropRect), CGRectGetHeight(cropRect))];
}

- (void) setVideoFocus{
    
    NSError *error;
    CGPoint foucsPoint = CGPointMake(CGRectGetMidX(self.cropRect), CGRectGetMidY(self.cropRect));
    if([self.videoDevice isFocusPointOfInterestSupported]
       &&[self.videoDevice lockForConfiguration:&error] &&!self.hasSetFocus){
        self.hasSetFocus = YES;
        [self.videoDevice setFocusPointOfInterest:[self convertToPointOfInterestFromViewCoordinates:foucsPoint]];
        [self.videoDevice setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
        [self.videoDevice unlockForConfiguration];
    }
    //    [self.videoDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    NSLog(@"error:%@",error);
    
}


- (CGPoint)convertToPointOfInterestFromViewCoordinates:(CGPoint)viewCoordinates
{
    CGPoint pointOfInterest = CGPointMake(.5f, .5f);
    CGSize frameSize = self.frame.size;
    
    AVCaptureVideoPreviewLayer *videoPreviewLayer = self.previewLayer;
    
    if ([self.previewLayer isMirrored]) {
        viewCoordinates.x = frameSize.width - viewCoordinates.x;
    }
    
    if ( [[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResize] ) {
        pointOfInterest = CGPointMake(viewCoordinates.y / frameSize.height, 1.f - (viewCoordinates.x / frameSize.width));
    } else {
        CGRect cleanAperture;
        for (AVCaptureInputPort *port in [[[[self session] inputs] lastObject] ports]) {
            if ([port mediaType] == AVMediaTypeVideo) {
                cleanAperture = CMVideoFormatDescriptionGetCleanAperture([port formatDescription], YES);
                CGSize apertureSize = cleanAperture.size;
                CGPoint point = viewCoordinates;
                
                CGFloat apertureRatio = apertureSize.height / apertureSize.width;
                CGFloat viewRatio = frameSize.width / frameSize.height;
                CGFloat xc = .5f;
                CGFloat yc = .5f;
                
                if ( [[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspect] ) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = frameSize.height;
                        CGFloat x2 = frameSize.height * apertureRatio;
                        CGFloat x1 = frameSize.width;
                        CGFloat blackBar = (x1 - x2) / 2;
                        if (point.x >= blackBar && point.x <= blackBar + x2) {
                            xc = point.y / y2;
                            yc = 1.f - ((point.x - blackBar) / x2);
                        }
                    } else {
                        CGFloat y2 = frameSize.width / apertureRatio;
                        CGFloat y1 = frameSize.height;
                        CGFloat x2 = frameSize.width;
                        CGFloat blackBar = (y1 - y2) / 2;
                        if (point.y >= blackBar && point.y <= blackBar + y2) {
                            xc = ((point.y - blackBar) / y2);
                            yc = 1.f - (point.x / x2);
                        }
                    }
                } else if ([[videoPreviewLayer videoGravity] isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
                    if (viewRatio > apertureRatio) {
                        CGFloat y2 = apertureSize.width * (frameSize.width / apertureSize.height);
                        xc = (point.y + ((y2 - frameSize.height) / 2.f)) / y2;
                        yc = (frameSize.width - point.x) / frameSize.width;
                    } else {
                        CGFloat x2 = apertureSize.height * (frameSize.height / apertureSize.width);
                        yc = 1.f - ((point.x + ((x2 - frameSize.width) / 2)) / x2);
                        xc = point.y / frameSize.height;
                    }
                    
                }
                
                pointOfInterest = CGPointMake(xc, yc);
                break;
            }
        }
    }
    
    return pointOfInterest;
}

- (void) initOtherLayers{
    self.coverLayer = [CALayer layer];
    
    self.coverLayer.backgroundColor = [[[UIColor blackColor] colorWithAlphaComponent:0.6] CGColor];
    [self.layer addSublayer:self.coverLayer];
    
    if(!CGRectEqualToRect(CGRectZero, self.cropRect)){
        
        self.cropLayer = [[CAShapeLayer alloc] init];
        CGMutablePathRef path = CGPathCreateMutable();
        
        CGPathAddRect(path, nil, self.cropRect);
        CGPathAddRect(path, nil, self.bounds);
        
        [self.cropLayer setFillRule:kCAFillRuleEvenOdd];
        [self.cropLayer setPath:path];
        [self.cropLayer setFillColor:[[UIColor redColor] CGColor]];
    }
    
    self.stillImageLayer = [CALayer layer];
    self.stillImageLayer.backgroundColor = [[UIColor yellowColor] CGColor];
    self.stillImageLayer.contentsGravity = kCAGravityResizeAspect;
    [self.coverLayer addSublayer:self.stillImageLayer];
    
    
    self.stillImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0,300, 100, 100)];
    self.stillImageView.backgroundColor = [UIColor redColor];
    self.stillImageView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.stillImageView];
    
    
    self.previewLayer.contentsGravity = kCAGravityResizeAspect;
    
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    
    [self setVideoFocus];
    
    UIImage *image = [self imageFromSampleBuffer:sampleBuffer];
    self.cropImage = [self cropImageInRect:image];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [self.stillImageView setImage:image];
        // [self.stillImageLayer setContents:(id)[self.cropImage CGImage]];
    });
    
}
// 通过抽样缓存数据创建一个UIImage对象
- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // 为媒体数据设置一个CMSampleBuffer的Core Video图像缓存对象
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // 锁定pixel buffer的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // 得到pixel buffer的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // 得到pixel buffer的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到pixel buffer的宽和高
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    //NSLog(@"%zu,%zu",width,height);
    
    // 创建一个依赖于设备的RGB颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphics context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    
    // 根据这个位图context中的像素数据创建一个Quartz image对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // 释放context和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    //    cgimageget`
    
    // 用Quartz image创建一个UIImage对象image
    //UIImage *image = [UIImage imageWithCGImage:quartzImage];
    UIImage *image = [UIImage imageWithCGImage:quartzImage scale:1.0f orientation:UIImageOrientationRight];
    
    // 释放Quartz image对象
    CGImageRelease(quartzImage);
    
    return (image);
    
    
}



- (CGRect) calcRect:(CGSize)imageSize{
    NSString* gravity = self.previewLayer.videoGravity;
    CGRect cropRect = self.cropRect;
    CGSize screenSize = self.previewLayer.bounds.size;
    
    CGFloat screenRatio = screenSize.height / screenSize.width ;
    CGFloat imageRatio = imageSize.height /imageSize.width;
    
    CGRect presentImageRect = self.previewLayer.bounds;
    CGFloat scale = 1.0;
    
    
    if([AVLayerVideoGravityResizeAspect isEqual: gravity]){
        
        CGFloat presentImageWidth = imageSize.width;
        CGFloat presentImageHeigth = imageSize.height;
        if(screenRatio > imageRatio){
            presentImageWidth = screenSize.width;
            presentImageHeigth = presentImageWidth * imageRatio;
            
        }else{
            presentImageHeigth = screenSize.height;
            presentImageWidth = presentImageHeigth / imageRatio;
        }
        
        presentImageRect.size = CGSizeMake(presentImageWidth, presentImageHeigth);
        presentImageRect.origin = CGPointMake((screenSize.width-presentImageWidth)/2.0, (screenSize.height-presentImageHeigth)/2.0);
        
    }else if([AVLayerVideoGravityResizeAspectFill isEqual:gravity]){
        
        CGFloat presentImageWidth = imageSize.width;
        CGFloat presentImageHeigth = imageSize.height;
        if(screenRatio > imageRatio){
            presentImageHeigth = screenSize.height;
            presentImageWidth = presentImageHeigth / imageRatio;
        }else{
            presentImageWidth = screenSize.width;
            presentImageHeigth = presentImageWidth * imageRatio;
        }
        
        presentImageRect.size = CGSizeMake(presentImageWidth, presentImageHeigth);
        presentImageRect.origin = CGPointMake((screenSize.width-presentImageWidth)/2.0, (screenSize.height-presentImageHeigth)/2.0);
        
    }else{
        NSAssert(0, @"dont support:%@",gravity);
    }
    
    scale = CGRectGetWidth(presentImageRect) / imageSize.width;
    
    CGRect rect = cropRect;
    rect.origin = CGPointMake(CGRectGetMinX(cropRect)-CGRectGetMinX(presentImageRect), CGRectGetMinY(cropRect)-CGRectGetMinY(presentImageRect));
    
    rect.origin.x /= scale;
    rect.origin.y /= scale;
    rect.size.width /= scale;
    rect.size.height  /= scale;
    
    return rect;
}

#define SUBSET_SIZE 360

- (UIImage*) cropImageInRect:(UIImage*)image{
    
    CGSize size = [image size];
    CGRect cropRect = [self calcRect:size];
    
    float scale = fminf(1.0f, fmaxf(SUBSET_SIZE / cropRect.size.width, SUBSET_SIZE / cropRect.size.height));
    CGPoint offset = CGPointMake(-cropRect.origin.x, -cropRect.origin.y);
    
    size_t subsetWidth = cropRect.size.width * scale;
    size_t subsetHeight = cropRect.size.height * scale;
    
    
    CGColorSpaceRef grayColorSpace = CGColorSpaceCreateDeviceGray();
    
    CGContextRef ctx =
    CGBitmapContextCreate(nil,
                          subsetWidth,
                          subsetHeight,
                          8,
                          0,
                          grayColorSpace,
                          kCGImageAlphaNone|kCGBitmapByteOrderDefault);
    CGColorSpaceRelease(grayColorSpace);
    CGContextSetInterpolationQuality(ctx, kCGInterpolationNone);
    CGContextSetAllowsAntialiasing(ctx, false);
    
    // adjust the coordinate system
    CGContextTranslateCTM(ctx, 0.0, subsetHeight);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    
    UIGraphicsPushContext(ctx);
    CGRect rect = CGRectMake(offset.x * scale, offset.y * scale, scale * size.width, scale * size.height);
    
    [image drawInRect:rect];
    
    UIGraphicsPopContext();
    
    CGContextFlush(ctx);
    
    
    CGImageRef subsetImageRef = CGBitmapContextCreateImage(ctx);
    
    UIImage* subsetImage = [UIImage imageWithCGImage:subsetImageRef];
    
    CGImageRelease(subsetImageRef);
    
    CGContextRelease(ctx);
    
    
    return subsetImage;
}



- (void) start{
    
    dispatch_sync (self.camera_sample_queue, ^{
        [self.session startRunning]; });
    
}
- (void) stop{
    if(self.session){
        [self.session stopRunning];
    }
    
}


@end
