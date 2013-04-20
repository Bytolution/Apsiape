//
//  BYCollectionViewCell.m
//  Apsiape
//
//  Created by Dario Lass on 04.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYCollectionViewCell.h"
#import "Expense.h"
#import "InterfaceConstants.h"

#pragma mark ––– UICollectionViewCellContentView implementation

@interface BYCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic) BOOL locationTagActive;
@property (nonatomic) CGRect containerFrame;
@property (nonatomic) CGRect contentFrame;
@property (nonatomic) NSInteger index;

- (void)tapDetected;

@end

@implementation BYCollectionViewCell

- (CGRect)containerFrame {
    CGRect rect = CGRectMake(CELL_CONTENT_INSET, CELL_CONTENT_INSET, self.bounds.size.width - (2 * CELL_CONTENT_INSET), self.bounds.size.height - (2 * CELL_CONTENT_INSET));
    if (self.index % 2) {
        rect.origin.y += CELL_CONTENT_INSET/2;
        rect.size.width -= CELL_CONTENT_INSET/2;
        
    } else {
        // even
        rect.origin.x += CELL_CONTENT_INSET/2;
        rect.origin.y += CELL_CONTENT_INSET/2;
        rect.size.width -= CELL_CONTENT_INSET/2;
    }
    return rect;
}

- (id)initWithFrame:(CGRect)frame index:(NSInteger)index {
    self = [super initWithFrame:frame];
    if (self)
    {
        self.index = index;
        self.backgroundColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapDetected)];
        [self addGestureRecognizer:tgr];
    }
    return self;
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
    
    if (!self.imageView) self.imageView = [[UIImageView alloc]initWithImage:self.image];
    self.imageView.frame = self.containerView.bounds;
    
    [self.containerView insertSubview:self.imageView belowSubview:self.titleLabel];
    [self.containerView addSubview:self.titleLabel];
    self.containerView.backgroundColor = [UIColor colorWithWhite:1 alpha: .8];
    [self addSubview:self.containerView];
}

- (void)tapDetected {
    [self.delegate cellDidDetectTapGesture:self withCellIndex:self.index];
}

- (void)drawRect:(CGRect)rect
{
    CGFloat borderWidth = 1;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // this draws the rectangle on the outside of our content area. else it would be drawn half inside and half outside the path 
    CGContextAddRect(context, CGRectMake(self.containerFrame.origin.x - (borderWidth/2), self.containerFrame.origin.y - (borderWidth/2), self.containerFrame.size.width + borderWidth, self.containerFrame.size.height + borderWidth));
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 3, [[UIColor blackColor] CGColor]);
    [[UIColor blackColor] setStroke];
    CGContextSetLineWidth(context, borderWidth);
    CGContextDrawPath(context, kCGPathStroke);
    [super drawRect:rect];
}

@end





