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
    CGFloat border;
    if (self.bounds.size.width < self.bounds.size.height) {
        border = ((self.bounds.size.height - self.bounds.size.width)/2.0f);
        self.imagePreView.frame = CGRectMake(0, border, self.frame.size.width, self.frame.size.width);
    } else {
        border = ((self.bounds.size.width - self.bounds.size.height)/2.0f);
        self.imagePreView.frame = CGRectMake(border, 0, self.frame.size.width, self.frame.size.width);
    }
    [self addSubview:self.imagePreView];
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
                                                           completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
           if (imageDataSampleBuffer != NULL) {
               NSData *imgData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
               self.fullResCapturedImage = [[UIImage imageWithData:imgData] cropWithSquareRatioAndResolution:0];
               UIImage *croppedImg = [self.fullResCapturedImage cropWithSquareRatioAndResolution:self.bounds.size.width * [[UIScreen mainScreen] scale]];
               self.imagePreView.image = croppedImg;
               [self.delegate didTakeSnapshot:self.fullResCapturedImage];
               [self animateFlash];
           } else if (error) {
               NSLog(@"%@", error.description);
           }
       }];
    }
}

- (void)tapDetected
{
    if (!self.fullResCapturedImage) {
        [self captureImage];
    } else {
        [self.delegate didDiscardLastImage];
        self.imagePreView.image = nil;
        self.fullResCapturedImage = nil;
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
