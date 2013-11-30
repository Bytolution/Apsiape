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
        self.backgroundColor = [UIColor clearColor];
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
    return YES;
}

#define THRESHOLD 80

-(void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
    if (!self.panningCell) self.panningCell = (BYTableViewCell*)[self cellForLocationInTableView:[panGestureRecognizer locationInView:panGestureRecognizer.view]];
    if (self.panningCell) {
        if (panGestureRecognizer.state == UIGestureRecognizerStateBegan || panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
            CGFloat deltaX;
            if (fabs(self.panningCell.contentView.frame.origin.x) > 80) {
                deltaX = (translation.x - self.lastPanOffset) * .2;
                [self.panningCell changeIndicatorForCellState:BYTableViewCellStateRightSideRevealed];
            } else {
                deltaX = (translation.x - self.lastPanOffset) * .8;
                [self.panningCell changeIndicatorForCellState:BYTableViewCellStateDefault];
            }
            self.lastPanOffset = translation.x;
            
            self.panningCell.contentView.frame = CGRectOffset(self.panningCell.contentView.frame, deltaX, 0);
            
        } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded || panGestureRecognizer.state == UIGestureRecognizerStateCancelled || panGestureRecognizer.state == UIGestureRecognizerStateFailed) {
            if (fabs(CGRectGetMinX(self.panningCell.contentView.frame)) > THRESHOLD && CGRectGetMinX(self.panningCell.contentView.frame) < 0) {
                [self.panningCell moveCellContentForState:BYTableViewCellStateRightSideRevealed animated:YES];
                [self.delegate tableView:self willAnimateCellAfterSwipeAtIndexPath:[self indexPathForCell:self.panningCell] toState:BYTableViewCellStateRightSideRevealed];
            } else if (fabs(CGRectGetMinX(self.panningCell.contentView.frame)) > THRESHOLD && CGRectGetMinX(self.panningCell.contentView.frame) > 0) {
                // this disables the ability to select the other state
    //            [self.panningCell moveCellContentForState:BYTableViewCellStateLeftSideRevealed animated:YES];
    //            [self.delegate tableView:self willAnimateCellAfterSwipeAtIndexPath:[self indexPathForCell:self.panningCell] toState:BYTableViewCellStateLeftSideRevealed];
                [self.panningCell moveCellContentForState:BYTableViewCellStateDefault animated:YES];
                [self.delegate tableView:self willAnimateCellAfterSwipeAtIndexPath:[self indexPathForCell:self.panningCell] toState:BYTableViewCellStateDefault];
            } else {
                [self.panningCell moveCellContentForState:BYTableViewCellStateDefault animated:YES];
                [self.delegate tableView:self willAnimateCellAfterSwipeAtIndexPath:[self indexPathForCell:self.panningCell] toState:BYTableViewCellStateDefault];
            }
            self.lastPanOffset = 0.0f;
            self.panningCell = Nil;
        }
    }
}

- (void)handleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer
{
    BYTableViewCell *cell = (BYTableViewCell*)[self cellForLocationInTableView:[tapGestureRecognizer locationInView:tapGestureRecognizer.view]];
    if (cell) {
        if ([self.delegate respondsToSelector:@selector(tableView:didRecognizeTapGestureOnCellAtIndexPath:)]) {
            [self.delegate tableView:self didRecognizeTapGestureOnCellAtIndexPath:[self indexPathForCell:cell]];
        }
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
