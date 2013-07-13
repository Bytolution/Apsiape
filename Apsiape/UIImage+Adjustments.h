//
//  UIImage+Adjustments.h
//  Apsiape
//
//  Created by Dario Lass on 13.07.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Adjustments)

- (UIImage*)cropWithSquareRatioAndResolution:(CGFloat)resolution;
- (UIImage*)monochromeImage;

@end
