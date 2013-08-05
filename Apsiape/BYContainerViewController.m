//
//  BYContainerViewController.m
//  Apsiape
//
//  Created by Dario Lass on 05.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYContainerViewController.h"
#import "BYCollectionViewController.h"
#import "BYMapViewController.h"
#import "BYPreferencesViewController.h"

@interface BYContainerViewController ()

@property (nonatomic, strong) BYCollectionViewController *collectionViewController;
@property (nonatomic, strong) BYMapViewController *mapViewController;

@end

@implementation BYContainerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        if (!self.collectionViewController) self.collectionViewController = [[BYCollectionViewController alloc]initWithNibName:nil bundle:nil];
        if (!self.mapViewController) self.mapViewController = [[BYMapViewController alloc]initWithNibName:nil bundle:nil];
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
}

- (void)viewDidAppear:(BOOL)animated
{
    // animate the collectionViewController's view fading in
    [self.collectionViewController willMoveToParentViewController:self];
    [self addChildViewController:self.collectionViewController];
    self.collectionViewController.view.frame = self.view.bounds;
    self.collectionViewController.view.alpha = 0;
    [self.view addSubview:self.collectionViewController.view];
    [UIView animateWithDuration:0.4 animations:^{
        self.collectionViewController.view.alpha = 1;
    } completion:^(BOOL finished) {
        [self.collectionViewController didMoveToParentViewController:self];
    }];
    // -- -- --
    
    
}

@end
