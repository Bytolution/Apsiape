//
//  BYTableViewCell.m
//  Apsiape
//
//  Created by Dario Lass on 16.09.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYTableViewCell.h"
#import <QuartzCore/QuartzCore.h>
#import "BYDetailScrollView.h"

@interface BYTableViewCell () <UIGestureRecognizerDelegate, UITableViewDelegate>

@property (nonatomic, readwrite) CGFloat lastOffset;
@property (nonatomic, strong) UIButton *rightSideActionButton;
@property (nonatomic, strong) UIView *headerView;


@property (nonatomic, strong) BYDetailScrollView *detailScrollView;

@end

@implementation BYTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        if (!self.label) self.label = [[UILabel alloc]init];
        if (!self.thumbnailView) self.thumbnailView = [[UIImageView alloc]init];
        if (!self.detailScrollView) self.detailScrollView = [[BYDetailScrollView alloc]init];
        if (!self.headerView) self.headerView = [[UIView alloc]init];
        [self.contentView addSubview:self.detailScrollView];
        [self.contentView addSubview:self.headerView];
        [self.headerView addSubview:self.label];
        [self.headerView addSubview:self.thumbnailView];
        
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.headerView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
        
        self.rightSideActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightSideActionButton.backgroundColor = [UIColor clearColor];
        [self.rightSideActionButton setTitle:@"" forState:UIControlStateNormal];
        [self.rightSideActionButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self.backgroundView insertSubview:self.rightSideActionButton atIndex:0];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    return self;
}

#define THRESHOLD 80

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CELL_HEIGHT);
    
    self.thumbnailView.frame = CGRectMake(10, 10, 80 , 80);
    self.thumbnailView.layer.cornerRadius = CGRectGetHeight(self.thumbnailView.frame)/2;
    self.thumbnailView.clipsToBounds = YES;
    
    self.label.frame = CGRectMake(CGRectGetWidth(self.thumbnailView.frame) + 20, 0, CGRectGetWidth(self.frame) - (CGRectGetWidth(self.thumbnailView.frame)+ 30), CELL_HEIGHT);
    self.label.font = [UIFont fontWithName:@"Miso" size:40];
    self.label.textAlignment = NSTextAlignmentRight;
    
    self.detailScrollView.frame = self.bounds;
    self.detailScrollView.contentInset = UIEdgeInsetsMake(CELL_HEIGHT, 0, 0, 0);
    self.detailScrollView.contentOffset = CGPointMake(0, - CELL_HEIGHT);
    
    if (self.cellState == BYTableViewCellStateRightSideRevealed) {
        self.contentView.frame = CGRectOffset(self.contentView.frame, - THRESHOLD, 0);
    }
}

- (void)moveCellContentForState:(BYTableViewCellState)state animated:(BOOL)animated
{
    void (^delegateCall) (BOOL) = ^(BOOL finished) {
//        if ([self.delegate respondsToSelector:@selector(cell:didEnterStateWithAnimation:)]) [self.delegate cell:self didEnterStateWithAnimation:state];
    };
    
    CGFloat duration = 0.0;
    
    if (animated) duration = 0.2;
    
    if (state == BYTableViewCellStateDefault) {
        [UIView animateWithDuration:duration animations:^{
            self.contentView.frame = CGRectMake(CELL_INSET_Y, CELL_INSET_Y, self.contentView.frame.size.width, self.contentView.frame.size.height);
        } completion:delegateCall];
    } else if (state == BYTableViewCellStateLeftSideRevealed) {
        [UIView animateWithDuration:duration animations:^{
            self.contentView.frame = CGRectMake(THRESHOLD, CELL_INSET_Y, self.contentView.frame.size.width, self.contentView.frame.size.height);
        } completion:delegateCall];
    } else if (state == BYTableViewCellStateRightSideRevealed) {
        [UIView animateWithDuration:duration animations:^{
            self.contentView.frame = CGRectMake(- THRESHOLD, CELL_INSET_Y, self.contentView.frame.size.width, self.contentView.frame.size.height);
        } completion:delegateCall];
    }
}

#pragma mark - Resizing

- (void)prepareForDetailViewWithExpense:(Expense *)expense
{
    self.detailScrollView.expense = expense;
}

- (void)dismissDetailView
{
    self.detailScrollView.expense = nil;
}


@end
