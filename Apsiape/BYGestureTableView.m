//
//  BYGestureTableView.m
//  Apsiape
//
//  Created by Dario Lass on 19.10.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYGestureTableView.h"
#import "BYTableViewCell.h"

@interface BYGestureTableView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, strong) BYTableViewCell *panningCell;
@property (nonatomic, readwrite) CGFloat lastPanOffset;

- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer;
- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;
- (UITableViewCell*)cellForLocationInTableView:(CGPoint)location;

@end

@implementation BYGestureTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (!self.panRecognizer) self.panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePanGesture:)];
    if (!self.tapRecognizer) self.tapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    self.panRecognizer.delegate = self;
    self.tapRecognizer.delegate = self;
    [self addGestureRecognizer:self.panRecognizer];
    [self addGestureRecognizer:self.tapRecognizer];
}

-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.panRecognizer) {
        CGPoint translation = [(UIPanGestureRecognizer*)gestureRecognizer translationInView:gestureRecognizer.view];
        return (fabs(translation.x) / fabs(translation.y) > 1) ? YES : NO;
    } else if ([gestureRecognizer isEqual:self.panGestureRecognizer]) {
        return YES;
    } else {
        return YES;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

#define THRESHOLD 80

-(void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (!self.panningCell) self.panningCell = (BYTableViewCell*)[self cellForLocationInTableView:[panGestureRecognizer locationInView:panGestureRecognizer.view]];
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
        CGFloat deltaX;
        if (fabs(self.panningCell.contentView.frame.origin.x) > 80) {
            deltaX = (translation.x - self.lastPanOffset) * .1;
        } else {
            deltaX = (translation.x - self.lastPanOffset) * .8;
        }
        self.lastPanOffset = translation.x;
        self.panningCell.contentView.frame = CGRectOffset(self.panningCell.contentView.frame, deltaX, 0);
    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        if (fabs(CGRectGetMinX(self.panningCell.contentView.frame)) > THRESHOLD && CGRectGetMinX(self.panningCell.contentView.frame) < 0) {
            [self.panningCell moveCellContentForState:BYTableViewCellStateRightSideRevealed animated:YES];
        } else if (fabs(CGRectGetMinX(self.panningCell.contentView.frame)) > THRESHOLD && CGRectGetMinX(self.panningCell.contentView.frame) > 0) {
            [self.panningCell moveCellContentForState:BYTableViewCellStateLeftSideRevealed animated:YES];
        } else {
            [self.panningCell moveCellContentForState:BYTableViewCellStateDefault animated:YES];
        }
        self.lastPanOffset = 0.0f;
        self.panningCell = Nil;
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if ([self.delegate respondsToSelector:@selector(tableView:didRecognizeTapGestureOnCellAtIndexPath:)]) {
        [self.delegate tableView:self didRecognizeTapGestureOnCellAtIndexPath:[self indexPathForCell:[self cellForLocationInTableView:[tapGestureRecognizer locationInView:tapGestureRecognizer.view]]]];
    }
}

- (UITableViewCell *)cellForLocationInTableView:(CGPoint)location
{
    UITableViewCell *cell = nil;
    for (UITableViewCell *visibleCell in self.visibleCells) {
        if (CGRectContainsPoint(visibleCell.frame, location)) {
            cell = visibleCell;
        }
    }
    return cell;
}

@end
