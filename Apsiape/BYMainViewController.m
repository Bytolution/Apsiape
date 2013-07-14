//
//  BYMainViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BYMainViewController.h"
#import "BYCollectionViewCell.h"
#import "BYStorage.h"
#import "BYContainerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Expense.h"
#import "UIImage+Adjustments.h"

@interface BYMainViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, BYCollectionViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *collectionViewData;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

- (void)updateCollectionViewData;

@end

#define REFRESH_HEADER_HEIGHT 50

@implementation BYMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionViewData) name:UIDocumentStateChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionViewData) name:@"UIDocumentSavedSuccessfullyNotification" object:nil];
    }
    return self;
}

- (void)updateCollectionViewData
{
    if (!self.collectionViewData) self.collectionViewData = [[NSMutableArray alloc]init];
    [self.collectionViewData removeAllObjects];
    NSFetchRequest *fetchR = [NSFetchRequest fetchRequestWithEntityName:@"Expense"];
    NSManagedObjectContext *context = [[BYStorage sharedStorage] managedObjectContext];
    NSError *error;
    NSArray *fetchDataArray = [[context executeFetchRequest:fetchR error:&error] mutableCopy];
    for (Expense *expense in fetchDataArray) {
        NSMutableDictionary *mutableCellInfo = [[NSMutableDictionary alloc]initWithDictionary:@{@"expense": expense, @"cellState" : [NSNumber numberWithInt:BYCollectionViewCellStateDefault]}];
        [mutableCellInfo setObject:[NSNumber numberWithInt:BYCollectionViewCellStateDefault] forKey:@"cellState"];
        [mutableCellInfo setObject:expense forKey:@"expense"];
        [self.collectionViewData addObject:mutableCellInfo];
    }
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.collectionView) {
        self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
        self.flowLayout.itemSize = CGSizeMake(320, 100);
        self.flowLayout.minimumInteritemSpacing = 0;
        self.flowLayout.minimumLineSpacing = 0;
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[BYCollectionViewCell class] forCellWithReuseIdentifier:@"CELL_ID"];
        [self.view addSubview:self.collectionView];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    self.flowLayout.itemSize = CGSizeMake(320, 320);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionViewData count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BYCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ID" forIndexPath:indexPath];
    Expense *expense = [self.collectionViewData[indexPath.row] objectForKey:@"expense"];
    cell.title = expense.stringValue;
    cell.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:expense.thumbnailResolutionMonochromeImagePath]];
    cell.delegate = self;
    cell.cellState = [[self.collectionViewData[indexPath.row] objectForKey:@"cellState"] intValue];
    [cell prepareLayout];
    return cell;
}

- (void)cell:(BYCollectionViewCell *)cell didEnterStateWithAnimation:(BYCollectionViewCellState)state
{
    if (state == BYCollectionViewCellStateRightSideRevealed) {
        NSMutableDictionary *cellInfo = [self.collectionViewData objectAtIndex:[self.collectionView indexPathForCell:cell].row];
        [cellInfo setObject:[NSNumber numberWithInt:state] forKey:@"cellState"];
    } else if (state == BYCollectionViewCellStateLeftSideRevealed) {
        NSMutableDictionary *cellInfo = [self.collectionViewData objectAtIndex:[self.collectionView indexPathForCell:cell].row];
        [cellInfo setObject:[NSNumber numberWithInt:state] forKey:@"cellState"];
    } else if (state == BYCollectionViewCellStateDefault) {
        NSMutableDictionary *cellInfo = [self.collectionViewData objectAtIndex:[self.collectionView indexPathForCell:cell].row];
        [cellInfo setObject:[NSNumber numberWithInt:state] forKey:@"cellState"];
    }
}

- (void)cellDidRecieveAction:(BYCollectionViewCell *)cell
{
    NSMutableArray *indexesForDeletion = [[NSMutableArray alloc]initWithCapacity:self.collectionViewData.count];
    NSMutableIndexSet *indexSetForDeletion = [[NSMutableIndexSet alloc]init];
    for (int i = 0; i < self.collectionViewData.count; i++) {
        NSMutableDictionary *cellInfo = self.collectionViewData[i];
        if ([[cellInfo objectForKey:@"cellState"] isEqual:[NSNumber numberWithInt:BYCollectionViewCellStateRightSideRevealed]]) {
            [indexesForDeletion addObject:[NSIndexPath indexPathForRow:i inSection:0]];
            [indexSetForDeletion addIndex:i];
            Expense *expense = [cellInfo objectForKey:@"expense"];
            NSError *error;
            NSFileManager *fileManager = [NSFileManager defaultManager];
            [fileManager removeItemAtPath:expense.fullResolutionImagePath error:&error];
            [fileManager removeItemAtPath:expense.screenResolutionImagePath error:&error];
            [fileManager removeItemAtPath:expense.screenResolutionMonochromeImagePath error:&error];
            [fileManager removeItemAtPath:expense.thumbnailResolutionImagePath error:&error];
            [fileManager removeItemAtPath:expense.thumbnailResolutionMonochromeImagePath error:&error];
            NSManagedObjectContext *context = [BYStorage sharedStorage].managedObjectContext;
            [context deleteObject:[cellInfo objectForKey:@"expense"]];
        }
    }
    [[BYStorage sharedStorage] saveDocument];
    
    [self.collectionViewData removeObjectsAtIndexes:indexSetForDeletion];
    [self.collectionView deleteItemsAtIndexPaths:indexesForDeletion];
}

#define PULL_WIDTH 80

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < - PULL_WIDTH && scrollView.contentOffset.y < 0) {
        [[BYContainerViewController sharedContainerViewController] displayExpenseCreationViewController];
    }
}

@end
