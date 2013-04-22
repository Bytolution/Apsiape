//
//  BYContainerViewController.m
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYContainerViewController.h"
#import "BYMainViewController.h"

@interface BYContainerViewController ()

@property (nonatomic, strong) BYMainViewController *mainViewController;
@property (nonatomic, strong) UINavigationBar *navBar;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic) CGRect contentFrame;

@end

@implementation BYContainerViewController

#define HEADER_HEIGHT 44
#define FOOTER_HEIGHT 40

+ (BYContainerViewController *)sharedContainerViewController {
    static BYContainerViewController *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BYContainerViewController alloc] initWithNibName:nil bundle:nil];
        NSLog(@"SINGLETON: BYContainerViewController now exists.");
    });
    
    return sharedInstance;
}

- (BYMainViewController *)mainViewController {
    if (!_mainViewController) _mainViewController = [[BYMainViewController alloc]init];
    return _mainViewController; 
}

- (CGRect)contentFrame {
    CGRect rect = CGRectMake(0, HEADER_HEIGHT, self.view.bounds.size.width, self.view.bounds.size.height - (HEADER_HEIGHT + FOOTER_HEIGHT));
    return rect;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self addChildViewController:self.mainViewController];
    self.mainViewController.view.frame = CGRectMake(0, 44, self.view.bounds.size.width, self.view.bounds.size.height - 68);
    [self.view addSubview:self.mainViewController.view];
    [self.mainViewController didMoveToParentViewController:self];
    
    self.navBar = [[UINavigationBar alloc]initWithFrame:CGRectMake(0, 0, 320, HEADER_HEIGHT)];
    [self.view addSubview:self.navBar];
    self.toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - FOOTER_HEIGHT, 320, FOOTER_HEIGHT)];
    self.toolBar.tintColor = [UIColor darkGrayColor];
    [self.view addSubview:self.toolBar];
}

- (void)displayDetailViewController:(UIViewController*)detailViewController withAnimationParameters:(NSDictionary*)params {
    [self addChildViewController:detailViewController];
    detailViewController.view.frame = CGRectMake(-self.contentFrame.size.width, self.contentFrame.origin.y, self.contentFrame.size.width, self.contentFrame.size.height + FOOTER_HEIGHT);
    [self.view addSubview:detailViewController.view];
    [detailViewController didMoveToParentViewController:self];
    [UIView animateWithDuration:0.4 animations:^{
        detailViewController.view.frame = CGRectMake(0, self.contentFrame.origin.y, self.contentFrame.size.width, self.contentFrame.size.height + FOOTER_HEIGHT);
        self.mainViewController.view.frame = CGRectMake(self.contentFrame.size.width, self.contentFrame.origin.y, self.contentFrame.size.width, self.contentFrame.size.height);
        self.toolBar.frame = CGRectMake(320, self.view.frame.size.height - FOOTER_HEIGHT, 320, FOOTER_HEIGHT);
    }];
}

@end
