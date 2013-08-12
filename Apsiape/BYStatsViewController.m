//
//  BYStatsViewController.m
//  Apsiape
//
//  Created by Dario Lass on 14.07.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYStatsViewController.h"
#import "BYStatsView.h"

@interface BYStatsViewController ()

@end

@implementation BYStatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view addSubview:[[BYStatsView alloc] initWithFrame:self.view.bounds]];
}

- (void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
