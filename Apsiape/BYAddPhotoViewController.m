//
//  BYAddPhotoViewController.m
//  Apsiape
//
//  Created by Dario Lass on 07.04.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYAddPhotoViewController.h"
#import "BYQuickShotView.h"

@interface BYAddPhotoViewController () <BYQuickShotViewDelegate>

@property (nonatomic, strong) BYQuickShotView *quickShotView;
@property (nonatomic, strong) UIImage *lastImageTaken;

@end

#define QUICKSHOTVIEW_INSET 10

@implementation BYAddPhotoViewController

- (BYQuickShotView *)quickShotView {
    if (!_quickShotView) _quickShotView = [[BYQuickShotView alloc]init];
    return _quickShotView;
}

- (UIImage *)capturedPhoto {
    return [self.lastImageTaken copy];
}

- (void)viewWillAppear:(BOOL)animated {
    self.quickShotView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width);
    self.quickShotView.delegate = self;
    [self.view addSubview:self.quickShotView];
}

- (void)didTakeSnapshot:(UIImage *)img {
    NSLog(@"%@", img);
    self.lastImageTaken = img;
}

- (void)didDiscardLastImage {
    self.lastImageTaken = nil;
}

@end
