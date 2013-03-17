//
//  BYMainViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYMainViewController.h"
#import "InterfaceConstants.h"
#import "BYCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@interface BYMainViewController ()

@property (nonatomic, strong) BYCollectionView *customCollectionView;

@end


@implementation BYMainViewController

- (void)viewWillAppear:(BOOL)animated {
    self.customCollectionView = [[BYCollectionView alloc]initWithFrame:self.view.bounds];
    self.customCollectionView.collectionViewDataSource = self;
    self.customCollectionView.collectionViewDelegate = self;
    [self.view addSubview:self.customCollectionView];
}

- (UIView *)collectionView:(BYCollectionView *)collectionView cellAtIndex:(NSInteger)index {
    BYCollectionViewCell *cell = [[BYCollectionViewCell alloc]initWithFrame:[collectionView frameForCellAtIndex:index] cellAttributes:nil index:index];
    return cell;
}

- (NSInteger)numberOfCellsInCollectionView {
    return 10;
}

- (CGFloat)heightForCellsInCollectionView {
    return CELL_HEIGHT;
}

- (void)collectionView:(BYCollectionView *)collectionView cellDidDetectedTapGesture:(BYCollectionViewCell *)cell atIndex:(NSInteger)index {
    NSLog(@"cell got tapped at index: %d", index);
    cell.backgroundColor = [UIColor lightGrayColor];
}

@end
