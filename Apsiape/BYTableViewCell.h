//
//  BYTableViewCell.h
//  Apsiape
//
//  Created by Dario Lass on 16.09.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

#define CELL_HEIGHT 70

#define TOP_SPACE 0

#define CELL_INSET_X 0
#define CELL_ADD_INSET_X 5
#define CELL_INSET_Y 0

typedef enum {
    BYTableViewCellStateDefault,
    BYTableViewCellStateLeftSideRevealed,
    BYTableViewCellStateRightSideRevealed
}BYTableViewCellState;

@class Expense;

@interface BYTableViewCell : UITableViewCell

@property (nonatomic, readwrite) BYTableViewCellState cellState;

@property (nonatomic, strong) id <UITableViewDelegate> parentTableViewDelegate;

@property (nonatomic, strong) UIImageView *thumbnailView;
@property (nonatomic, strong) UILabel *label;

- (void)prepareForDetailViewWithExpense:(Expense*)expense;
- (void)dismissDetailView;

- (void)moveCellContentForState:(BYTableViewCellState)state animated:(BOOL)animated;

- (void)changeIndicatorForCellState:(BYTableViewCellState)state;

@end
