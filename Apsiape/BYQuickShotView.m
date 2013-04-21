//
//  BYQuickShotView.m
//  QuickShotView
//
//  Created by Dario Lass on 22.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYQuickShotView.h"
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <QuartzCore/QuartzCore.h>


@interface BYQuickShotView ()

- (AVCaptureDevice*)rearCamera;
- (void)captureImage;
- (CGRect)previewLayerFrame;
- (UIImage*)cropImage:(UIImage*)imageToCrop;
- (void)animateFlash;
- (void)tapDetected;

@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, strong) UIImageView *imagePreView;

@end

#define PREVIEW_LAYER_INSET 8
#define PREVIEW_LAYER_EDGE_RADIUS 10
#define BUTTON_SIZE 50

@implementation BYQuickShotView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        AVCaptureDeviceInput *newVideoInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.rearCamera error:nil];
        AVCaptureStillImageOutput *newStillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:
                                        AVVideoCodecJPEG, AVVideoCodecKey,
                                        nil];
        [newStillImageOutput setOutputSettings:outputSettings];
        
        AVCaptureSession *newCaptureSession = [[AVCaptureSession alloc] init];
        
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
            AVCaptureVideoPreviewLayer *prevLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.captureSession];
            prevLayer.masksToBounds = YES;
            prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            dispatch_async(dispatch_get_main_queue(), ^{
                prevLayer.frame = self.previewLayerFrame;
                [self.layer insertSublayer:prevLayer atIndex:0];
                [self.delegate quickShotViewDidFinishPreparation:self];
            });
        });
    }
    return self;
}

- (UIImageView *)imagePreView
{
    if (!_imagePreView) {
        _imagePreView = [[UIImageView alloc]init];
//        _imagePreView.layer.cornerRadius = PREVIEW_LAYER_EDGE_RADIUS - 1;
        _imagePreView.layer.masksToBounds = YES;
        _imagePreView.frame = self.previewLayerFrame;
        _imagePreView.userInteractionEnabled = NO;
        _imagePreView.backgroundColor = [UIColor clearColor];
    }
    return _imagePreView;
}

- (CGRect)previewLayerFrame
{
    CGRect layerFrame = self.bounds;
    return layerFrame;
}

//This method returns the AVCaptureDevice we want to use as an input for our AVCaptureSession

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

- (void)captureImage
{
    //Before we can take a snapshot, we need to determine the specific connection to be used
    
    NSArray *connections = [self.stillImageOutput connections];
    AVCaptureConnection *stillImageConnection;
    for ( AVCaptureConnection *connection in connections ) {
		for ( AVCaptureInputPort *port in [connection inputPorts] ) {
			if ( [[port mediaType] isEqual:AVMediaTypeVideo] ) {
				stillImageConnection = connection;
			}
		}
	}
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection
                                                       completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
                                                           UIImage *capturedImage;
                                                           if (imageDataSampleBuffer != NULL) {
                                                               // as for now we only save the image to the camera roll, but for reusability we should consider implementing a protocol
                                                               // that returns the image to the object using this view
                                                               NSData *imgData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                                                               capturedImage = [UIImage imageWithData:imgData];
                                                           }
                                                           UIImage *croppedImg = [self cropImage:capturedImage];
                                                           if (!self.imagePreView.superview) {
                                                               [self addSubview:self.imagePreView];
                                                           }
                                                           self.imagePreView.image = croppedImg;
                                                           [self.delegate didTakeSnapshot:croppedImg];
                                                           [self animateFlash];
                                                       }];
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
    UIView *flashView = [[UIView alloc]initWithFrame:self.previewLayerFrame];
    flashView.backgroundColor = [UIColor whiteColor];
    flashView.layer.masksToBounds = YES;
    [self addSubview:flashView];
    [UIView animateWithDuration:0.2 delay:0.1 options:kNilOptions animations:^{
        flashView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [flashView removeFromSuperview];
    }];
}

- (UIImage *)cropImage:(UIImage *)imageToCrop {
    CGSize size = [imageToCrop size];
    int padding = 0;
    int pictureSize;
    int startCroppingPosition;
    if (size.height > size.width) {
        pictureSize = size.width - (2.0 * padding);
        startCroppingPosition = (size.height - pictureSize) / 2.0;
    } else {
        pictureSize = size.height - (2.0 * padding);
        startCroppingPosition = (size.width - pictureSize) / 2.0;
    }
    CGRect cropRect = CGRectMake(startCroppingPosition, padding, pictureSize, pictureSize);
    CGImageRef imageRef = CGImageCreateWithImageInRect([imageToCrop CGImage], cropRect);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:imageToCrop.imageOrientation];
    CGImageRelease(imageRef);
    return newImage;
}

@end
