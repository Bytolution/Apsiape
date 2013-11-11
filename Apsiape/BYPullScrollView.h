//
//  BYPullScrollView.h
//  Apsiape
//
//  Created by Dario Lass on 02.07.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@protocol BYPullScrollViewDelegate <NSObject>

//- (void)pullScrollView:(UIScrollView*)pullScrollView didScrollToPage:(NSInteger)page;
- (void)pullScrollView:(UIScrollView*)pullScrollView didDetectPullingAtEdge:(BYEdgeType)edge;

@end

@interface BYPullScrollView : UIScrollView

@property (nonatomic, strong) UIScrollView *childScrollView;
@property (nonatomic) id <BYPullScrollViewDelegate> pullScrollViewDelegate;

@end
