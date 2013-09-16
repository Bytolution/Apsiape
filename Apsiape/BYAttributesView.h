//
//  BYAttributesView.h
//  Apsiape
//
//  Created by Dario Lass on 10.09.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLLocation;

@interface BYAttributesView : UIScrollView

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) NSString *locationDescription;
@property (nonatomic, strong) NSDate *date;

@end
