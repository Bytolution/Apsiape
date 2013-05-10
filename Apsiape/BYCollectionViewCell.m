//
//  BYCollectionViewCell.m
//  Apsiape
//
//  Created by Dario Lass on 04.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYCollectionViewCell.h"
#import "Expense.h"

#pragma mark ––– UICollectionViewCellContentView implementation

@interface BYCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic) BOOL locationTagActive;
@property (nonatomic) CGRect containerFrame;
@property (nonatomic) CGRect contentFrame;
@property (nonatomic) NSInteger index;


@end

@implementation BYCollectionViewCell

- (CGRect)containerFrame {
    return self.bounds;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    if (!self.containerView) self.containerView = [[UIView alloc]initWithFrame:self.containerFrame];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.containerFrame.size.width, self.containerFrame.size.height/2.5)];
    self.titleLabel.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    self.titleLabel.text = self.title;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:20];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.containerView.clipsToBounds = YES;
    
    if (!self.imageView) self.imageView = [[UIImageView alloc]initWithImage:self.image];
    self.imageView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.width);
    self.imageView.center = self.containerView.center;
    
    [self.containerView insertSubview:self.imageView belowSubview:self.titleLabel];
    [self.containerView addSubview:self.titleLabel];
    self.containerView.backgroundColor = [UIColor colorWithWhite:1 alpha: .8];
    [self addSubview:self.containerView];
}

@end





