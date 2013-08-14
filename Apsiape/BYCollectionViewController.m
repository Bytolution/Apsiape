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

@interface BYCollectionViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, BYCollectionViewCellDelegate, BYNewExpenseWindowDelegate>

@property (nonatomic, strong) NSMutableArray *collectionViewData;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) BYNewExpenseWindow *expenseWindow;
@property (nonatomic) BOOL menuBarIsVisible;
@property (nonatomic, strong) NSMutableArray *cellStates;

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
        self.collectionView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [self.collectionView registerClass:[BYCollectionViewCell class] forCellWithReuseIdentifier:@"CELL_ID"];
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.collectionView];
        UILabel *label = [UILabel new];
        label.text = @"Create new";
        label.frame = CGRectMake(0, - NAVBAR_HEIGHT, 320, NAVBAR_HEIGHT);
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
        label.textAlignment = NSTextAlignmentCenter;
        [self.collectionView addSubview:label];
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
    NSMutableArray *indexesForDeletion = [[NSMutableArray alloc]initWithCapacity:self.collectionViewData.count];
    NSMutableIndexSet *indexSetForDeletion = [[NSMutableIndexSet alloc]init];
    for (int i = 0; i < self.cellStates.count; i++) {
        if ([self.cellStates[i] isEqual:[NSNumber numberWithInt:BYCollectionViewCellStateRightSideRevealed]]) {
            [indexesForDeletion addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            [indexSetForDeletion addIndex:i];
            Expense *expense = self.collectionViewData[i];
            NSError *error;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:expense.fullResolutionImagePath error:&error];
            [fileManager removeItemAtPath:expense.screenResolutionImagePath error:&error];
            [fileManager removeItemAtPath:expense.screenResolutionMonochromeImagePath error:&error];
            [fileManager removeItemAtPath:expense.thumbnailResolutionImagePath error:&error];
            [fileManager removeItemAtPath:expense.thumbnailResolutionMonochromeImagePath error:&error];
            NSManagedObjectContext *context = [BYStorage sharedStorage].managedObjectContext;
            [context deleteObject:expense];
        }
    }
    [[BYStorage sharedStorage] saveDocument];
    
    [self.collectionViewData removeObjectsAtIndexes:indexSetForDeletion];
    [self.cellStates removeObjectsAtIndexes:indexSetForDeletion];
    [self.collectionView deleteItemsAtIndexPaths:indexesForDeletion];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController pushViewController:[[BYCollectionViewController alloc]initWithNibName:nil bundle:nil] animated:YES];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(6, 0, 5, 0);
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < - 60) {
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
