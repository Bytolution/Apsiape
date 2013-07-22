//
//  BYNewExpenseWindow.h
//  Apsiape
//
//  Created by Dario Lass on 28.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYNewExpenseWindow;

@protocol BYNewExpenseWindowDelegate <NSObject>

- (void)windowShouldDisappear:(BYNewExpenseWindow*)window;

@end

@interface BYNewExpenseWindow : UIWindow

@property (nonatomic, strong) id <BYNewExpenseWindowDelegate> windowDelegate;

@end
