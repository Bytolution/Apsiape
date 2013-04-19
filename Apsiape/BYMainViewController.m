//
//  BYMainViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "BYMainViewController.h"
#import "BYStorage.h"
#import "InterfaceConstants.h"
#import "BYCollectionViewCell.h"
#import "BYExpenseViewController.h"
#import "BYContainerViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface BYMainViewController () <UIScrollViewDelegate> {
    UIView *refreshHeaderView;
    UILabel *refreshLabel;
    UIImageView *refreshArrow;
    UIActivityIndicatorView *refreshSpinner;
    BOOL isLoading;
    BOOL isDragging;
}

@property (nonatomic, strong) BYCollectionView *customCollectionView;
@property (nonatomic, strong) NSArray *collectionViewData;

- (void)updateCollectionViewData;

@end

#define REFRESH_HEADER_HEIGHT 50

@implementation BYMainViewController

- (void)updateCollectionViewData {
    NSFetchRequest *fetchR = [NSFetchRequest fetchRequestWithEntityName:@"Expense"];
    NSManagedObjectContext *context = [[BYStorage sharedStorage] managedObjectContext];
    NSError *error;
    self.collectionViewData = [context executeFetchRequest:fetchR error:&error];
    [self.customCollectionView loadCollectionView];
}

- (void)viewWillAppear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCollectionViewData) name:UIDocumentStateChangedNotification object:nil];
    
    self.customCollectionView = [[BYCollectionView alloc]initWithFrame:self.view.bounds];
    self.customCollectionView.collectionViewDataSource = self;
    self.customCollectionView.collectionViewDelegate = self;
    self.customCollectionView.delegate = self;
    [self.view addSubview:self.customCollectionView];
    
    [self addPullToRefreshHeader];
}


- (UIView *)collectionView:(BYCollectionView *)collectionView cellAtIndex:(NSInteger)index {
    BYCollectionViewCell *cell = [[BYCollectionViewCell alloc]initWithFrame:[collectionView frameForCellAtIndex:index] cellAttributes:@{@"title" : @"text"} index:index];
    return cell;
}

- (NSInteger)numberOfCellsInCollectionView {
    return self.collectionViewData.count;
}

- (CGFloat)heightForCellsInCollectionView {
    return CELL_HEIGHT;
}

- (void)collectionView:(BYCollectionView *)collectionView cellDidDetectedTapGesture:(BYCollectionViewCell *)cell atIndex:(NSInteger)index {
    
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------//


- (void)addPullToRefreshHeader {
    refreshHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 - REFRESH_HEADER_HEIGHT, 320, REFRESH_HEADER_HEIGHT)];
    refreshHeaderView.backgroundColor = [UIColor clearColor];
    
    refreshArrow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"add.png"]];
    refreshArrow.frame = CGRectMake(0,0,50,50);
    CGPoint center = CGPointMake(CGRectGetMidX(refreshHeaderView.bounds), CGRectGetMidY(refreshHeaderView.bounds));
    refreshArrow.center = center;
    [refreshHeaderView addSubview:refreshArrow];

    [self.customCollectionView addSubview:refreshHeaderView];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (isLoading) return;
    isDragging = YES;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (isLoading) {
        // Update the content inset, good for section headers
        if (scrollView.contentOffset.y > 0)
            self.customCollectionView.contentInset = UIEdgeInsetsZero;
        else if (scrollView.contentOffset.y >= -REFRESH_HEADER_HEIGHT)
            self.customCollectionView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    } else if (isDragging && scrollView.contentOffset.y < 0) {
        // Update the arrow direction and label
        [UIView animateWithDuration:0.25 animations:^{
            if (scrollView.contentOffset.y < -REFRESH_HEADER_HEIGHT) {
                // User is scrolling above the header
                refreshLabel.text = @"Rang dang";
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI, 0, 0, 1);
            } else {
                // User is scrolling somewhere within the header
                refreshLabel.text = @"Ring ding";
                [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
            }
        }];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (isLoading) return;
    isDragging = NO;
    if (scrollView.contentOffset.y <= -REFRESH_HEADER_HEIGHT) {
        // Released above the header
        [self startLoading];
    }
}

- (void)startLoading {
    isLoading = YES;
    
    // Show the header
    [UIView animateWithDuration:0.3 animations:^{
        self.customCollectionView.contentInset = UIEdgeInsetsMake(REFRESH_HEADER_HEIGHT, 0, 0, 0);
        refreshLabel.text = @"Liblab loading";
        refreshArrow.hidden = YES;
        [refreshSpinner startAnimating];
    }];
    
    // Refresh action!
    [self refresh];
}

- (void)stopLoading {
    isLoading = NO;
    
    // Hide the header
    [UIView animateWithDuration:0.3 animations:^{
        self.customCollectionView.contentInset = UIEdgeInsetsZero;
        [refreshArrow layer].transform = CATransform3DMakeRotation(M_PI * 2, 0, 0, 1);
    }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(stopLoadingComplete)];
                     }];
}

- (void)stopLoadingComplete {
    // Reset the header
    refreshLabel.text = @"Rang dang";
    refreshArrow.hidden = NO;
    [refreshSpinner stopAnimating];
}

- (void)refresh {
    BYContainerViewController *conViewCon = [BYContainerViewController sharedContainerViewController];
    [conViewCon displayDetailViewController:[[BYExpenseViewController alloc]init] withAnimationParameters:nil];
    
    [self performSelector:@selector(stopLoading) withObject:nil afterDelay:2.0];
}


@end
