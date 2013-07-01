//
//  BYNewExpenseViewController.m
//  Apsiape
//
//  Created by Dario Lass on 28.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import <MapKit/MapKit.h>
#import "BYNewExpenseViewController.h"
#import "BYQuickShotView.h"
#import "BYExpenseKeyboard.h"
#import "Expense.h"
#import "BYStorage.h"
#import "BYCursorLabel.h"

@interface BYNewExpenseViewController () <BYQuickShotViewDelegate, BYExpenseKeyboardDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UINavigationBar *headerBar;
@property (nonatomic, strong) UIImage *capturedPhoto;
@property (nonatomic, strong) BYQuickShotView *quickShotView;
@property (nonatomic, strong) NSMutableString *expenseValue;
@property (nonatomic, strong) BYCursorLabel *expenseValueLabel;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIScrollView *pagingScrollView;
@property (nonatomic, strong) MKMapView *mapView;

- (void)dismiss;
- (void)prepareScrollViews;

@end

@implementation BYNewExpenseViewController

#define KEYBOARD_HEIGHT 240

- (void)prepareScrollViews
{
    if (!self.mainScrollView) self.mainScrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    if (!self.pagingScrollView) self.pagingScrollView = [[UIScrollView alloc]initWithFrame:self.mainScrollView.bounds];
    
    self.pagingScrollView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:1];
    self.mainScrollView.frame = self.view.bounds;
    self.mainScrollView.contentSize = self.mainScrollView.frame.size;
    self.pagingScrollView.frame = self.mainScrollView.bounds;
    self.pagingScrollView.pagingEnabled = YES;
    self.pagingScrollView.contentSize = CGSizeMake(self.mainScrollView.frame.size.width * 3, self.mainScrollView.frame.size.height);
    self.pagingScrollView.showsHorizontalScrollIndicator = NO;
    self.mainScrollView.alwaysBounceVertical = YES;
    self.mainScrollView.delegate = self;
    [self.view addSubview:self.mainScrollView];
    [self.mainScrollView addSubview:self.pagingScrollView];
    self.mainScrollView.layer.cornerRadius = 10;
    self.mainScrollView.layer.masksToBounds = YES;
    
    UIColor *lightGreen = [UIColor colorWithRed:0.4 green:0.9 blue:0.4 alpha:1];
    UIColor *lightRed = [UIColor colorWithRed:0.9 green:0.4 blue:0.4 alpha:1];
    
    CGFloat pullViewHeight = 800;
    UIView *topPullView = [[UIView alloc]initWithFrame:CGRectMake(0, - pullViewHeight, self.mainScrollView.frame.size.width, pullViewHeight)];
    topPullView.backgroundColor = lightGreen;
    [self.mainScrollView addSubview:topPullView];
    UIView *bottomPullView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mainScrollView.contentSize.height, self.mainScrollView.frame.size.width, pullViewHeight)];
    bottomPullView.backgroundColor = lightRed;
    [self.mainScrollView addSubview:bottomPullView];
    UIView *rightPullView = [[UIView alloc]initWithFrame:CGRectMake(self.pagingScrollView.contentSize.width, 0, pullViewHeight, self.pagingScrollView.contentSize.height)];
    rightPullView.backgroundColor = lightGreen;
    [self.pagingScrollView addSubview:rightPullView];
    UIView *leftPullView = [[UIView alloc]initWithFrame:CGRectMake(- pullViewHeight, 0, pullViewHeight, self.pagingScrollView.contentSize.height)];
    leftPullView.backgroundColor = lightRed;
    [self.pagingScrollView addSubview:leftPullView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self prepareScrollViews];
    
    self.expenseValue = [[NSMutableString alloc]initWithCapacity:30];
    BYExpenseKeyboard *keyboard = [[BYExpenseKeyboard alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - KEYBOARD_HEIGHT, 320, KEYBOARD_HEIGHT)];
    self.expenseValueLabel = [[BYCursorLabel alloc]initWithFrame:CGRectMake(10, 10, 300, 80)];
    [self.pagingScrollView addSubview:self.expenseValueLabel];
    keyboard.delegate = self;
    [self.pagingScrollView addSubview:keyboard];
    
    self.quickShotView = [[BYQuickShotView alloc]initWithFrame:CGRectMake(320, 0, self.pagingScrollView.frame.size.width, self.pagingScrollView.frame.size.height)];
    self.quickShotView.delegate = self;
    [self.pagingScrollView addSubview:self.quickShotView];
    
    if (!self.mapView) self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(self.pagingScrollView.contentSize.width * (2.0f/3.0f), 0, self.pagingScrollView.bounds.size.width, self.pagingScrollView.bounds.size.height)];
    [self.pagingScrollView addSubview:self.mapView];
//    self.mapView.userInteractionEnabled = NO;
    self.mapView.showsUserLocation = YES;
    
    CGSize viewSize = self.mapView.frame.size;
    CGFloat borderHeight = ((viewSize.height-viewSize.width)/2);
    CALayer *topLayer = [CALayer layer];
    CALayer *bottomLayer = [CALayer layer];
    topLayer.frame = CGRectMake(0, 0, viewSize.width, borderHeight);
    bottomLayer.frame = CGRectMake(0, viewSize.height - borderHeight, viewSize.width, borderHeight);
    topLayer.backgroundColor = [UIColor whiteColor].CGColor;
    bottomLayer.backgroundColor = [UIColor whiteColor].CGColor;
    topLayer.opacity = 0.7;
    bottomLayer.opacity = 0.7;
    [self.mapView.layer addSublayer:topLayer];
    [self.mapView.layer addSublayer:bottomLayer];
    
    [self.mapView setCenterCoordinate:self.mapView.prop];
}

#pragma mark Text Input Handling

- (void)numberKeyTapped:(NSString *)numberString
{
    NSRange decSeparatorRange = [self.expenseValue rangeOfString:@"."];
    if (decSeparatorRange.length == 1) {
        if (decSeparatorRange.location < self.expenseValue.length - 2) return;
        if ([numberString isEqualToString:@"."]) return;
    }
    if (self.expenseValue.length == 7) return;
    
    [self.expenseValue appendString:numberString];
    self.expenseValueLabel.text = self.expenseValue;
}
- (void)deleteKeyTapped
{
    if (self.expenseValue.length < 1) {
        return;
    } else {
        NSRange range = NSMakeRange(self.expenseValue.length - 1, 1);
        [self.expenseValue deleteCharactersInRange:range];
    }
    self.expenseValueLabel.text = self.expenseValue;
}

#pragma mark Cleanup methods

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.expenseValue.length != 0) {
        Expense *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:[[BYStorage sharedStorage]managedObjectContext]];
        newExpense.value = self.expenseValue;
        newExpense.image = self.capturedPhoto;
        [[BYStorage sharedStorage]saveDocument];
    }
    self.capturedPhoto = nil;
    self.expenseValue = nil;
}
- (void)dismiss
{
    [self.view removeFromSuperview];
}

#pragma mark Delegation

- (void)didTakeSnapshot:(UIImage *)img
{
    self.capturedPhoto = img;
}
- (void)didDiscardLastImage
{
    self.capturedPhoto = nil;
}
- (void)quickShotViewDidFinishPreparation:(BYQuickShotView *)quickShotView
{
    
}

@end
