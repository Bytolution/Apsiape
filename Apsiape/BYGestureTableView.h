//
//  BYGestureTableView.h
//  Apsiape
//
//  Created by Dario Lass on 19.10.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYTableViewCell.h"

@protocol BYGestureTableViewDelegate <UITableViewDelegate>

@optional

- (void)tableView:(UITableView *)tableView willAnimateCellAfterSwipeAtIndexPath:(NSIndexPath*)indexPath toState:(BYTableViewCellState)cellState;
- (void)tableView:(UITableView *)tableView didRecognizeTapGestureOnCellAtIndexPath:(NSIndexPath*)indexPath;

@end

@interface BYGestureTableView : UITableView

@property (nonatomic, weak) id <BYGestureTableViewDelegate> delegate;

@end
