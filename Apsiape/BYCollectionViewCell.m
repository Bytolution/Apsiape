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
@property (nonatomic, strong) UIButton *rightSideActionButton;
@property (nonatomic, strong) UILabel *subtitleLabel;

- (void)handlePanGesture:(UIPanGestureRecognizer*)panGestureRecognizer;
- (void)animateCellContentForState:(BYCollectionViewCellState)state;
- (void)buttonTapped:(UIButton*)sender;

@end

@implementation BYCollectionViewCell


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc]initWithFrame:CGRectZero];
        self.label.textAlignment = NSTextAlignmentRight;
        self.label.backgroundColor = [UIColor clearColor];
        self.label.textColor = [UIColor colorWithRed:0.1 green:0.3 blue:0.7 alpha:1];
        self.label.font = [UIFont fontWithName:@"Miso-Light" size:46];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageView.backgroundColor = [UIColor colorWithWhite:0.85 alpha:1];
        self.imageView.layer.masksToBounds = YES;
        
        self.rightSideActionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.rightSideActionButton.backgroundColor = [UIColor clearColor];
        [self.rightSideActionButton setTitle:@"Del" forState:UIControlStateNormal];
        [self.rightSideActionButton addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
        
        self.backgroundView = [[UIView alloc]initWithFrame:self.bounds];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.foregroundImageView];
        [self.contentView addSubview:self.label];
        [self.backgroundView addSubview:self.rightSideActionButton];
        self.backgroundColor = COLOR_ALERT_RED;
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
        self.panRecognizer.delegate = self;
        [self addGestureRecognizer:self.panRecognizer];
        
        self.panIsElastic = YES;
        self.panElasticityStartingPoint = 80;
        
        CALayer *lightBorder = [CALayer layer];
        lightBorder.frame = self.bounds;
        lightBorder.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        lightBorder.borderWidth = 1;
        [self.layer addSublayer:lightBorder];
        
        self.borderLayer = [CALayer layer];
        self.borderLayer.borderWidth = 10;
        self.borderLayer.borderColor = [UIColor colorWithWhite:0.8 alpha:1].CGColor;
        [self.layer addSublayer:self.borderLayer];
        
        self.subtitleLabel = [[UILabel alloc]init];
        self.subtitleLabel.text = @"Create new";
        self.subtitleLabel.textColor = [UIColor darkGrayColor];
        self.subtitleLabel.backgroundColor = [UIColor clearColor];
        self.subtitleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:14];
        self.subtitleLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:self.subtitleLabel];
        
        self.layer.masksToBounds = YES;
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

- (void)buttonTapped:(UIButton *)sender
{
    [self.delegate cellDidRecieveAction:self];
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
- (void)setSubtitle:(NSString *)subtitle
{
    _subtitle = subtitle;
    self.subtitleLabel.text = _subtitle;
}

- (void)prepareLayout
{
    [super layoutSubviews];
    if (self.cellState == BYCollectionViewCellStateRightSideRevealed) {
        self.contentView.frame = CGRectMake(- THRESHOLD, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } else if (self.cellState == BYCollectionViewCellStateLeftSideRevealed) {
        self.contentView.frame = CGRectMake(THRESHOLD, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    } else {
        self.contentView.frame = CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height);
    }
    CGRect rect = self.contentView.bounds;
    rect.size.height = self.contentView.bounds.size.height;
    rect.origin.x = self.frame.size.height;
    rect.size.width -= self.frame.size.height;
    rect.size.height -= 20;
    self.label.frame = CGRectInset(rect, 15, 15);
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    self.imageView.frame = CGRectInset(self.imageView.frame, CELL_IMAGE_PADDING, CELL_IMAGE_PADDING);
    self.imageView.layer.cornerRadius = 4;
    self.borderLayer.frame = CGRectMake(0, self.contentView.frame.size.height - 1, self.contentView.frame.size.width, 1);
    rect.size.height = 20;
    rect.origin.y = 70;
    rect.size.width -= 10;
    self.subtitleLabel.frame = rect;
    self.rightSideActionButton.frame = CGRectMake(self.frame.size.width - THRESHOLD, 0, THRESHOLD, self.frame.size.height);
}

@end

