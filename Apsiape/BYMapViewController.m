//
//  BYMapViewController.m
//  Apsiape
//
//  Created by Dario Lass on 06.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYMapViewController.h"
#import <MapKit/MapKit.h>

@interface BYMapViewController ()

@property (nonatomic, strong) MKMapView *mapView;

@end

#define MAPVIEW_INSET 10

@implementation BYMapViewController

- (MKMapView *)mapView
{
    if (!_mapView) _mapView = [[MKMapView alloc]init];
    return _mapView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.mapView.frame = CGRectInset(self.view.bounds, MAPVIEW_INSET, MAPVIEW_INSET);
    [self.view addSubview:self.mapView];
}

@end
