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
#import "BYPullScrollView.h"

@interface BYNewExpenseViewController () <BYQuickShotViewDelegate, BYExpenseKeyboardDelegate, BYPullScrollViewDelegate>

@property (nonatomic, strong) UINavigationBar *headerBar;
@property (nonatomic, strong) UIImage *capturedPhoto;
@property (nonatomic, strong) BYQuickShotView *quickShotView;
@property (nonatomic, strong) NSMutableString *expenseValue;
@property (nonatomic, strong) BYCursorLabel *expenseValueLabel;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIScrollView *pagingScrollView;
@property (nonatomic, strong) MKMapView *mapView;

- (void)dismiss;

@end

@implementation BYNewExpenseViewController

#define KEYBOARD_HEIGHT 240

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor blackColor];
        
    BYPullScrollView *pullScrollView = [[BYPullScrollView alloc]initWithFrame:self.view.bounds];
    pullScrollView.pullScrollViewDelegate = self;
    
    [self.view addSubview:pullScrollView];
    self.expenseValue = [[NSMutableString alloc]initWithCapacity:30];
    BYExpenseKeyboard *keyboard = [[BYExpenseKeyboard alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - KEYBOARD_HEIGHT, 320, KEYBOARD_HEIGHT)];
    self.expenseValueLabel = [[BYCursorLabel alloc]initWithFrame:CGRectMake(10, 10, 300, 80)];
    [pullScrollView.childScrollView addSubview:self.expenseValueLabel];
    keyboard.delegate = self;
    [pullScrollView.childScrollView addSubview:keyboard];
    
    self.quickShotView = [[BYQuickShotView alloc]initWithFrame:CGRectMake(320, 0, pullScrollView.childScrollView.frame.size.width, pullScrollView.childScrollView.frame.size.height)];
    self.quickShotView.delegate = self;
    [pullScrollView.childScrollView addSubview:self.quickShotView];
    
    if (!self.mapView) self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(pullScrollView.childScrollView.contentSize.width * (2.0f/3.0f), 0, pullScrollView.childScrollView.bounds.size.width, pullScrollView.childScrollView.bounds.size.height)];
    self.mapView.showsUserLocation = YES;
    self.mapView.userInteractionEnabled = NO;
    [pullScrollView.childScrollView addSubview:self.mapView];
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

#pragma mark Delegation (QuickShotView)

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

#pragma mark Delegation (PullScrollView)

- (void)pullScrollView:(UIScrollView *)pullScrollView didDetectPullingAtEdge:(BYPullScrollViewEdgeType)edge
{
    NSLog(@"Edge pulled");
    [UIView animateWithDuration:0.5 animations:^{
        self.view.alpha = 0;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}
- (void)pullScrollView:(UIScrollView *)pullScrollView didScrollToPage:(NSInteger)page
{
    
}

@end
