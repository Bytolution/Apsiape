//
//  BYSplitAnimationOverlayView.h
//  Apsiape
//
//  Created by Dario Lass on 04.05.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BYSplitAnimationOverlayViewProtocol <NSObject>

- (void)splitAnimationOverlayViewDidFinishOpeningAnimation;

@required

- (void)splitAnimationOverlayViewDidFinishClosingAnimation;

@end

@interface BYSplitAnimationOverlayView : UIView

@property (nonatomic, strong) id <BYSplitAnimationOverlayViewProtocol> delegate;

- (void)splitView:(UIView*)sourceView;
- (void)slideBack;

@end
