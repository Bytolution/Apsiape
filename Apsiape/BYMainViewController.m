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
        [self.collectionViewData addObject:mutableCellInfo];
    }
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.collectionView) {
        self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
        self.flowLayout.itemSize = CGSizeMake(320, 80);
        self.flowLayout.minimumInteritemSpacing = 0;
        self.flowLayout.minimumLineSpacing = 0;
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.collectionView.backgroundColor = [UIColor whiteColor];
        [self.collectionView registerClass:[BYCollectionViewCell class] forCellWithReuseIdentifier:@"CELL_ID"];
        [self.view addSubview:self.collectionView];
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.collectionViewData count];
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BYCollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"CELL_ID" forIndexPath:indexPath];
    NSLog(@"%s", __PRETTY_FUNCTION__);
    Expense *expense = [self.collectionViewData[indexPath.row] objectForKey:@"expense"];
    cell.title = expense.value;
    cell.image = expense.image;
    cell.delegate = self;
    cell.cellState = [[self.collectionViewData[indexPath.row] objectForKey:@"cellState"] intValue];
    [cell layoutSubviews];
    return cell;
}

- (void)cell:(BYCollectionViewCell *)cell didEnterStateWithAnimation:(BYCollectionViewCellState)state
{
    if (state == BYCollectionViewCellStateRightSideRevealed) {
        NSMutableDictionary *cellInfo = [self.collectionViewData objectAtIndex:[self.collectionView indexPathForCell:cell].row];
        [cellInfo setObject:[NSNumber numberWithInt:BYCollectionViewCellStateRightSideRevealed] forKey:@"cellState"];
    } else if (state == BYCollectionViewCellStateLeftSideRevealed) {
        NSMutableDictionary *cellInfo = [self.collectionViewData objectAtIndex:[self.collectionView indexPathForCell:cell].row];
        [cellInfo setObject:[NSNumber numberWithInt:BYCollectionViewCellStateLeftSideRevealed] forKey:@"cellState"];
    } else if (state == BYCollectionViewCellStateDefault) {
        NSMutableDictionary *cellInfo = [self.collectionViewData objectAtIndex:[self.collectionView indexPathForCell:cell].row];
        [cellInfo setObject:[NSNumber numberWithInt:BYCollectionViewCellStateDefault] forKey:@"cellState"];
    }
}

- (void)cellDidRecieveAction:(BYCollectionViewCell *)cell
{
    NSIndexPath *cellIndex = [self.collectionView indexPathForCell:cell];
    [self.collectionViewData removeObjectAtIndex:[self.collectionView indexPathForCell:cell].row];
    [self.collectionView deleteItemsAtIndexPaths:[NSIndexSet indexSetWithIndex:cellIndex]];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    self.flowLayout.itemSize = CGSizeMake(159.5, 159.5);
    [self.flowLayout invalidateLayout];
}

//----------------------------------------------------------------------Pull control implementation------------------------------------------------------------------------//

#define PULL_WIDTH 80

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < - PULL_WIDTH && scrollView.contentOffset.y < 0) {
        [[BYContainerViewController sharedContainerViewController] displayExpenseCreationViewController];
    }
}

@end
