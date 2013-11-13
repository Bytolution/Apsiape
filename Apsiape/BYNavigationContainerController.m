//
//  BYNavigationContainerController.m
//  Apsiape
//
//  Created by Dario Lass on 03.11.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "BYNavigationContainerController.h"
#import "BYPreferencesViewController.h"
#import "BYPreferencesNavigationController.h"
#import "Constants.h"

@interface BYNavigationContainerController ()

@property (nonatomic, strong) BYPreferencesViewController *embeddedNCRootVC;
@property (nonatomic, strong) BYPreferencesNavigationController *embeddedNC;

@end

@implementation BYNavigationContainerController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (!self.embeddedNCRootVC) self.embeddedNCRootVC = [[BYPreferencesViewController alloc]initWithNibName:nil bundle:nil];
        if (!self.embeddedNC) self.embeddedNC = [[BYPreferencesNavigationController alloc]initWithRootViewController:self.embeddedNCRootVC];
        self.view.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    UIView *embedView = [[UIView alloc]initWithFrame:CGRectInset(self.view.bounds, POPOVER_INSET_X, POPOVER_INSET_Y)];
    embedView.clipsToBounds = YES;
    [embedView addSubview:self.embeddedNC.view];
    self.embeddedNC.view.frame = embedView.bounds;
    [self.view addSubview:embedView];
}

@end
