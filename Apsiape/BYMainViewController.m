//
//  BYMainViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BYMainViewController.h"
#import "BYCollectionView.h"
#import "BYStorage.h"
#import "BYExpenseViewController.h"
#import "BYContainerViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Expense.h"

@interface BYMainViewController () <UIScrollViewDelegate, BYCollectionViewDataSource, BYCollectionViewDelegate> {
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isLoading;
    BOOL isDragging;
}

@property (nonatomic, strong) NSArray *collectionViewData;

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

- (void)updateCollectionViewData {
    NSFetchRequest *fetchR = [NSFetchRequest fetchRequestWithEntityName:@"Expense"];
    NSManagedObjectContext *context = [[BYStorage sharedStorage] managedObjectContext];
    NSError *error;
    self.collectionViewData = [context executeFetchRequest:fetchR error:&error];
    [self.customCollectionView loadCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    self.customCollectionView = [[BYCollectionView alloc]initWithFrame:self.view.bounds];
    self.customCollectionView.collectionViewDataSource = self;
    self.customCollectionView.collectionViewDelegate = self;
    self.customCollectionView.delegate = self;
    self.customCollectionView.autoresizesSubviews = YES;
    self.customCollectionView.alwaysBounceHorizontal = YES;
    self.customCollectionView.alwaysBounceVertical = YES;
    self.customCollectionView.directionalLockEnabled = YES;
    
    [self.view addSubview:self.customCollectionView];
}

- (UIView *)collectionView:(BYCollectionView *)collectionView cellAtIndex:(NSInteger)index
{
    BYCollectionViewCell *cell = [[BYCollectionViewCell alloc]initWithFrame:[collectionView frameForCellAtIndex:index] index:index];
    Expense *expense = self.collectionViewData[index];
    cell.title = expense.value;
    cell.image = expense.image;
    return cell;
}

- (NSInteger)numberOfCellsInCollectionView {
    return self.collectionViewData.count;
}

- (CGFloat)heightForCellsInCollectionView {
    return 120;
}

- (void)collectionView:(BYCollectionView *)collectionView cellDidDetectedTapGesture:(BYCollectionViewCell *)cell atIndex:(NSInteger)index {
    
}

//----------------------------------------------------------------------Pull control implementation------------------------------------------------------------------------//

#define PULL_WIDTH 80

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.x > PULL_WIDTH && scrollView.contentOffset.x > 0) {
        //
    } else if (scrollView.contentOffset.x < - PULL_WIDTH && scrollView.contentOffset.x < 0) {
        [[BYContainerViewController sharedContainerViewController] displayExpenseCreationViewController];
    }
}

@end
