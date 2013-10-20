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
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet MKMapView *mapView;
@property (nonatomic, strong) UILabel *timestampLabel;
@property (nonatomic, strong) UILabel *geostringLabel;

@end

@implementation BYDetailScrollView

#define HEADER_LABEL_HEIGHT 100
#define LABEL_HEIGHT 50

- (id)initWithFrame:(CGRect)frame
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"DetailScrollView" owner:self options:nil]lastObject];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [[NSBundle mainBundle] loadNibNamed:@"DetailScrollView" owner:self options:nil];
        
//        if (!self.imageView) self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
//        if (!self.mapView) self.mapView = [[MKMapView alloc]initWithFrame:CGRectZero];
        if (!self.timestampLabel) self.timestampLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        if (!self.geostringLabel) self.geostringLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        if (!self.deleteButton) self.deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if (!self.deleteButtonBackgroundView) self.deleteButtonBackgroundView = [[UIView alloc]initWithFrame:CGRectZero];

//        [self addSubview:self.imageView];
//        [self addSubview:self.mapView];
//        [self addSubview:self.timestampLabel];
//        [self addSubview:self.geostringLabel];
//        [self addSubview:self.deleteButtonBackgroundView];
//        [self.deleteButtonBackgroundView addSubview:self.deleteButton];
    }
    return self;
}

- (void)didMoveToSuperview
{
//    self.imageView.frame = CGRectMake(0, 0, 320, 300);
    
//    self.mapView.frame = CGRectMake(0, CGRectGetHeight(self.imageView.frame) + (2 * LABEL_HEIGHT), CGRectGetWidth(self.frame), 300);
    self.mapView.userInteractionEnabled = NO;

    self.contentOffset = CGPointMake(0, 100);
    
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
    self.deleteButtonBackgroundView.backgroundColor = [UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:.7];
    
    self.panGestureRecognizer.delegate = self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)setExpense:(Expense *)expense
{
    if (expense) {
        _expense = expense;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        NSString *dateString = [dateFormatter stringFromDate:self.expense.date];
        self.imageView.hidden = NO;
        self.mapView.hidden = NO;
        self.timestampLabel.hidden = NO;
        self.geostringLabel.hidden = NO;
        
        self.timestampLabel.text = dateString;
        
        self.geostringLabel.text = self.expense.locationString;
        
        self.imageView.image = [UIImage imageWithData:[NSData dataWithContentsOfFile:[NSString stringWithFormat:@"%@screen.jpg", self.expense.baseFilePath]]];
    } else {
        self.imageView.image = nil;
        self.imageView.hidden = YES;
        self.mapView.hidden = YES;
        self.timestampLabel.hidden = YES;
        self.geostringLabel.hidden = YES;
    }
}

@end
