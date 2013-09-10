//
//  BYCollectionViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BYCollectionViewController.h"
#import "BYThumbnailCell.h"
#import "BYStorage.h"
#import "BYLabelCell.h"
#import "Expense.h"
#import "InterfaceDefinitions.h"
#import "BYExpenseCreationViewController.h"
#import "BYStatsViewController.h"
#import "HorizontalFlowLayout.h"
#import "BYPopupVCTransitionController.h"

@interface BYCollectionViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, BYThumbnailCellDelegate, UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) NSMutableArray *collectionViewData;
@property (nonatomic, strong) UICollectionView *thumbnailCollectionView;
@property (nonatomic, strong) UICollectionView *valueCollectionView;
@property (nonatomic, strong) BYExpenseCreationViewController *expenseWindow;
@property (nonatomic) BOOL menuBarIsVisible;
@property (nonatomic, strong) NSMutableArray *cellStates;
@property (nonatomic, strong) UILabel *pullControlLabel;
@property (nonatomic, readwrite) BOOL scrollViewOffsetExceedsPullThreshold;
@property (nonatomic, readwrite) BOOL pullControlLabelTextChangeAnimationInProgress;
@property (nonatomic, readwrite) BOOL draggingEndedWithExceededPullThreshold;

- (void)updateCollectionViewData;
- (CGPoint)targetOffsetForProposedOffset:(CGPoint)propOffset;

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
        [self.cellStates addObject:[NSNumber numberWithInt:BYThumbnailCellStateDefault]];
    }
    [self.thumbnailCollectionView reloadData];
    [self.valueCollectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateCollectionViewData];
}
- (void)viewDidAppear:(BOOL)animated
{
    if (!self.thumbnailCollectionView) {
        HorizontalFlowLayout *xFlowLayout = [[HorizontalFlowLayout alloc]init];
        xFlowLayout.itemSize = CGSizeMake(90, 90);
        xFlowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 320 - xFlowLayout.itemSize.width);
        self.thumbnailCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, 320, 100) collectionViewLayout:xFlowLayout];
        self.thumbnailCollectionView.dataSource = self;
        self.thumbnailCollectionView.delegate = self;
        self.thumbnailCollectionView.showsHorizontalScrollIndicator = NO;
        self.thumbnailCollectionView.backgroundColor = [UIColor clearColor];
        [self.thumbnailCollectionView registerClass:[BYThumbnailCell class] forCellWithReuseIdentifier:@"CELL_ID_thmbn"];
        self.thumbnailCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.thumbnailCollectionView];
    }
    if (!self.valueCollectionView) {
        HorizontalFlowLayout *xFlowLayoutForLabels = [[HorizontalFlowLayout alloc]init];
        xFlowLayoutForLabels.itemSize = CGSizeMake(320, 90);
        self.valueCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 164, 320, 90) collectionViewLayout:xFlowLayoutForLabels];
        self.valueCollectionView.dataSource = self;
        self.valueCollectionView.delegate = self;
        self.valueCollectionView.showsHorizontalScrollIndicator = NO;
        self.valueCollectionView.backgroundColor = [UIColor clearColor];
        [self.valueCollectionView registerClass:[BYLabelCell class] forCellWithReuseIdentifier:@"CELL_ID_val"];
        self.valueCollectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.valueCollectionView];
    }

    [self updateCollectionViewData];
}

#pragma mark - Collection View

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionViewData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Expense *expense = self.collectionViewData[indexPath.row];
    
    if (collectionView == self.thumbnailCollectionView) {
        BYThumbnailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ID_thmbn" forIndexPath:indexPath];
        cell.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@thumb-mono.jpg", expense.baseFilePath]]];
        [cell prepareLayout];
        return cell;
    } else if (collectionView == self.valueCollectionView) {
        BYLabelCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ID_val" forIndexPath:indexPath];
        cell.title = expense.stringValue;
        return cell;
    } else {
        [NSException raise:@"BYCollectionViewControllerException" format:@"collection view from call back does not match either of the expected ones"];
        return nil;
    }
}

