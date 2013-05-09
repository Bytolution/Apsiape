//
//  BYCollectionView.h
//  Apsiape
//
//  Created by Dario Lass on 16.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYCollectionViewCell.h"


@class BYCollectionView, BYCollectionViewCell;

@protocol BYCollectionViewDataSource <NSObject>

- (BYCollectionViewCell*)collectionView:(BYCollectionView*)collectionView cellAtIndex:(NSInteger)index;
- (NSInteger)numberOfCellsInCollectionView;
- (CGFloat)heightForCellsInCollectionView;

@end

@protocol BYCollectionViewDelegate <NSObject>

- (void)collectionView:(BYCollectionView*)collectionView cellDidDetectedTapGesture:(BYCollectionViewCell*)cell atIndex:(NSInteger)index;

@end

@interface BYCollectionView : UIScrollView <BYCollectionViewCellDelegate>

@property (nonatomic, strong) id <BYCollectionViewDataSource> collectionViewDataSource;
@property (nonatomic, strong) id <BYCollectionViewDelegate> collectionViewDelegate;

- (void)loadCollectionView;
- (CGRect)frameForCellAtIndex:(NSInteger)index;

- (void)reloadContentSize;

@end
