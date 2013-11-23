//
//  BYCollectionViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import "BYCollectionViewController.h"
#import "BYStorage.h"
#import "Expense.h"
#import "BYTableViewCell.h"
#import "BYDetailViewController.h"
#import "BYGestureTableView.h"

@interface BYCollectionViewController () <UIScrollViewDelegate, UIViewControllerTransitioningDelegate, UITableViewDataSource, BYGestureTableViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *tableViewData;
@property (nonatomic, strong) BYGestureTableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellStates;
@property (nonatomic, strong) UILabel *pullControlLabel;
@property (nonatomic, strong) NSIndexPath *expandedCellIndexPath;
@property (nonatomic, readwrite) CGFloat tableViewCellHeight;
@property (nonatomic, readwrite) CGPoint preAnimationOffset;
@property (nonatomic, readwrite) BOOL scrollViewOffsetExceedsPullThreshold;
@property (nonatomic, readwrite) BOOL pullControlLabelTextChangeAnimationInProgress;
@property (nonatomic, readwrite) BOOL draggingEndedWithExceededPullThreshold;

- (void)updateTableViewData;

@end

@implementation BYCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Overview";
        if (!self.tableViewData) self.tableViewData = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableViewData) name:@"BYStorageContentChangedNotification" object:nil];
        if (!self.tableView) self.tableView = [[BYGestureTableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.contentInset = UIEdgeInsetsMake(CELL_INSET_Y, 0, CELL_INSET_Y, 0);
        self.tableView.separatorColor = [UIColor darkGrayColor];
        self.tableView.separatorInset = UIEdgeInsetsMake(0, CELL_SEPERATOR_INSET, 0, CELL_SEPERATOR_INSET);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundView = [[UIView alloc]init];
        [self.view addSubview:self.tableView];
        self.view.backgroundColor = [UIColor clearColor];
        self.tableView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)updateTableViewData
{
    [self.tableViewData removeAllObjects];
    NSFetchRequest *fetchR = [NSFetchRequest fetchRequestWithEntityName:@"Expense"];
    NSManagedObjectContext *context = [[BYStorage sharedStorage] managedObjectContext];
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
    fetchR.sortDescriptors = @[sortDescriptor];
    self.tableViewData = [[context executeFetchRequest:fetchR error:&error] mutableCopy];
    if (!self.cellStates) self.cellStates = [[NSMutableArray alloc]init];
    [self.cellStates removeAllObjects];
    for (int i = 0; i < self.tableViewData.count; i++) {
        [self.cellStates addObject:[NSNumber numberWithInt:BYTableViewCellStateDefault]];
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateTableViewData];
    
    self.tableView.frame = self.view.bounds;
    
    self.navigationController.navigationBarHidden = YES;
    
    // Gradient layer background
//    CAGradientLayer *gradLayer = [CAGradientLayer layer];
//    gradLayer.colors = @[(id)[UIColor colorWithWhite:0.85 alpha:1].CGColor, (id)[UIColor darkGrayColor].CGColor];
//    gradLayer.frame = self.tableView.backgroundView.bounds;
//    gradLayer.startPoint = CGPointMake(0, 0);
//    gradLayer.endPoint = CGPointMake(0, 1);
//    [self.tableView.backgroundView.layer addSublayer:gradLayer];
}


#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableViewData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return CELL_HEIGHT;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BYTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CELL_ID"];
    if (!cell) {
        cell = [[BYTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CELL_ID"];
    }
    Expense *expense = self.tableViewData[indexPath.row];
    cell.label.text = expense.stringValue;
//    cell.thumbnailView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@thumb.jpg", expense.baseFilePath]]];
    cell.cellState = [self.cellStates[indexPath.row]intValue];
    
    return cell;
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.draggingEndedWithExceededPullThreshold) {
        self.draggingEndedWithExceededPullThreshold = NO;
        [[NSNotificationCenter defaultCenter] postNotificationName:BYNavigationControllerShouldDisplayExpenseCreationVCNotificationName object:nil];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollViewOffsetExceedsPullThreshold) {
        self.draggingEndedWithExceededPullThreshold = YES;
    }
    if (!decelerate) {

    }
}

- (void)setScrollViewOffsetExceedsPullThreshold:(BOOL)scrollViewOffsetExceedsPullThreshold
{
    _scrollViewOffsetExceedsPullThreshold = scrollViewOffsetExceedsPullThreshold;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < - 130 && !self.scrollViewOffsetExceedsPullThreshold) {
        self.scrollViewOffsetExceedsPullThreshold = YES;
    } else if (scrollView.contentOffset.y > - 130 && self.scrollViewOffsetExceedsPullThreshold) {
        self.scrollViewOffsetExceedsPullThreshold = NO;
    }
    
    if (self.scrollViewOffsetExceedsPullThreshold && [self.pullControlLabel.text isEqualToString:@"Create new"] && !self.pullControlLabelTextChangeAnimationInProgress) {
        [UIView animateWithDuration:0.1 animations:^{
            self.pullControlLabel.alpha = 0;
            self.pullControlLabelTextChangeAnimationInProgress = YES;
        } completion:^(BOOL finished) {
            self.pullControlLabel.text = @"Release";
            [UIView animateWithDuration:0.1 animations:^{
                self.pullControlLabel.alpha = 1;
            } completion:^(BOOL finished) {
                self.pullControlLabelTextChangeAnimationInProgress = NO;
            }];
        }];
    } else if (!self.scrollViewOffsetExceedsPullThreshold && [self.pullControlLabel.text isEqualToString:@"Release"] && !self.pullControlLabelTextChangeAnimationInProgress) {
        [UIView animateWithDuration:0.1 animations:^{
            self.pullControlLabel.alpha = 0;
            self.pullControlLabelTextChangeAnimationInProgress = YES;
        } completion:^(BOOL finished) {
            self.pullControlLabel.text = @"Create new";
            [UIView animateWithDuration:0.1 animations:^{
                self.pullControlLabel.alpha = 1;
            } completion:^(BOOL finished) {
                self.pullControlLabelTextChangeAnimationInProgress = NO;
            }];
        }];
    }   
}

#pragma mark BYGestureTableView Delegate handling

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    BYDetailViewController *detailVC = [[BYDetailViewController alloc]initWithNibName:nil bundle:nil];
    detailVC.expense = self.tableViewData[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willAnimateCellAfterSwipeAtIndexPath:(NSIndexPath *)indexPath toState:(BYTableViewCellState)cellState
{
    [self.cellStates replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:cellState]];
}

//FIXME: Change method name
- (void)cellDidRecieveAction:(BYTableViewCell *)cell
{
    NSMutableIndexSet *deletionIndexSet = [[NSMutableIndexSet alloc]init];
    NSMutableArray *deletionIndexesForCollectionView = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.cellStates.count; i++) {
        if ([self.cellStates[i] isEqual:[NSNumber numberWithInt:BYTableViewCellStateRightSideRevealed]]) {
            Expense *expense = self.tableViewData[i];
            //FIXME: deletion must happen in bunches
            [[BYStorage sharedStorage] deleteExpenseObject:expense completion:nil];
            [deletionIndexSet addIndex:i];
            [deletionIndexesForCollectionView addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
    }
    [self.tableViewData removeObjectsAtIndexes:deletionIndexSet];
    [self.cellStates removeObjectsAtIndexes:deletionIndexSet];
    [self.tableView deleteRowsAtIndexPaths:deletionIndexesForCollectionView withRowAnimation:UITableViewRowAnimationLeft];
}

@end
