//
//  BYQuickShotView.h
//  QuickShotView
//
//  Created by Dario Lass on 22.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYQuickShotView;

@protocol BYQuickShotViewDelegate <NSObject>

- (void)quickShotViewDidFinishPreparation:(BYQuickShotView*)quickShotView;

- (void)didTakeSnapshot:(UIImage*)img;
- (void)didDiscardLastImage;

@end

@interface BYQuickShotView : UIView

@property (nonatomic, strong) id <BYQuickShotViewDelegate> delegate;
@property (nonatomic, strong) UIImage *fullResCapturedImage;

@end
