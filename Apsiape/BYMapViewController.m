//
//  BYMapViewController.m
//  Apsiape
//
//  Created by Dario Lass on 05.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYMapViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "Expense.h"

@interface BYMapViewController () <MKAnnotation>

- (void)backButtonTapped:(UIButton*)button;

@end

@implementation BYMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor greenColor];
        if (!self.mapView) self.mapView = [[MKMapView alloc]initWithFrame:CGRectZero];
        [self.view addSubview:self.mapView];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mapView = nil;
}
- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.mapView = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(10, 10, 50, 50);
    button.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    [button setTitle:@"X" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:30];
    button.titleLabel.textColor = [UIColor blackColor];
    button.layer.cornerRadius = CGRectGetWidth(button.frame)/2;
    [button addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    [self.mapView addAnnotation:self];
    
    self.navigationController.navigationBarHidden = YES;
    self.mapView.frame = self.view.bounds;
}

- (void)backButtonTapped:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (CLLocationCoordinate2D)coordinate
{
    CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:self.expense.location];
    return location.coordinate;
}
- (NSString *)title
{
    return @"Test";
}

@end
