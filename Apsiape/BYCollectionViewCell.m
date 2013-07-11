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
#import "InterfaceDefinitions.h"

#pragma mark ––– UICollectionViewCellContentView implementation

@interface BYCollectionViewCell () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *foregroundImageView;
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, readwrite) BOOL panIsElastic;
@property (nonatomic, readwrite) CGFloat panElasticityStartingPoint;
@property (nonatomic, readwrite) CGFloat lastOffset;
@property (nonatomic, strong) CALayer *borderLayer;

- (void)handlePanGesture:(UIPanGestureRecognizer*)panGestureRecognizer;
- (void)animateCellContentForState:(BYCollectionViewCellState)state;

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
        self.label.font = [UIFont fontWithName:@"Miso" size:44];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        self.imageView.layer.masksToBounds = YES;
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.foregroundImageView];
        [self.contentView addSubview:self.label];
        self.backgroundColor = COLOR_ALERT_RED;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        self.panRecognizer.delegate = self;
        [self addGestureRecognizer:self.panRecognizer];
        
        self.panIsElastic = YES;
        self.panElasticityStartingPoint = 80;
        
        self.borderLayer = [CALayer layer];
        self.borderLayer.borderWidth = 0.25;
        self.borderLayer.borderColor = [UIColor grayColor].CGColor;
        [self.contentView.layer addSublayer:self.borderLayer];
    }
    return self;
}

//determine wether the pan is horizontal or not
-(BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer
{
    if ([panGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        CGPoint translation = [panGestureRecognizer translationInView:[self superview]];
        return (fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO;
    } else {
        return NO;
    }
}

#define THRESHOLD 80

-(void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
        CGFloat deltaX;
        if (fabs(self.contentView.frame.origin.x) > 80) {
            deltaX = (translation.x - self.lastOffset) * .05;
        } else {
            deltaX = (translation.x - self.lastOffset) * .8;
        }
        self.lastOffset = translation.x;
        self.contentView.frame = CGRectOffset(self.contentView.frame, deltaX, 0);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (fabs(CGRectGetMinX(self.contentView.frame)) > THRESHOLD && CGRectGetMinX(self.contentView.frame) < 0) {
            [self animateCellContentForState:BYCollectionViewCellStateRightSideRevealed];
        } else if (fabs(CGRectGetMinX(self.contentView.frame)) > THRESHOLD && CGRectGetMinX(self.contentView.frame) > 0) {
            [self animateCellContentForState:BYCollectionViewCellStateLeftSideRevealed];
        } else {
            [self animateCellContentForState:BYCollectionViewCellStateDefault];
        }
        self.lastOffset = 0.0f;
    }
}

- (void)animateCellContentForState:(BYCollectionViewCellState)state
{
    void (^delegateCall) (BOOL) = ^(BOOL finished) {
        [self.delegate cell:self didEnterStateWithAnimation:state];
    };
    
    if (state == BYCollectionViewCellStateDefault) {
        [UIView animateWithDuration:0.2 animations:^{
                self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
        } completion:delegateCall];
    } else if (state == BYCollectionViewCellStateLeftSideRevealed) {
        [UIView animateWithDuration:0.2 animations:^{
                self.contentView.frame = CGRectMake(THRESHOLD, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
            } completion:delegateCall];
    } else if (state == BYCollectionViewCellStateRightSideRevealed) {
        [UIView animateWithDuration:0.2 animations:^{
                self.contentView.frame = CGRectMake(- THRESHOLD, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
            } completion:delegateCall];
    }
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.label.text = _title;
}
- (void)didMoveToSuperview
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
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
- (void)layoutSubviews
{    
    [self prepareLayout];
}
- (void)prepareLayout
{
    if (self.cellState == BYCollectionViewCellStateRightSideRevealed) {
        self.contentView.frame = CGRectMake(- THRESHOLD, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } else if (self.cellState == BYCollectionViewCellStateLeftSideRevealed) {
        self.contentView.frame = CGRectMake(THRESHOLD, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } else {
        self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    }
    [super layoutSubviews];
    CGRect rect = self.contentView.bounds;
    rect.size.height = self.contentView.bounds.size.height/1.5f;
    rect.origin.x = self.frame.size.height;
    self.label.frame = CGRectInset(rect, 10, 10);
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    self.imageView.frame = CGRectInset(self.imageView.frame, 5, 5);
    self.imageView.layer.cornerRadius = (self.imageView.frame.size.height/6);
    self.borderLayer.frame = self.contentView.bounds;
}

@end



