//
//  BYAddPhotoViewController.m
//  Apsiape
//
//  Created by Dario Lass on 07.04.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYAddPhotoViewController.h"
#import "BYQuickShotView.h"

@interface BYAddPhotoViewController ()

@property (nonatomic, strong) BYQuickShotView *quickShotView;

@end

#define QUICKSHOTVIEW_INSET 10

@implementation BYAddPhotoViewController

- (BYQuickShotView *)quickShotView {
    if (!_quickShotView) _quickShotView = [[BYQuickShotView alloc]init];
    return _quickShotView;
}

- (void)viewWillAppear:(BOOL)animated {
    self.quickShotView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    [self.view addSubview:self.quickShotView];
}

@end
