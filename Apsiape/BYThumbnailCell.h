//
//  BYThumbnailCell.h
//  Apsiape
//
//  Created by Dario Lass on 04.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYThumbnailCell.h"

@class BYThumbnailCell;

typedef enum {
    BYThumbnailCellStateDefault,
    BYThumbnailCellStateLeftSideRevealed,
    BYThumbnailCellStateRightSideRevealed
}BYThumbnailCellState;

@protocol BYThumbnailCellDelegate <NSObject>

- (void)cell:(BYThumbnailCell*)cell didEnterStateWithAnimation:(BYThumbnailCellState)state;
- (void)cellDidRecieveAction:(BYThumbnailCell*)cell;

@end

@interface BYThumbnailCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, readwrite) BYThumbnailCellState cellState;
@property (nonatomic, strong) id <BYThumbnailCellDelegate> delegate;
@property (nonatomic, strong) NSIndexPath *indexPathForLayout;

- (void)prepareLayout;

@end