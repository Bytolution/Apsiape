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

@interface BYMainViewController ()

@property (nonatomic, strong) BYCollectionView *customCollectionView;
@property (nonatomic, strong) NSArray *collectionViewData;

- (void)updateCollectionViewData;

@end


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
    [self.view addSubview:self.customCollectionView];
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
    BYContainerViewController *conViewCon = [BYContainerViewController sharedContainerViewController];
    [conViewCon displayDetailViewController:[[BYExpenseViewController alloc]init] withAnimationParameters:nil];
}

@end
