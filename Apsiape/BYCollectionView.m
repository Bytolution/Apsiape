//
//  BYCollectionView.m
//  Apsiape
//
//  Created by Dario Lass on 16.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYCollectionView.h"
#import "InterfaceConstants.h"
#import "BYExpenseViewController.h"
#import "BYContainerViewController.h"
#import "BYStorage.h"

@interface BYCollectionView ()

@end

@implementation BYCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
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
    //add CELL_CONTENT_INSET because otherwise our little tweak to align the cells will be visible
    self.contentSize = CGSizeMake(self.bounds.size.width, ([self.collectionViewDataSource numberOfCellsInCollectionView]/2) * [self.collectionViewDataSource heightForCellsInCollectionView] + CELL_CONTENT_INSET);
    if (self.contentSize.height < self.bounds.size.height) self.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height + CELL_CONTENT_INSET +1);
    //
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
    for (int i = 0; i < [self.collectionViewDataSource numberOfCellsInCollectionView]; i++) {
        BYCollectionViewCell *cell = [self.collectionViewDataSource collectionView:self cellAtIndex:i];
        cell.delegate = self;
        [self addSubview:cell];
    }
}

@end
