//
//  BYAttributesView.m
//  Apsiape
//
//  Created by Dario Lass on 10.09.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

@import MapKit;
#import "BYAttributesView.h"

@interface BYAttributesView ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MKMapView *mapView;

- (void)updateImageViewContent;

@end

@implementation BYAttributesView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.imageView) self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
        [self addSubview:self.imageView];
        if (!self.mapView) self.mapView = [[MKMapView alloc]initWithFrame:CGRectZero];
        [self addSubview:self.mapView];
        self.backgroundColor = [UIColor clearColor];
        self.alwaysBounceVertical = YES;
    }
    return self;
}

- (void)layoutSubviews
{
    self.imageView.frame = CGRectMake(0, 0, 320, 280);
    self.mapView.frame = CGRectMake(0, 340, 320, 280);
    self.imageView.alpha = 1;
    self.mapView.alpha = 1;
    self.mapView.userInteractionEnabled = NO;
    self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), 700);
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    [self updateImageViewContent];
}

- (void)updateImageViewContent
{
    [UIView animateWithDuration:0.2 animations:^{
        self.imageView.alpha = .5;
    } completion:^(BOOL finished) {
        self.imageView.image = self.image;
        [UIView animateWithDuration:0.2 animations:^{
            self.imageView.alpha = 1;
        }];
    }];
}

@end
