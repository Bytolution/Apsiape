//
//  BYCollectionViewCell.m
//  Apsiape
//
//  Created by Dario Lass on 04.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BYCollectionViewCell.h"
#import "Expense.h"

#pragma mark ––– UICollectionViewCellContentView implementation

@interface BYCollectionViewCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *foregroundImageView;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;

- (void)handleGesture:(UIGestureRecognizer*)gestureRecognizer;

@end

@implementation BYCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc]initWithFrame:CGRectZero];
        self.label.textAlignment = NSTextAlignmentLeft;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor blackColor];
        self.label.font = [UIFont fontWithName:@"Miso" size:48];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        self.imageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.foregroundImageView];
        [self.contentView addSubview:self.label];
        self.backgroundColor = [UIColor colorWithWhite:0.93 alpha:1];
        
        self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
        self.panRecognizer.delegate = self;
        [self addGestureRecognizer:self.panRecognizer];
    }
    return self;
}


-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if ([panGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [panGestureRecognizer translationInView:[self superview]];
        NSLog(@"%@" ,NSStringFromCGPoint(translation));
        return (fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO;
    } else {
        return NO;
    }
}

- (void)handleGesture:(UIPanGestureRecognizer *)gestureRecognizer
{
    CGPoint translation = [gestureRecognizer translationInView:gestureRecognizer.view];
    CGPoint velocity = [gestureRecognizer velocityInView:gestureRecognizer.view];
    CGFloat panOffset = translation.x;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat offset = abs(translation.x);
    panOffset = (offset * 0.55f * width) / (offset * 0.55f + width);
    panOffset *= translation.x < 0 ? -1.0f : 1.0f;
    self.contentView.frame = CGRectOffset(self.contentView.bounds, panOffset, 0);
}


- (void)setTitle:(NSString *)title
{
    _title = title;
    self.label.text = _title;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = _image;
}

- (void)setBgIsGreen:(BOOL)bgIsGreen
{
    if (bgIsGreen) self.contentView.backgroundColor = [UIColor colorWithRed:1 green:0.2 blue:0.2 alpha:1]; else self.backgroundColor = [UIColor whiteColor];
}

- (void)didMoveToSuperview
{
    CGRect rect = self.contentView.bounds;
    rect.size.height = self.contentView.bounds.size.height/2;
    rect.origin.x = self.frame.size.height;
    self.label.frame = CGRectInset(rect, 10, 10);
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    self.foregroundImageView.frame = self.contentView.bounds;
    
    if (self.bgIsGreen) self.contentView.backgroundColor = [UIColor colorWithRed:1 green:0.2 blue:0.2 alpha:1];
    
    CALayer *borderLayer = [CALayer layer];
    borderLayer.borderColor = [UIColor blackColor].CGColor;
    borderLayer.borderWidth = 0.5;
    borderLayer.frame = self.bounds;
//    [self.contentView.layer addSublayer:borderLayer];
}

@end



