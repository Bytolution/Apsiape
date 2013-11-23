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
#import "BYStorage.h"
#import "BYMapAnnotation.h"

@interface BYMapViewController () <MKAnnotation>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) NSArray *mapAnnotations;

- (void)backButtonTapped:(UIButton*)button;

- (void)loadPins;

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

#pragma mark View Lifecycle

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
    
    [self loadPins];
    [self.mapView addAnnotations:self.mapAnnotations];
    
    self.navigationController.navigationBarHidden = YES;
    self.mapView.frame = self.view.bounds;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:self.expense.location];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 1000, 1000);
    MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
    [self.mapView setRegion:adjustedRegion animated:YES];
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

#pragma mark Dismiss

- (void)backButtonTapped:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Data

- (void)loadPins
{
    NSFetchRequest *fetchR = [NSFetchRequest fetchRequestWithEntityName:@"Expense"];
    NSManagedObjectContext *context = [[BYStorage sharedStorage] managedObjectContext];
    NSError *error;
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]initWithKey:@"date" ascending:NO];
    fetchR.sortDescriptors = @[sortDescriptor];
    NSArray *expenseArray = [[context executeFetchRequest:fetchR error:&error] mutableCopy];
    
    NSMutableArray *mutablePinsArray = [[NSMutableArray alloc]initWithCapacity:expenseArray.count];
    
    for (Expense *expense in expenseArray) {
        BYMapAnnotation *annotation = [[BYMapAnnotation alloc]init];
        CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:expense.location];
        annotation.coordinates = location.coordinate;
        annotation.annotationTitle = expense.stringValue;
        [mutablePinsArray addObject:annotation];
    }
    
    self.mapAnnotations = [mutablePinsArray copy];
}

@end
