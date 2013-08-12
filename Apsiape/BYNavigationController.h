//
//  BYNavigationController.h
//  Apsiape
//
//  Created by Dario Lass on 05.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYViewController;

@interface BYNavigationController : UIViewController

- (void)pushViewController:(BYViewController*)viewController animated:(BOOL)animated;
- (void)popCurrentlyVisibleViewControllerAnimated:(BOOL)animated;

@end
