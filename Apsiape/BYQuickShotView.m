//
//  BYQuickShotView.m
//  QuickShotView
//
//  Created by Dario Lass on 22.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYQuickShotView.h"
#import "UIImage+Adjustments.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <QuartzCore/QuartzCore.h>


@interface BYQuickShotView ()

- (AVCaptureDevice*)rearCamera;
- (void)captureImage;
- (void)animateFlash;
- (void)tapDetected;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) UIImageView *imagePreView;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *prevLayer;
@property (nonatomic) CGRect centerRect;

@end


@implementation BYQuickShotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:.1];
        
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.rearCamera error:nil];
        AVCaptureStillImageOutput *newStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = @{ AVVideoCodecKey : AVVideoCodecJPEG};
        [newStillImageOutput setOutputSettings:outputSettings];
        
        AVCaptureSession *newCaptureSession = [[AVCaptureSession alloc] init];
        newCaptureSession.sessionPreset = AVCaptureSessionPresetPhoto;
        
        if ([newCaptureSession canAddInput:newVideoInput]) {
            [newCaptureSession addInput:newVideoInput];
        }
        
        if ([newCaptureSession canAddOutput:newStillImageOutput]) {
            [newCaptureSession addOutput:newStillImageOutput];
            self.stillImageOutput = newStillImageOutput;
            self.captureSession = newCaptureSession;
        }
        dispatch_queue_t layerQ = dispatch_queue_create("layerQ", NULL);
        dispatch_async(layerQ, ^{
            [self.captureSession startRunning];
            if (!self.prevLayer) self.prevLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
            self.prevLayer.masksToBounds = YES;
            self.prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.layer insertSublayer:self.prevLayer atIndex:0];
                self.prevLayer.frame = self.bounds;
                if ([self.delegate respondsToSelector:@selector(quickShotViewDidFinishPreparation:)]) {
                    [self.delegate quickShotViewDidFinishPreparation:self];
                }
            });
        });
    }
    return self;
}

- (UIImageView *)imagePreView
{
    if (!_imagePreView) {
        _imagePreView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _imagePreView.layer.masksToBounds = YES;
        _imagePreView.userInteractionEnabled = NO;
        _imagePreView.backgroundColor = [UIColor clearColor];
    }
    return _imagePreView;
}

- (AVCaptureDevice *)rearCamera {
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice;
    for (AVCaptureDevice *device in videoDevices)
    {
        if (device.position == AVCaptureDevicePositionBack)
        {
            captureDevice = device;
        }
    }
    return captureDevice;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetected)];
    [self addGestureRecognizer:tgr];
}

- (void)didMoveToSuperview {
    self.prevLayer.frame = self.bounds;
    [self addSubview:self.imagePreView];
    
    CGSize viewSize = self.frame.size;
    if (viewSize.height > viewSize.width) {
        CGFloat borderHeight = ((viewSize.height-viewSize.width)/2);
        CALayer *topLayer = [CALayer layer];
        CALayer *bottomLayer = [CALayer layer];
        topLayer.frame = CGRectMake(0, 0, viewSize.width, borderHeight);
        bottomLayer.frame = CGRectMake(0, viewSize.height - borderHeight, viewSize.width, borderHeight);
        topLayer.backgroundColor = [UIColor whiteColor].CGColor;
        bottomLayer.backgroundColor = [UIColor whiteColor].CGColor;
        topLayer.opacity = 0.7;
        bottomLayer.opacity = 0.7;
        [self.layer addSublayer:topLayer];
        [self.layer addSublayer:bottomLayer];
        self.centerRect = CGRectMake(0, borderHeight, viewSize.width, viewSize.height - (2*borderHeight));
    }
    
}

- (void)captureImage
{
    NSArray *connections = [self.stillImageOutput connections];
    AVCaptureConnection *stillImageConnection;
    for ( AVCaptureConnection *connection in connections ) {
		for ( AVCaptureInputPort *port in [connection inputPorts] ) {
			if ( [[port mediaType] isEqual:AVMediaTypeVideo] ) {
				stillImageConnection = connection;
			}
		}
	}
    if (self.rearCamera) {
        [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                           completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error)
        {
           UIImage *capturedImage;
           if (imageDataSampleBuffer != NULL) {
               NSData *imgData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
               capturedImage = [UIImage imageWithData:imgData];
               UIImage *croppedImg = [capturedImage cropWithSquareRatio];
               self.imagePreView.image = croppedImg;
               self.imagePreView.frame = self.centerRect;
               [self.delegate didTakeSnapshot:croppedImg];
               [self animateFlash];
           } else if (error) {
//               NSLog(@"%@", error.description);
           }
       }];
    }
}

- (void)tapDetected
{
    if (!self.imagePreView.image) {
        [self captureImage];
    } else {
        [self.delegate didDiscardLastImage];
        self.imagePreView.image = nil;
    }
}

- (void)animateFlash {
    UIView *flashView = [[UIView alloc]initWithFrame:self.bounds];
    flashView.backgroundColor = [UIColor whiteColor];
    flashView.layer.masksToBounds = YES;
    [self addSubview:flashView];
    [UIView animateWithDuration:0.2 delay:0.1 options:kNilOptions animations:^{
        flashView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [flashView removeFromSuperview];
    }];
}


@end
