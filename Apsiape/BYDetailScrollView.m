//
//  BYDetailScrollView.m
//  Apsiape
//
//  Created by Dario Lass on 26.09.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYDetailScrollView.h"
#import "Expense.h"
#import <MapKit/MapKit.h>

@interface BYDetailScrollView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *deleteButton;
@property (nonatomic, strong) UIView *deleteButtonBackgroundView;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *valueLabel;
@property (nonatomic, strong) UIView *valueLabelBackgroundView;
@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic, strong) UILabel *geostringLabel;

@end

@implementation BYDetailScrollView

#define HEADER_LABEL_HEIGHT 100
#define LABEL_HEIGHT 50

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        if (!self.imageView) self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        if (!self.mapView) self.mapView = [[MKMapView alloc]initWithFrame:CGRectZero];
        if (!self.valueLabel) self.valueLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        if (!self.valueLabelBackgroundView) self.valueLabelBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];
        if (!self.timestampLabel) self.timestampLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        if (!self.geostringLabel) self.geostringLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        if (!self.deleteButton) self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!self.deleteButtonBackgroundView) self.deleteButtonBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];
        //        [self.view addSubview:self.valueLabelBackgroundView];
        [self.valueLabelBackgroundView addSubview:self.valueLabel];
        [self addSubview:self.imageView];
        [self addSubview:self.mapView];
        [self addSubview:self.timestampLabel];
        [self addSubview:self.geostringLabel];
        [self addSubview:self.deleteButtonBackgroundView];
        [self.deleteButtonBackgroundView addSubview:self.deleteButton];
    }
    return self;
}

- (void)didMoveToSuperview
{
    self.valueLabelBackgroundView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), HEADER_LABEL_HEIGHT);
    self.valueLabelBackgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.94];
    self.valueLabel.frame = CGRectMake(10, 20, CGRectGetWidth(self.frame) - 20, HEADER_LABEL_HEIGHT - 20);
    self.valueLabel.font = [UIFont fontWithName:@"Miso" size:50];
    self.valueLabel.textAlignment = NSTextAlignmentRight;
    self.valueLabel.backgroundColor = [UIColor clearColor];
    self.valueLabel.textColor = [UIColor blackColor];
    
    self.imageView.frame = CGRectMake(0, LABEL_HEIGHT, 320, 300);
    
    self.mapView.frame = CGRectMake(0, CGRectGetHeight(self.imageView.frame) + (2 * LABEL_HEIGHT), CGRectGetWidth(self.frame), 300);
    self.mapView.userInteractionEnabled = NO;

    self.backgroundColor = [UIColor greenColor];
    self.contentSize = CGSizeMake(CGRectGetWidth(self.frame), CGRectGetHeight(self.imageView.frame) + CGRectGetHeight(self.mapView.frame) + (2 * LABEL_HEIGHT) + 140);
    self.contentInset = UIEdgeInsetsMake(100, 0, 0, 0);
    self.contentOffset = CGPointMake(0, - HEADER_LABEL_HEIGHT + 20);
    
    self.geostringLabel.frame = CGRectMake(0, CGRectGetHeight(self.imageView.frame) + LABEL_HEIGHT, CGRectGetWidth(self.frame) - 10, LABEL_HEIGHT);
    self.geostringLabel.textAlignment = NSTextAlignmentCenter;
    self.timestampLabel.textAlignment = NSTextAlignmentCenter;
    
    self.timestampLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame) - 10, LABEL_HEIGHT);
    
    self.deleteButton.frame = CGRectMake(0, 0, 320, 80);
    [self.deleteButton setTitle:@"Delete?" forState:UIControlStateNormal];
    self.deleteButton.titleLabel.font = [UIFont fontWithName:@"Avenir-Light" size:32];
    self.deleteButton.backgroundColor = [UIColor clearColor];
    self.deleteButton.titleLabel.textColor = [UIColor whiteColor];
    self.deleteButtonBackgroundView.frame = CGRectMake(0, self.contentSize.height - 80, 320, 500);
    self.deleteButtonBackgroundView.backgroundColor = [UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:.5];
    
    self.panGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)setExpense:(Expense *)expense
{
    _expense = expense;
    NSLog(@"%s (%@)", __PRETTY_FUNCTION__, expense);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.timeStyle = NSDateFormatterShortStyle;
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    NSString *dateString = [dateFormatter stringFromDate:self.expense.date];
    self.timestampLabel.text = dateString;
    
    self.geostringLabel.text = self.expense.locationString;
    
    self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@screen.jpg", self.expense.baseFilePath]]];
    
    self.valueLabel.text = self.expense.stringValue;
}

@end
