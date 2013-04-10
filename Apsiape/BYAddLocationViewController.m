//
//  BYAddLocationViewController.m
//  Apsiape
//
//  Created by Dario Lass on 07.04.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYAddLocationViewController.h"
#import "BYLocationTagView.h"
#import <math.h>

@interface BYAddLocationViewController ()

@property (nonatomic, strong) BYLocationTagView *locationTagView;

@end

#define DegreesToRadians(x) ((x) * M_PI / 180.0)

@implementation BYAddLocationViewController

- (BYLocationTagView *)locationTagView {
    if (!_locationTagView) _locationTagView = [[BYLocationTagView alloc]init];
    return _locationTagView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define LOCTAG_HEIGHT 240
#define LOCTAG_WIDTH 240

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.locationTagView.frame = CGRectMake(40, 80, LOCTAG_WIDTH, LOCTAG_HEIGHT);
    self.locationTagView.bounds = CGRectMake(0, 0, LOCTAG_WIDTH, LOCTAG_HEIGHT);
    CGAffineTransform transform = CGAffineTransformMakeRotation(DegreesToRadians(340));
    self.locationTagView.transform = transform;
    [self.view addSubview:self.locationTagView];
}

@end
