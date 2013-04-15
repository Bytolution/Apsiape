//
//  BYAddLocationViewController.m
//  Apsiape
//
//  Created by Dario Lass on 07.04.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYAddLocationViewController.h"
#import "BYLocationTagView.h"
#import "BYLocator.h"

@interface BYAddLocationViewController ()

@property (nonatomic, strong) BYLocationTagView *locationTagView;
@property (nonatomic, strong) BYLocator *locator;

- (void)locationTagViewTapped;

@end



@implementation BYAddLocationViewController

- (BYLocationTagView *)locationTagView {
    if (!_locationTagView) _locationTagView = [[BYLocationTagView alloc]init];
    return _locationTagView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationTagViewTapped)];
        [self.locationTagView addGestureRecognizer:tgr];
    }
    return self;
}

- (NSData *)locationData {
    return [NSKeyedArchiver archivedDataWithRootObject:self.locator.latestLocationMeasurement];
}

#define DegreesToRadians(x) ((x) * M_PI / 180.0)
#define LOCTAG_HEIGHT 200
#define LOCTAG_WIDTH 200

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.locationTagView.userInteractionEnabled = YES;
    self.locationTagView.frame = CGRectMake(50, 80, LOCTAG_WIDTH, LOCTAG_HEIGHT);
    self.locationTagView.bounds = CGRectMake(0, 0, LOCTAG_WIDTH, LOCTAG_HEIGHT);
    CGAffineTransform transform = CGAffineTransformMakeRotation(DegreesToRadians(-10));
    self.locationTagView.transform = transform;
    [self.view addSubview:self.locationTagView];
    
    if (!self.locator) self.locator = [[BYLocator alloc]init];
    [self.locator startLocatingWithTimeout:30];
}

- (void)locationTagViewTapped {
    [UIView animateWithDuration:.2 delay:0 options:kNilOptions animations:^{
        self.locationTagView.transform = CGAffineTransformMakeScale(.9, .9);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            self.locationTagView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    }];
}

@end
