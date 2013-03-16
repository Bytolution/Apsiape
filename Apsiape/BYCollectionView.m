//
//  BYCollectionView.m
//  Apsiape
//
//  Created by Dario Lass on 16.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYCollectionView.h"
#import "BYCollectionViewCell.h"
#import "InterfaceConstants.h"


@interface BYCollectionView ()

@end

@implementation BYCollectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (CGRect)frameForCellAtIndex:(NSInteger)index {
    CGRect rect;
    if (index % 2) {
        rect = CGRectMake(self.contentSize.width/2, [self.dataSource heightForCellsInCollectionView] * (index/2), self.contentSize.width/2, [self.dataSource heightForCellsInCollectionView]);
    } else {
        rect = CGRectMake(0, [self.dataSource heightForCellsInCollectionView] * (index/2), self.contentSize.width/2, [self.dataSource heightForCellsInCollectionView]);
    }
    return rect;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    self.contentSize = CGSizeMake(self.bounds.size.width, ([self.dataSource numberOfCellsInCollectionView]/2) * [self.dataSource heightForCellsInCollectionView]);
    if (self.contentSize.height < self.bounds.size.height) self.contentSize = CGSizeMake(self.bounds.size.width, self.bounds.size.height+1);
    [self loadCollectionView];
}

- (void)loadCollectionView
{
    for (int i = 0; i < [self.dataSource numberOfCellsInCollectionView]; i++) {
        BYCollectionViewCell *cell = [self.dataSource collectionView:self cellAtIndex:i];
        [self addSubview:cell];
    }
}

@end
