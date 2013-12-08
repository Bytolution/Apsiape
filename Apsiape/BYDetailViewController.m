//
//  BYDetailViewController.m
//  Apsiape
//
//  Created by Dario Lass on 26.10.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "BYDetailViewController.h"
#import "Expense.h"
#import "BYMapViewController.h"
#import "BYStorage.h"
#import "UIColor+Colours.h"
#import "BYMapAnnotation.h"
#import "Constants.h"

@interface BYDetailViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UISwipeGestureRecognizer *swipeGestureRecognizer;
@property (nonatomic, strong) UILabel *amountLabel;
@property (nonatomic, strong) UIView *amountLabelBackgroundView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *locationLabel;
@property (nonatomic, strong) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIButton *backButton;

- (void)swipeRecognized:(UISwipeGestureRecognizer*)swipeGestureRecognizer;
- (void)tapGestureRecognized:(UITapGestureRecognizer*)tapGestureRecognizer;
- (void)deleteButtonTapped:(UIButton*)button;
- (void)backButtonTapped:(UIButton*)button;

@end

@implementation BYDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //Initializers
        if (!self.scrollView) self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectZero];
        if (!self.amountLabel) self.amountLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        if (!self.amountLabelBackgroundView) self.amountLabelBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];
        if (!self.swipeGestureRecognizer) self.swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(swipeRecognized:)];
        if (!self.tapGestureRecognizer) self.tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapGestureRecognized:)];
        if (!self.imageView) self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        if (!self.mapView) self.mapView = [[MKMapView alloc]initWithFrame:CGRectZero];
        if (!self.locationLabel) self.locationLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        if (!self.timeLabel) self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        if (!self.deleteButton) self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!self.backButton) self.backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //Add subviews + gesture recognizers
        [self.view addSubview:self.amountLabelBackgroundView];
        [self.amountLabelBackgroundView addSubview:self.amountLabel];
        [self.amountLabelBackgroundView addSubview:self.backButton];
        [self.view insertSubview:self.scrollView belowSubview:self.amountLabelBackgroundView];
        [self.scrollView addSubview:self.imageView];
        [self.scrollView addSubview:self.mapView];
        [self.scrollView addSubview:self.timeLabel];
        [self.scrollView addSubview:self.locationLabel];
        [self.scrollView addSubview:self.deleteButton];
        [self.view addGestureRecognizer:self.swipeGestureRecognizer];
        [self.scrollView addGestureRecognizer:self.tapGestureRecognizer];
        //Misc
    }
    return self;
}

#define INSET_Label 10
#define INSET_IMAGES 0

- (void)viewWillAppear:(BOOL)animated
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    
    self.navigationController.navigationBarHidden = YES;
    
    self.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    self.amountLabel.text = self.expense.stringValue;
    self.amountLabel.textAlignment = NSTextAlignmentRight;
    self.amountLabel.font = [UIFont fontWithName:@"Miso-Light" size:50];
    
    self.amountLabelBackgroundView.frame = CGRectMake(0, 0, 320, 80);
    self.amountLabel.frame = CGRectMake(50, 0, 260, 80);
    self.amountLabel.backgroundColor = [UIColor clearColor];
    self.amountLabelBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    CALayer *strokeLayer = [CALayer layer];
    strokeLayer.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.2].CGColor;
    strokeLayer.frame = CGRectMake(0, CGRectGetHeight(self.amountLabelBackgroundView.frame)-1, CGRectGetWidth(self.amountLabelBackgroundView.frame), 1);
    [self.amountLabelBackgroundView.layer addSublayer:strokeLayer];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterLongStyle;
    NSString *dateString = [dateFormatter stringFromDate:self.expense.date];
    
    self.timeLabel.frame = CGRectMake(INSET_Label, 10, 320 - (2*INSET_Label), 30);
    self.timeLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:16];
    self.timeLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.text = dateString;
    
    self.locationLabel.frame = CGRectMake(10, 40, 320 - (2*INSET_Label), 30);
    self.locationLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:16];
    self.locationLabel.textColor = [UIColor colorWithWhite:0.4 alpha:1];
    self.locationLabel.textAlignment = NSTextAlignmentRight;
    if (self.expense.locationString) {
        self.locationLabel.text = self.expense.locationString;
    } else {
        self.locationLabel.text = @"- - -";
    }
    
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(320, 680);
    self.scrollView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.amountLabelBackgroundView.frame), 0, 0, 0);
    self.imageView.frame = CGRectMake(INSET_IMAGES, 80, 320 - (2*INSET_IMAGES), 300);
    self.mapView.frame = CGRectMake(INSET_IMAGES, 390, 320 - (2*INSET_IMAGES), 200);
    self.mapView.scrollEnabled = NO;
    self.mapView.zoomEnabled = NO;
    
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@screen.jpg", self.expense.baseFilePath]]];
    self.imageView.backgroundColor = [UIColor lightGrayColor];
    
    self.deleteButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:30];
    self.deleteButton.frame = CGRectMake(10, 600, 320 - (2*10), 70);
    [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    self.deleteButton.backgroundColor = [UIColor salmonColor];
    self.deleteButton.layer.cornerRadius = 4;
    [self.deleteButton addTarget:self action:@selector(deleteButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    self.backButton.frame = CGRectMake(10, 20, 40, 40);
    [self.backButton setImage:[UIImage imageNamed:BYApsiapeLeftArrowImageName] forState:UIControlStateNormal];
    [self.backButton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.scrollView setContentOffset:CGPointMake(0, - self.scrollView.contentInset.top) animated:NO];
    
    // Map stuff
    
    CLLocation *location = [NSKeyedUnarchiver unarchiveObjectWithData:self.expense.location];
    
    BYMapAnnotation *annotation = [[BYMapAnnotation alloc]init];
    annotation.coordinates = location.coordinate;
    
    if (location.coordinate.longitude != 0.0 && location.coordinate.latitude != 0.0) {
        [self.mapView addAnnotation:annotation];
        
        MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, 500, 500);
        MKCoordinateRegion adjustedRegion = [self.mapView regionThatFits:viewRegion];
        [self.mapView setRegion:adjustedRegion animated:NO];
    } else {
        self.tapGestureRecognizer.enabled = NO;
    }
}

- (void)tapGestureRecognized:(UITapGestureRecognizer *)tapGestureRecognizer
{
    CGPoint tapPoint = [tapGestureRecognizer locationInView:tapGestureRecognizer.view];
    if (tapGestureRecognizer.state == UIGestureRecognizerStateEnded && CGRectContainsPoint(self.mapView.frame, tapPoint)) {
        BYMapViewController *mapVC = [[BYMapViewController alloc]initWithNibName:nil bundle:nil];
        mapVC.expense = self.expense;
        [self.navigationController pushViewController:mapVC animated:YES];
    }
}

- (void)deleteButtonTapped:(UIButton *)button
{
    
    [[BYStorage sharedStorage] deleteExpenseObject:self.expense completion:^{
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

- (void)backButtonTapped:(UIButton *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)swipeRecognized:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
