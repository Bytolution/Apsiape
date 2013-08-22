//
//  BYExpenseCreationViewController.h
//  Apsiape
//
//  Created by Dario Lass on 28.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYExpenseCreationViewController;

@protocol BYExpenseCreationViewControllerDelegate <NSObject>

- (void)windowShouldDisappear:(BYExpenseCreationViewController*)window;

@end

@interface BYExpenseCreationViewController : UIViewController

@property (nonatomic, strong) id <BYExpenseCreationViewControllerDelegate> windowDelegate;

@end
