//
//  BYCollectionView.h
//  Apsiape
//
//  Created by Dario Lass on 16.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYCollectionView, BYCollectionViewCell;

@protocol BYCollectionViewDataSource <NSObject>

- (BYCollectionViewCell*)collectionView:(BYCollectionView*)collectionView cellAtIndex:(NSInteger)index;
- (NSInteger)numberOfCellsInCollectionView;
- (CGFloat)heightForCellsInCollectionView;

@end

@interface BYCollectionView : UIScrollView 

@property (nonatomic, strong) id <BYCollectionViewDataSource> dataSource;

- (void)loadCollectionView;
- (CGRect)frameForCellAtIndex:(NSInteger)index;

@end
