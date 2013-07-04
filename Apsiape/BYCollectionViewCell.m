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

@interface BYCollectionViewCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *foregroundImageView;

//- (void)gestureRecognized:(UISwipeGestureRecognizer*)gRecognizer;

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
        
//        UISwipeGestureRecognizer *sgr = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(gestureRecognized:)];
//        [self.contentView addGestureRecognizer:sgr];
        
        self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    }
    return self;
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

- (void)didMoveToSuperview
{
    CGRect rect = self.contentView.bounds;
    rect.size.height = self.contentView.bounds.size.height/2;
    rect.origin.x = self.frame.size.height;
    self.label.frame = CGRectInset(rect, 10, 10);
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    self.foregroundImageView.frame = self.contentView.bounds;
    
    CALayer *borderLayer = [CALayer layer];
    borderLayer.borderColor = [UIColor blackColor].CGColor;
    borderLayer.borderWidth = 0.5;
    borderLayer.frame = self.bounds;
    [self.contentView.layer addSublayer:borderLayer];
}

@end



