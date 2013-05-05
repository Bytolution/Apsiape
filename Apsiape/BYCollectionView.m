//
//  BYCollectionView.m
//  Apsiape
//
//  Created by Dario Lass on 16.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYCollectionView.h"
#import "BYExpenseViewController.h"
#import "BYContainerViewController.h"
#import "BYStorage.h"

@implementation BYCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (CGRect)frameForCellAtIndex:(NSInteger)index {
    CGRect rect;
    if (index % 2) {
        rect = CGRectMake(self.contentSize.width/2, [self.collectionViewDataSource heightForCellsInCollectionView] * (index/2), self.contentSize.width/2, [self.collectionViewDataSource heightForCellsInCollectionView]);
    } else {
        rect = CGRectMake(0, [self.collectionViewDataSource heightForCellsInCollectionView] * (index/2), self.contentSize.width/2, [self.collectionViewDataSource heightForCellsInCollectionView]);
    }
    return rect;
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self loadCollectionView];
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawPath(context, kCGPathFillStroke);
}

- (void)cellDidDetectTapGesture:(BYCollectionViewCell *)cell withCellIndex:(NSInteger)index {
    [self.collectionViewDelegate collectionView:self cellDidDetectedTapGesture:cell atIndex:index];
    
}

- (void)loadCollectionView
{    
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
    for (int i = 0; i < [self.collectionViewDataSource numberOfCellsInCollectionView]; i++) {
        BYCollectionViewCell *cell = [self.collectionViewDataSource collectionView:self cellAtIndex:i];
        cell.delegate = self;
        [self addSubview:cell];
    }
    
    // because with a changing number of items the contentSize also changes
    float numberOfCells = [self.collectionViewDataSource numberOfCellsInCollectionView];
    float heightOfCells = [self.collectionViewDataSource heightForCellsInCollectionView];
    self.contentSize = CGSizeMake(self.bounds.size.width,  (roundf((numberOfCells/2.0f)) * heightOfCells)  + CELL_CONTENT_INSET);
}

@end
