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

- (UIImage *)cropWithSquareRatioAndResolution:(CGFloat)resolution
{
    UIImage *sourceImg = (UIImage*)self;
    CGSize size = [sourceImg size];
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
    if (resolution == 0) resolution = sourceImg.size.width;
    CGRect cropRect = CGRectMake(startCroppingPosition, padding, pictureSize, pictureSize);    
    CGRect newRect = CGRectIntegral(CGRectMake(0, 0,resolution, resolution));
    CGImageRef imageRef = CGImageCreateWithImageInRect([sourceImg CGImage], cropRect);
    
    // Build a context that's the same dimensions as the new size
    CGContextRef bitmap = CGBitmapContextCreate(NULL,
                                                newRect.size.width,
                                                newRect.size.height,
                                                CGImageGetBitsPerComponent(imageRef),
                                                0,
                                                CGImageGetColorSpace(imageRef),
                                                CGImageGetBitmapInfo(imageRef));

    CGContextSetInterpolationQuality(bitmap, kCGInterpolationHigh);
    CGContextDrawImage(bitmap, newRect, imageRef);
    CGImageRef newImageRef = CGBitmapContextCreateImage(bitmap);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:1.0 orientation:self.imageOrientation];
    
    // Clean up
    CGContextRelease(bitmap);
    CGImageRelease(newImageRef);
    CGImageRelease(imageRef);
    
    return newImage;
}

- (UIImage *)monochromeImage
{
    CIImage *beginImage = [CIImage imageWithCGImage:self.CGImage];
    
    CIImage *output = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey, beginImage, @"inputIntensity", [NSNumber numberWithFloat:1], @"inputColor", [[CIColor alloc] initWithColor:[UIColor whiteColor]], nil].outputImage;
    
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef cgiimage = [context createCGImage:output fromRect:output.extent];
    UIImage *newImage = [UIImage imageWithCGImage:cgiimage scale:1.0 orientation:self.imageOrientation];
    CGImageRelease(cgiimage);
    return newImage;
}

@end
