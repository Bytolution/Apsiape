//
//  BYCollectionViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BYCollectionViewController.h"
#import "BYCollectionViewCell.h"
#import "BYStorage.h"
#import "Expense.h"
#import "InterfaceDefinitions.h"
#import "BYExpenseCreationViewController.h"
#import "BYStatsViewController.h"
#import "TableFlowLayout.h"
#import "BYPopupVCTransitionController.h"

@interface BYCollectionViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, BYCollectionViewCellDelegate, BYExpenseCreationViewControllerDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSMutableArray *collectionViewData;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) BYExpenseCreationViewController *expenseWindow;
@property (nonatomic) BOOL menuBarIsVisible;
@property (nonatomic, strong) NSMutableArray *cellStates;
@property (nonatomic, strong) UILabel *pullControlLabel;
@property (nonatomic, readwrite) BOOL scrollViewOffsetExceedsPullThreshold;
@property (nonatomic, readwrite) BOOL pullControlLabelTextChangeAnimationInProgress;
@property (nonatomic, readwrite) BOOL draggingEndedWithExceededPullThreshold;

- (void)updateCollectionViewData;
- (void)prepareCollectionView;

@end


@implementation BYCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Overview";
        if (!self.collectionViewData) self.collectionViewData = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionViewData) name:@"BYStorageContentChangedNotification" object:nil];
    }
    return self;
}

- (void)updateCollectionViewData
{
    [self.collectionViewData removeAllObjects];
    NSFetchRequest *fetchR = [NSFetchRequest fetchRequestWithEntityName:@"Expense"];
    NSManagedObjectContext *context = [[BYStorage sharedStorage] managedObjectContext];
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
    fetchR.sortDescriptors = @[sortDescriptor];
    NSArray *fetchDataArray = [[context executeFetchRequest:fetchR error:&error] mutableCopy];
    self.collectionViewData = [fetchDataArray mutableCopy];
    if (!self.cellStates) self.cellStates = [[NSMutableArray alloc]init];
    [self.cellStates removeAllObjects];
    for (int i = 0; i < self.collectionViewData.count; i++) {
        [self.cellStates addObject:[NSNumber numberWithInt:BYCollectionViewCellStateDefault]];
    }
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self prepareCollectionView];
}
- (void)viewDidAppear:(BOOL)animated
{
    [self updateCollectionViewData];
}

#pragma mark - Collection View

- (void)prepareCollectionView
{
    if (!self.collectionView) {
        self.flowLayout = [[TableFlowLayout alloc]init];
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(self.view.frame)) collectionViewLayout:self.flowLayout];
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        self.collectionView.backgroundColor = [UIColor colorWithRed:0.9 green:0.95 blue:1 alpha:1];
        [self.collectionView registerClass:[BYCollectionViewCell class] forCellWithReuseIdentifier:@"CELL_ID"];
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.collectionView.decelerationRate = UIScrollViewDecelerationRateNormal;
        [self.view addSubview:self.collectionView];
        
        // 'Pull to create' & 'release' label
        self.pullControlLabel = [UILabel new];
        self.pullControlLabel.text = @"Create new";
        self.pullControlLabel.frame = CGRectMake(0, - NAVBAR_HEIGHT, 320, NAVBAR_HEIGHT);
        self.pullControlLabel.textColor = [UIColor blackColor];
        self.pullControlLabel.backgroundColor = [UIColor clearColor];
        self.pullControlLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
        self.pullControlLabel.textAlignment = NSTextAlignmentCenter;
        [self.collectionView addSubview:self.pullControlLabel];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionViewData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BYCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ID" forIndexPath:indexPath];
    Expense *expense = self.collectionViewData[indexPath.row];
    cell.title = expense.stringValue;
    cell.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@thumb-mono.jpg", expense.baseFilePath]]];
    cell.delegate = self;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    NSString *dateString = [dateFormatter stringFromDate:expense.date];
    cell.cellState = [self.cellStates[indexPath.row] intValue];
    cell.subtitle = [NSString stringWithFormat:@"%@%@ %@", expense.locationString ? expense.locationString : @"", expense.locationString ? @"," : @"", dateString];
    [cell prepareLayout];
    return cell;
}

- (void)cell:(BYCollectionViewCell *)cell didEnterStateWithAnimation:(BYCollectionViewCellState)state
{
    [self.cellStates replaceObjectAtIndex:[self.collectionView indexPathForCell:cell].row withObject:[NSNumber numberWithInt:state]];
}

- (void)cellDidRecieveAction:(BYCollectionViewCell *)cell
{
    NSMutableIndexSet *deletionIndexSet = [[NSMutableIndexSet alloc]init];
    NSMutableArray *deletionIndexesForCollectionView = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.cellStates.count; i++) {
        if ([self.cellStates[i] isEqual:[NSNumber numberWithInt:BYCollectionViewCellStateRightSideRevealed]]) {
            Expense *expense = self.collectionViewData[i];
            //FIXME: deletion must happen in bunches
            [[BYStorage sharedStorage] deleteExpenseObject:expense completion:nil];
            [deletionIndexSet addIndex:i];
            [deletionIndexesForCollectionView addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
    }
    [self.collectionViewData removeObjectsAtIndexes:deletionIndexSet];
    [self.cellStates removeObjectsAtIndexes:deletionIndexSet];
    [self.collectionView deleteItemsAtIndexPaths:deletionIndexesForCollectionView];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[BYCollectionViewController alloc]initWithNibName:nil bundle:nil] animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 5, 0);
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.draggingEndedWithExceededPullThreshold) {
        self.draggingEndedWithExceededPullThreshold = NO;
        BYExpenseCreationViewController *expenseVC = [[BYExpenseCreationViewController alloc]initWithNibName:nil bundle:nil];
        expenseVC.transitioningDelegate = self;
        expenseVC.modalPresentationStyle = UIModalPresentationCustom;
        [self.navigationController presentViewController:expenseVC animated:YES completion:^{
            
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollViewOffsetExceedsPullThreshold) {
        self.draggingEndedWithExceededPullThreshold = YES;
    }
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    BYPopupVCTransitionController *animationController = [[BYPopupVCTransitionController alloc]init];
    animationController.presentedVC = presented;
    animationController.presentingVC = presenting;
    animationController.duration = 0.7;
    return animationController;
}

- (void)setScrollViewOffsetExceedsPullThreshold:(BOOL)scrollViewOffsetExceedsPullThreshold
{
    _scrollViewOffsetExceedsPullThreshold = scrollViewOffsetExceedsPullThreshold;
    NSLog(@"%s", __PRETTY_FUNCTION__);
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

#pragma mark - Window Delegate

- (void)windowShouldDisappear:(BYExpenseCreationViewController *)window
{
    
}

@end
