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
@property (nonatomic, strong) UIImageView *backgroundImageView;

@end

@implementation BYCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc]initWithFrame:CGRectZero];
        self.label.textAlignment = NSTextAlignmentRight;
        self.label.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0];
        self.label.textColor = [UIColor whiteColor];
        self.label.font = [UIFont fontWithName:@"Miso" size:32];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageView.backgroundColor = [UIColor clearColor];
        self.imageView.layer.cornerRadius = 5;
        self.imageView.layer.masksToBounds = YES;
        
        self.foregroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Layout_0000s_0000_Cell-Shape.png"]];
        self.backgroundImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Layout_0000s_0001_Cell-Background.png"]];
        
        [self.contentView addSubview:self.backgroundImageView];
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.foregroundImageView];
        [self.contentView addSubview:self.label];
        
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0];
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
    rect.size.height = self.contentView.bounds.size.height/3;
    self.label.frame = CGRectInset(rect, 6, 0);
    self.imageView.frame = self.contentView.bounds;
    self.foregroundImageView.frame = self.contentView.bounds;
    self.backgroundImageView.frame = self.contentView.bounds;
}

@end





