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
#import "BYMenuBar.h"

@interface BYCollectionViewController () <UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, BYCollectionViewCellDelegate, BYNewExpenseWindowDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSMutableArray *collectionViewData;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) BYNewExpenseWindow *expenseWindow;
@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, strong) UIView *statusBarBG;
@property (nonatomic) BOOL menuBarIsVisible;

- (void)updateCollectionViewData;
- (void)prepareCollectionView;
- (void)panRecognized:(UIPanGestureRecognizer*)pan;

@end

#define PULL_WIDTH 80

@implementation BYCollectionViewController

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
    self.statusBarBG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    self.statusBarBG.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1];
    [self.view addSubview:self.statusBarBG];
    [self prepareCollectionView];
    
    self.panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panRecognized:)];
    self.panGesture.delegate = self;
    [self.view addGestureRecognizer:self.panGesture];
}

#pragma mark - Collection View

- (void)prepareCollectionView
{
    if (!self.collectionView) {
        self.flowLayout = [[UICollectionViewFlowLayout alloc]init];
        self.flowLayout.itemSize = CGSizeMake(self.view.frame.size.width - (CELL_PADDING*2), CELL_HEIGHT);
        self.flowLayout.minimumInteritemSpacing = 0;
        self.flowLayout.minimumLineSpacing = ROW_PADDING;
        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, 320, self.view.bounds.size.height-20) collectionViewLayout:self.flowLayout];
        self.collectionView.alwaysBounceVertical = YES;
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.indicatorStyle = UIScrollViewIndicatorStyleBlack;
        self.collectionView.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1];
        [self.collectionView registerClass:[BYCollectionViewCell class] forCellWithReuseIdentifier:@"CELL_ID"];
        self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.view addSubview:self.collectionView];
        UIView *topPullView = [[UIView alloc]initWithFrame:CGRectMake(0, -300, 320, 300)];
        topPullView.backgroundColor = [UIColor colorWithWhite:0.6 alpha:1];
        UILabel *label = [UILabel new];
        label.text = @"Create new";
        label.frame = CGRectMake(0, - PULL_WIDTH, 320, PULL_WIDTH);
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:30];
        label.textAlignment = NSTextAlignmentCenter;
        [self.collectionView addSubview:topPullView];
        [self.collectionView addSubview:label];
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([(UIPanGestureRecognizer*)gestureRecognizer locationInView:gestureRecognizer.view].x < 30) {
        return YES;
    } else {
        return NO;
    }
}

- (void)panRecognized:(UIPanGestureRecognizer *)pan
{
    if (pan.state == UIGestureRecognizerStateBegan) {
        NSLog(@"Pam gesture began");
    }
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
    cell.subtitle = expense.locationString ? expense.locationString : @"--";
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

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(8, 0, 5, 0);
}

#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView.contentOffset.y < - PULL_WIDTH) {
        self.expenseWindow = [[BYNewExpenseWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
        self.expenseWindow.windowLevel = UIWindowLevelAlert;
        self.expenseWindow.windowDelegate = self;
        self.expenseWindow.alpha = 0;
        [self.expenseWindow makeKeyAndVisible];
        [UIView animateWithDuration:0.5 animations:^{
            self.expenseWindow.alpha = 1;
        }];
    }
}
#pragma mark - Window Delegate

- (void)windowShouldDisappear:(BYNewExpenseWindow *)window
{
    [UIView animateWithDuration:0.5 animations:^{
        [(UIWindow*)self.view.superview makeKeyWindow];
        self.expenseWindow.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.expenseWindow = nil;
    }];
}

@end