- (void)cell:(BYThumbnailCell *)cell didEnterStateWithAnimation:(BYThumbnailCellState)state
{
    [self.cellStates replaceObjectAtIndex:[self.thumbnailCollectionView indexPathForCell:cell].row withObject:[NSNumber numberWithInt:state]];
}

- (void)cellDidRecieveAction:(BYThumbnailCell *)cell
{
    NSMutableIndexSet *deletionIndexSet = [[NSMutableIndexSet alloc]init];
    NSMutableArray *deletionIndexesForCollectionView = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.cellStates.count; i++) {
        if ([self.cellStates[i] isEqual:[NSNumber numberWithInt:BYThumbnailCellStateRightSideRevealed]]) {
            Expense *expense = self.collectionViewData[i];
            [[BYStorage sharedStorage] deleteExpenseObject:expense completion:nil];
            [deletionIndexSet addIndex:i];
            [deletionIndexesForCollectionView addObject:[NSIndexPath indexPathForItem:i inSection:0]];
        }
    }
    [self.collectionViewData removeObjectsAtIndexes:deletionIndexSet];
    [self.cellStates removeObjectsAtIndexes:deletionIndexSet];
    [self.thumbnailCollectionView deleteItemsAtIndexPaths:deletionIndexesForCollectionView];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[BYCollectionViewController alloc]initWithNibName:nil bundle:nil] animated:YES];
}



#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.thumbnailCollectionView setContentOffset:[self targetOffsetForProposedOffset:self.thumbnailCollectionView.contentOffset] animated:YES];
//    if (self.draggingEndedWithExceededPullThreshold) {
//        self.draggingEndedWithExceededPullThreshold = NO;
//        BYExpenseCreationViewController *expenseVC = [[BYExpenseCreationViewController alloc]initWithNibName:nil bundle:nil];
//        expenseVC.transitioningDelegate = self;
//        expenseVC.modalPresentationStyle = UIModalPresentationCustom;
//        [self.navigationController presentViewController:expenseVC animated:YES completion:^{
//            
//        }];
//    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.scrollViewOffsetExceedsPullThreshold) {
        self.draggingEndedWithExceededPullThreshold = YES;
    }
    if (!decelerate) {
        [self.thumbnailCollectionView setContentOffset:[self targetOffsetForProposedOffset:self.thumbnailCollectionView.contentOffset] animated:YES];
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
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < - 130 && !self.scrollViewOffsetExceedsPullThreshold) {
        self.scrollViewOffsetExceedsPullThreshold = YES;
    } else if (scrollView.contentOffset.x > - 130 && self.scrollViewOffsetExceedsPullThreshold) {
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
    
    if (scrollView == self.thumbnailCollectionView) {
        double factor = scrollView.contentOffset.x/(scrollView.contentSize.width - CGRectGetMaxX(scrollView.frame));
        [self.valueCollectionView setContentOffset:CGPointMake((self.valueCollectionView.contentSize.width - CGRectGetMaxX(self.valueCollectionView.frame)) *factor, 0)];
    } else if (scrollView == self.valueCollectionView) {
        double factor = scrollView.contentOffset.x/(scrollView.contentSize.width - CGRectGetMaxX(scrollView.frame));
        [self.thumbnailCollectionView setContentOffset:CGPointMake((self.thumbnailCollectionView.contentSize.width - CGRectGetMaxX(self.thumbnailCollectionView.frame)) *factor, 0)];
    }
}

#pragma mark Offset adjustements

- (CGPoint)targetOffsetForProposedOffset:(CGPoint)propOffset
{
    CGFloat itemWidth =[(UICollectionViewFlowLayout*)self.thumbnailCollectionView.collectionViewLayout itemSize].width;
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
    numberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
    numberFormatter.maximumFractionDigits = 0;
    CGFloat factor = propOffset.x/itemWidth;
    CGFloat roundedFactor = [[numberFormatter stringFromNumber:[NSNumber numberWithFloat:factor]]floatValue];
    NSLog(@"div: %f", roundedFactor);
    return CGPointMake(roundedFactor*itemWidth, propOffset.y);
}

@end
