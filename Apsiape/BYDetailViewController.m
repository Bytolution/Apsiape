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

- (void)swipeRecognized:(UISwipeGestureRecognizer*)swipeGestureRecognizer;

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
        if (!self.imageView) self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        if (!self.mapView) self.mapView = [[MKMapView alloc]initWithFrame:CGRectZero];
        if (!self.locationLabel) self.locationLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        if (!self.timeLabel) self.timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        if (!self.deleteButton) self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //Add subviews + gesture recognizers
        [self.view addSubview:self.amountLabelBackgroundView];
        [self.amountLabelBackgroundView addSubview:self.amountLabel];
        [self.view insertSubview:self.scrollView belowSubview:self.amountLabelBackgroundView];
        [self.scrollView addSubview:self.imageView];
        [self.scrollView addSubview:self.mapView];
        [self.scrollView addSubview:self.timeLabel];
        [self.scrollView addSubview:self.locationLabel];
        [self.scrollView addSubview:self.deleteButton];
        [self.view addGestureRecognizer:self.swipeGestureRecognizer];
        //Misc
        self.view.backgroundColor = [UIColor whiteColor];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    return self;
}

#define INSET_Label 10
#define INSET_IMAGES 0

- (void)viewWillAppear:(BOOL)animated
{
    self.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    self.amountLabel.text = self.expense.stringValue;
    self.amountLabel.textAlignment = NSTextAlignmentRight;
    self.amountLabel.font = [UIFont fontWithName:@"Miso-Bold" size:46];
    
    self.amountLabelBackgroundView.frame = CGRectMake(0, 0, 320, 100);
    self.amountLabel.frame = CGRectMake(50, 20, 260, 80);
    self.amountLabel.backgroundColor = [UIColor clearColor];
    self.amountLabelBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.9];
    
    CALayer *strokeLayer = [CALayer layer];
    strokeLayer.backgroundColor = [UIColor colorWithWhite:0.6 alpha:0.2].CGColor;
    strokeLayer.frame = CGRectMake(0, 99, 320, 1);
    [self.amountLabelBackgroundView.layer addSublayer:strokeLayer];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeStyle = NSDateFormatterNoStyle;
    dateFormatter.dateStyle = NSDateFormatterFullStyle;
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
    self.locationLabel.text = self.expense.locationString;
    
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(320, 680);
    self.scrollView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.amountLabelBackgroundView.frame), 0, 0, 0);
    self.imageView.frame = CGRectMake(INSET_IMAGES, 80, 320 - (2*INSET_IMAGES), 300);
    self.mapView.frame = CGRectMake(INSET_IMAGES, 390, 320 - (2*INSET_IMAGES), 200);
    self.mapView.userInteractionEnabled = NO;
    
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@screen.jpg", self.expense.baseFilePath]]];
    self.imageView.backgroundColor = [UIColor lightGrayColor];
    
    self.deleteButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:30];
    self.deleteButton.frame = CGRectMake(10, 600, 320 - (2*10), 70);
    [self.deleteButton setTitle:@"Delete" forState:UIControlStateNormal];
    self.deleteButton.backgroundColor = [UIColor colorWithRed:1 green:0.4 blue:0.35 alpha:1];
    self.deleteButton.layer.cornerRadius = 4;
    
    [self.scrollView setContentOffset:CGPointMake(0, - self.scrollView.contentInset.top) animated:NO];
}

- (void)swipeRecognized:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
