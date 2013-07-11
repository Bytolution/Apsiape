//
//  BYCollectionViewCell.h
//  Apsiape
//
//  Created by Dario Lass on 04.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYCollectionViewCell.h"

@class BYCollectionViewCell;

typedef enum {
    BYCollectionViewCellStateDefault,
    BYCollectionViewCellStateLeftSideRevealed,
    BYCollectionViewCellStateRightSideRevealed
}BYCollectionViewCellState;

@protocol BYCollectionViewCellDelegate <NSObject>

- (void)cell:(BYCollectionViewCell*)cell didEnterStateWithAnimation:(BYCollectionViewCellState)state;

@end

@interface BYCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, readwrite) BYCollectionViewCellState cellState;
@property (nonatomic, strong) id <BYCollectionViewCellDelegate> delegate;

- (void)prepareLayout;

@end
