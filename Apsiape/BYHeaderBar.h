//
//  BYHeaderBar.h
//  Apsiape
//
//  Created by Dario Lass on 17.04.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BYHeaderBar : UIViewController

@property (nonatomic, strong) UIView *backgroundView;

- (void)addSubheaderWithTitle:(NSString*)title;

@end
