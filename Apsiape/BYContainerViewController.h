//
//  BYContainerViewController.h
//  Apsiape
//
//  Created by Dario Lass on 03.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

//@protocol BYContainerViewControllerDelegate <NSObject>
//
//
//
//@end

@interface BYContainerViewController : UIViewController

//@property (nonatomic, strong) id <BYContainerViewControllerDelegate> delegate;

+ (BYContainerViewController*)sharedContainerViewController;

- (void)displayExpenseCreationWindow;
- (void)dismissExpenseCreationWindow;

//- (void)displayMapView;
//- (void)dismissMapView;

@end
