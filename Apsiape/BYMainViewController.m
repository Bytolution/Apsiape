//
//  BYMainViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYMainViewController.h"

@interface BYMainViewController ()

@property (nonatomic, strong) UICollectionView *collectionView;

@end

#define CELL_WIDTH  160
#define CELL_HEIGHT 120

@implementation BYMainViewController

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.itemSize = CGSizeMake(CELL_WIDTH, CELL_HEIGHT);
        flowLayout.minimumInteritemSpacing = 0;
        flowLayout.minimumLineSpacing = 0;
        _collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 16;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    #warning use subclass of UICollectionViewCell
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:1 - (0.05 * indexPath.row) green:0 blue:1 alpha:1];
    return cell;
}

- (void)viewDidLoad
{
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (void)viewWillAppear:(BOOL)animated {
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.collectionView];
    
}



@end
