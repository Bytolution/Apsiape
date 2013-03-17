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

@interface BYMainViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) BYCollectionView *customCollectionView;

@end


@implementation BYMainViewController

- (void)viewDidLoad
{
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor greenColor];
    self.collectionView.frame = self.view.bounds;
    self.customCollectionView = [[BYCollectionView alloc]initWithFrame:self.view.bounds];
    self.customCollectionView.dataSource = self;
    self.customCollectionView.backgroundColor = [UIColor greenColor];
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

@end
