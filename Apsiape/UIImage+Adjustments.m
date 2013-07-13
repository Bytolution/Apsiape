//
//  UIImage+Adjustments.m
//  Apsiape
//
//  Created by Dario Lass on 13.07.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <CoreImage/CoreImage.h>
#import "UIImage+Adjustments.h"

@implementation UIImage (Adjustments)

- (UIImage *)cropWithSquareRatio
{
    UIImage *sourceImg = (UIImage*)self;
    CGSize size = [sourceImg size];
    NSLog(@"%@", NSStringFromCGSize(size));
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
    CGImageRef imageRef = CGImageCreateWithImageInRect([sourceImg CGImage], cropRect);
    UIImage *newImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:sourceImg.imageOrientation];
    CGImageRelease(imageRef);
    return newImage;
}

- (UIImage *)makeMonochrome
{
    CIImage *beginImage = [CIImage imageWithCGImage:self.CGImage];
    
    CIImage *output = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey, beginImage, @"inputIntensity", [NSNumber numberWithFloat:1.0], @"inputColor", [[CIColor alloc] initWithColor:[UIColor whiteColor]], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage];
    
    CGImageRelease(cgiimage);
    
    return newImage;
}

@end
