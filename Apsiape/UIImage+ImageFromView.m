//
//  UIImage+ImageFromView.m
//  Apsiape
//
//  Created by Dario Lass on 03.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "UIImage+ImageFromView.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIImage (ImageFromView)

+ (UIImage*)imageFromView:(UIView*)view {
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *resultingImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultingImage;
}

@end
