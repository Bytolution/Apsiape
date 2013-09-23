//
//  BYCollectionViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BYCollectionViewController.h"
#import "BYStorage.h"
#import "Expense.h"
#import "InterfaceDefinitions.h"
#import "BYExpenseCreationViewController.h"
#import "BYPopupVCTransitionController.h"
#import "BYTableViewCell.h"

@interface BYCollectionViewController () <UIScrollViewDelegate, UIViewControllerTransitioningDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSMutableArray *collectionViewData;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *cellStates;
@property (nonatomic, strong) UILabel *pullControlLabel;
@property (nonatomic, readwrite) CGFloat tableViewCellHeight;
@property (nonatomic, readwrite) BOOL scrollViewOffsetExceedsPullThreshold;
@property (nonatomic, readwrite) BOOL pullControlLabelTextChangeAnimationInProgress;
@property (nonatomic, readwrite) BOOL draggingEndedWithExceededPullThreshold;

- (void)updateCollectionViewData;
- (CGPoint)targetOffsetForProposedOffset:(CGPoint)propOffset;
- (void)scrollViewWillSnapToIndex:(NSInteger)index;

@end


@implementation BYCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Overview";
        if (!self.collectionViewData) self.collectionViewData = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionViewData) name:@"BYStorageContentChangedNotification" object:nil];
        if (!self.tableView) self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.contentInset = UIEdgeInsetsMake(CELL_INSET_Y, 0, CELL_INSET_Y, 0);
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableView];
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
//        [self.cellStates addObject:[NSNumber numberWithInt:BYThumbnailCellStateDefault]];
    }
    [self.tableView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateCollectionViewData];
}
- (void)viewDidAppear:(BOOL)animated
{
    if (!self.tableView) self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
}

#pragma mark - Table View

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.collectionViewData.count;
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
    Expense *expense = self.collectionViewData[indexPath.row];
    cell.textLabel.text = expense.stringValue;
    cell.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@screen.jpg", expense.baseFilePath]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    [self.thumbnailCollectionView setContentOffset:[self targetOffsetForProposedOffset:self.thumbnailCollectionView.contentOffset] animated:YES];
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
    if (!decelerate) {
//        [self.thumbnailCollectionView setContentOffset:[self targetOffsetForProposedOffset:self.thumbnailCollectionView.contentOffset] animated:YES];
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
//    if (scrollView == self.thumbnailCollectionView) {
//        double factor = scrollView.contentOffset.x/(scrollView.contentSize.width - CGRectGetMaxX(scrollView.frame));
//        [self.valueCollectionView setContentOffset:CGPointMake((self.valueCollectionView.contentSize.width - CGRectGetMaxX(self.valueCollectionView.frame)) *factor, 0)];
//    } else if (scrollView == self.valueCollectionView) {
//        double factor = scrollView.contentOffset.x/(scrollView.contentSize.width - CGRectGetMaxX(scrollView.frame));
//        [self.thumbnailCollectionView setContentOffset:CGPointMake((self.thumbnailCollectionView.contentSize.width - CGRectGetMaxX(self.thumbnailCollectionView.frame)) *factor, 0)];
//    }
}

//- (void)scrollViewWillSnapToIndex:(NSInteger)index
//{
//    Expense *expense = [self.collectionViewData objectAtIndex:index];
//}

#pragma mark Offset adjustements

- (CGPoint)targetOffsetForProposedOffset:(CGPoint)propOffset
{
//    CGFloat itemWidth =[(UICollectionViewFlowLayout*)self.thumbnailCollectionView.collectionViewLayout itemSize].width;
//    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc]init];
//    numberFormatter.roundingMode = NSNumberFormatterRoundHalfUp;
//    numberFormatter.maximumFractionDigits = 0;
//    CGFloat factor = propOffset.x/itemWidth;
//    CGFloat roundedFactor = [[numberFormatter stringFromNumber:[NSNumber numberWithFloat:factor]]floatValue];
//    [self scrollViewWillSnapToIndex:roundedFactor];
//    return CGPointMake(roundedFactor*itemWidth, propOffset.y);
}

@end
