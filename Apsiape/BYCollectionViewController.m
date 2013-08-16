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
#import "BYNewExpenseWindow.h"
#import "BYStatsViewController.h"
#import "BYTableViewCellBGView.h"

@interface BYCollectionViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, BYCollectionViewCellDelegate, BYNewExpenseWindowDelegate>

@property (nonatomic, strong) NSMutableArray *collectionViewData;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) BYNewExpenseWindow *expenseWindow;
@property (nonatomic) BOOL menuBarIsVisible;
@property (nonatomic, strong) NSMutableArray *cellStates;
@property (nonatomic, strong) UILabel *pullControlLabel;
@property (nonatomic, readwrite) BOOL scrollViewOffsetExceedsPullThreshold;
@property (nonatomic, readwrite) BOOL pullControlLabelTextChangeAnimationInProgress;

- (void)updateCollectionViewData;
- (void)prepareCollectionView;

@end

#define PULL_WIDTH 64

@implementation BYCollectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Overview";
        if (!self.collectionViewData) self.collectionViewData = [[NSMutableArray alloc]init];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionViewData) name:UIDocumentStateChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionViewData) name:@"UIDocumentSavedSuccessfullyNotification" object:nil];
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
        self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
        self.flowLayout.itemSize = CGSizeMake(self.view.frame.size.width - (CELL_PADDING*2), CELL_HEIGHT);
        self.flowLayout.minimumInteritemSpacing = 0;
        self.flowLayout.minimumLineSpacing = ROW_PADDING;
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, 320, CGRectGetMaxY(self.view.frame)) collectionViewLayout:self.flowLayout];
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        self.collectionView.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
        [self.collectionView registerClass:[BYCollectionViewCell class] forCellWithReuseIdentifier:@"CELL_ID"];
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.collectionView];
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
    BYTableViewCellBGViewCellPosition cellPos = 0;
    if (indexPath.row == 0 && [collectionView numberOfItemsInSection:indexPath.section] == 1) {
        // single cell
        cellPos = BYTableViewCellBGViewCellPositionSingle;
    } else if (indexPath.row == 0 && [collectionView numberOfItemsInSection:indexPath.section] > 1) {
        // top cell
        cellPos = BYTableViewCellBGViewCellPositionTop;
    } else if (indexPath.row == ([collectionView numberOfItemsInSection:indexPath.section] - 1)) {
        //bottom cell
        cellPos = BYTableViewCellBGViewCellPositionBottom;
    } else {
        //middle cell
        cellPos = BYTableViewCellBGViewCellPositionMiddle;
    }
    //FIXME: too many separator views on one cell -> glitch
    NSLog(@"%s, %@", __PRETTY_FUNCTION__, indexPath);
    BYCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ID" forIndexPath:indexPath];
    Expense *expense = self.collectionViewData[indexPath.row];
    cell.title = expense.stringValue;
    cell.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:expense.thumbnailResolutionMonochromeImagePath]];
    cell.delegate = self;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    NSString *dateString = [dateFormatter stringFromDate:expense.date];
    cell.cellState = [self.cellStates[indexPath.row] intValue];
    cell.subtitle = [NSString stringWithFormat:@"%@%@ %@", expense.locationString, expense.locationString ? @"," : @"", dateString];
    [cell prepareLayout];
    return cell;
}

- (void)cell:(BYCollectionViewCell *)cell didEnterStateWithAnimation:(BYCollectionViewCellState)state
{
    [self.cellStates replaceObjectAtIndex:[self.collectionView indexPathForCell:cell].row withObject:[NSNumber numberWithInt:state]];
}

- (void)cellDidRecieveAction:(BYCollectionViewCell *)cell
{
    for (int i = 0; i < self.cellStates.count; i++) {
        if ([self.cellStates[i] isEqual:[NSNumber numberWithInt:BYCollectionViewCellStateRightSideRevealed]]) {
            Expense *expense = self.collectionViewData[i];
            [[BYStorage sharedStorage] deleteExpenseObject:expense completion:^{
                [self.collectionViewData removeObjectAtIndex:i];
                [self.cellStates removeObjectAtIndex:i];
                [self.collectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
            }];
        }
    }
    [[BYStorage sharedStorage] saveDocument];
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    NSLog(@"%@", NSStringFromCGPoint(scrollView.contentOffset));
    if (self.scrollViewOffsetExceedsPullThreshold) {
        self.expenseWindow = [[BYNewExpenseWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        self.expenseWindow.windowLevel = UIWindowLevelAlert;
        self.expenseWindow.windowDelegate = self;
        self.expenseWindow.alpha = 0;
        [self.expenseWindow makeKeyAndVisible];
        [UIView animateWithDuration:0.5 animations:^{
            self.expenseWindow.alpha = 1;
        } completion:^(BOOL finished) {
            self.view.hidden = YES;
        }];
    }
}

- (void)setScrollViewOffsetExceedsPullThreshold:(BOOL)scrollViewOffsetExceedsPullThreshold
{
    _scrollViewOffsetExceedsPullThreshold = scrollViewOffsetExceedsPullThreshold;
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < - 140 && !self.scrollViewOffsetExceedsPullThreshold) {
        self.scrollViewOffsetExceedsPullThreshold = YES;
    } else if (scrollView.contentOffset.y > - 140 && self.scrollViewOffsetExceedsPullThreshold) {
        self.scrollViewOffsetExceedsPullThreshold = NO;
    }
    
    if (self.scrollViewOffsetExceedsPullThreshold && [self.pullControlLabel.text isEqualToString:@"Create new"] && !self.pullControlLabelTextChangeAnimationInProgress) {
        [UIView animateWithDuration:0.15 animations:^{
            self.pullControlLabel.alpha = 0;
            self.pullControlLabelTextChangeAnimationInProgress = YES;
        } completion:^(BOOL finished) {
            self.pullControlLabel.text = @"Release";
            [UIView animateWithDuration:0.15 animations:^{
                self.pullControlLabel.alpha = 1;
            } completion:^(BOOL finished) {
                self.pullControlLabelTextChangeAnimationInProgress = NO;
            }];
        }];
    } else if (!self.scrollViewOffsetExceedsPullThreshold && [self.pullControlLabel.text isEqualToString:@"Release"] && !self.pullControlLabelTextChangeAnimationInProgress) {
        [UIView animateWithDuration:0.15 animations:^{
            self.pullControlLabel.alpha = 0;
            self.pullControlLabelTextChangeAnimationInProgress = YES;
        } completion:^(BOOL finished) {
            self.pullControlLabel.text = @"Create new";
            [UIView animateWithDuration:0.15 animations:^{
                self.pullControlLabel.alpha = 1;
            } completion:^(BOOL finished) {
                self.pullControlLabelTextChangeAnimationInProgress = NO;
            }];
        }];
    }
}

#pragma mark - Window Delegate

- (void)windowShouldDisappear:(BYNewExpenseWindow *)window
{
    self.view.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        [(UIWindow*)self.view.window makeKeyWindow];
        self.expenseWindow.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.expenseWindow = nil;
    }];
}

@end
