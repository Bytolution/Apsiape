//
//  BYNavigationBar.h
//  Apsiape
//
//  Created by Dario Lass on 08.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BYNavigationBarDelegate <NSObject>

- (void)leftButtonTapped;

@end

@interface BYNavigationBar : UIView

@property (nonatomic, strong) id <BYNavigationBarDelegate> delegate;

@end
