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
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIImageView *pullIndicatorView;
@property (nonatomic, readwrite) BOOL scrollViewOffsetExceedsPullThreshold;
@property (nonatomic, readwrite) BOOL draggingEndedWithExceededPullThreshold;

- (void)updateTableViewData;
- (void)updateDeleteButtonStateToVisible:(BOOL)visible;
- (void)deleteButtonTapped:(UIButton*)button;

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
        if (!self.deleteButton) self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!self.pullIndicatorView) self.pullIndicatorView = [[UIImageView alloc]init];
        self.deleteButton.backgroundColor = [UIColor colorWithRed:1 green:0.4 blue:0.35 alpha:1];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.contentInset = UIEdgeInsetsMake(CELL_INSET_Y, 0, CELL_INSET_Y, 0);
        self.tableView.separatorColor = [UIColor darkGrayColor];
        self.tableView.separatorInset = UIEdgeInsetsMake(0, CELL_SEPERATOR_INSET, 0, CELL_SEPERATOR_INSET);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.backgroundView = [[UIView alloc]init];
        [self.view addSubview:self.tableView];
        [self.view addSubview:self.deleteButton];
        [self.tableView addSubview:self.pullIndicatorView];
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
    
    self.deleteButton.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 60);
    [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:28];
    [self.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.pullIndicatorView.frame = CGRectMake(0, - PULL_THRESHOLD + 20, 320, PULL_THRESHOLD - 40);
    self.pullIndicatorView.alpha = 0.6;
    self.pullIndicatorView.tintColor = [UIColor whiteColor];
    self.pullIndicatorView.image = [[UIImage imageNamed:@"Apsiape Shapes_04.png"]imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.pullIndicatorView.contentMode = UIViewContentModeScaleAspectFit;
    
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
    cell.thumbnailView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@thumb.jpg", expense.baseFilePath]]];
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
    [UIView animateWithDuration:0.2 animations:^{
        if (_scrollViewOffsetExceedsPullThreshold) {
            self.pullIndicatorView.alpha = 1;
        } else {
            self.pullIndicatorView.alpha = 0.6;
        }
    }];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < - PULL_THRESHOLD && !self.scrollViewOffsetExceedsPullThreshold) {
        self.scrollViewOffsetExceedsPullThreshold = YES;
    } else if (scrollView.contentOffset.y > - PULL_THRESHOLD && self.scrollViewOffsetExceedsPullThreshold) {
        self.scrollViewOffsetExceedsPullThreshold = NO;
    }
}

#pragma mark BYGestureTableView Delegate handling

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)tableView:(UITableView *)tableView willAnimateCellAfterSwipeAtIndexPath:(NSIndexPath *)indexPath toState:(BYTableViewCellState)cellState
{
    if (self.cellStates.count >= indexPath.length) [self.cellStates replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithInt:cellState]];
    
    if ([self.cellStates containsObject:[NSNumber numberWithInt:BYTableViewCellStateRightSideRevealed]]) {
        [self updateDeleteButtonStateToVisible:YES];
    } else {
        [self updateDeleteButtonStateToVisible:NO];
    }
}

- (void)tableView:(UITableView *)tableView didRecognizeTapGestureOnCellAtIndexPath:(NSIndexPath *)indexPath
{
    BYDetailViewController *detailVC = [[BYDetailViewController alloc]initWithNibName:nil bundle:nil];
    detailVC.expense = self.tableViewData[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)updateDeleteButtonStateToVisible:(BOOL)visible
{
    [UIView animateWithDuration:0.2 animations:^{
        if (visible) {
            self.deleteButton.frame = CGRectMake(0, CGRectGetHeight(self.view.frame) - 60, CGRectGetWidth(self.view.frame), 60);
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 60, 0);
        } else {
            self.deleteButton.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), 60);
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        }
    }];
}

//FIXME: Change method name
- (void)deleteButtonTapped:(UIButton *)button
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
    [[BYStorage sharedStorage] saveDocument];
    [self updateDeleteButtonStateToVisible:NO];
}

@end
