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

//- (UICollectionView *)collectionView {
//    if (!_collectionView) {
//        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
//        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
//        flowLayout.itemSize = CGSizeMake(CELL_WIDTH, CELL_HEIGHT);
//        flowLayout.minimumInteritemSpacing = 0;
//        flowLayout.minimumLineSpacing = 0;
//        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayout];
//        _collectionView.delegate = self;
//        _collectionView.dataSource = self;
//    }
//    return _collectionView;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    return 15;
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    BYCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    [cell setAttributes:nil index:indexPath.row];
//    return cell;
//}

- (void)viewDidLoad
{
//    [self.collectionView registerClass:[BYCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
//    self.collectionView.backgroundColor = [UIColor colorWithRed:0.37f green:0.37f blue:0.37f alpha:1.00f];
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor blueColor];
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
