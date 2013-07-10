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

@interface BYMainViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *collectionViewData;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGesture;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

- (void)updateCollectionViewData;
- (void)swipeGestureRecognized:(UISwipeGestureRecognizer*)gesture;
- (void)panGestureRecognized:(UIPanGestureRecognizer*)pan;

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
    NSFetchRequest *fetchR = [NSFetchRequest fetchRequestWithEntityName:@"Expense"];
    NSManagedObjectContext *context = [[BYStorage sharedStorage] managedObjectContext];
    NSError *error;
    self.collectionViewData = [[context executeFetchRequest:fetchR error:&error] mutableCopy];
    [self.collectionView reloadData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (!self.collectionView) {
        self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
        self.flowLayout.itemSize = CGSizeMake(320, 80);
        self.flowLayout.minimumInteritemSpacing = 0;
        self.flowLayout.minimumLineSpacing = 1;
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:self.flowLayout];
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
        self.collectionView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
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
    Expense *expense = self.collectionViewData[indexPath.row];
    cell.title = expense.value;
    cell.image = expense.image;
//    NSLog(@"Cell dequeued for index: %i", indexPath.row);
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    self.flowLayout.itemSize = CGSizeMake(159.5, 159.5);
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
