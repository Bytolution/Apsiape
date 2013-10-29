//
//  BYDetailViewController.m
//  Apsiape
//
//  Created by Dario Lass on 26.10.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

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
        //Add subviews + gesture recognizers
        [self.view addSubview:self.amountLabelBackgroundView];
        [self.amountLabelBackgroundView addSubview:self.amountLabel];
        [self.view insertSubview:self.scrollView belowSubview:self.amountLabelBackgroundView];
        [self.scrollView addSubview:self.imageView];
        [self.imageView addSubview:self.mapView];
        [self.view addGestureRecognizer:self.swipeGestureRecognizer];
        //Misc
        self.view.backgroundColor = [UIColor whiteColor];
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars = NO;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    self.swipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    self.amountLabel.text = self.expense.stringValue;
    self.amountLabel.textAlignment = NSTextAlignmentRight;
    
    self.amountLabelBackgroundView.frame = CGRectMake(0, 0, 320, 100);
    self.amountLabel.frame = CGRectInset(self.amountLabelBackgroundView.bounds, 20, 10);
    self.amountLabel.frame = CGRectOffset(self.amountLabel.frame, 0, 10);
    
    self.amountLabel.backgroundColor = [UIColor clearColor];
    self.amountLabelBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.95];
    
    self.scrollView.frame = self.view.bounds;
    self.scrollView.contentSize = CGSizeMake(320, 540);
    self.scrollView.contentInset = UIEdgeInsetsMake(CGRectGetHeight(self.amountLabelBackgroundView.frame), 0, 0, 0);
    self.imageView.frame = CGRectMake(10, 10, 300, 300);
    //???
    self.mapView.frame = CGRectMake(0, 310, 300, 200);
    
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@screen.jpg", self.expense.baseFilePath]]];
    self.imageView.backgroundColor = [UIColor lightGrayColor];
    
    [self.scrollView setContentOffset:CGPointMake(0, - self.scrollView.contentInset.top) animated:NO];
}

- (void)swipeRecognized:(UISwipeGestureRecognizer *)swipeGestureRecognizer
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
