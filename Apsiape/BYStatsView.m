//
//  BYStatsView.m
//  Apsiape
//
//  Created by Dario Lass on 16.07.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "BYStatsView.h"

@interface BYStatsView ()

@property (nonatomic, strong) NSArray *values;
@property (nonatomic, strong) CALayer *beamContainer;

@end

@implementation BYStatsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.transform = CGAffineTransformMakeScale(1, -1);
        self.values = @[@12.5f, @4.25f, @23.0f, @3.0f, @17.9f, @7.0f, @15.1f];
    }
    return self;
}

- (void)didMoveToSuperview
{
    self.backgroundColor = [UIColor whiteColor];
    self.beamContainer = [CALayer layer];
    CGRect frame = CGRectInset(self.bounds, 20, 20);
    self.beamContainer.frame = frame;
    self.beamContainer.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1].CGColor;
    float maxValue = [[self.values valueForKeyPath:@"@max.floatValue"] floatValue];
    for (int i = 0; i < self.values.count; i++) {
        CALayer *beam = [CALayer layer];
        CGFloat beamHeight = ([self.values[i] floatValue] * frame.size.height) / maxValue;
        
        beam.backgroundColor = [UIColor colorWithRed:0.5 green:0.6 blue:1 alpha:1].CGColor;
        beam.anchorPoint = CGPointMake(0, 0);
        beam.position = CGPointMake(frame.size.width * ((float)i/(float)self.values.count), 0);
        CGRect endBounds = CGRectMake(0, 0, frame.size.width /(float)self.values.count, beamHeight);
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        animation.fromValue = [NSValue valueWithCGRect:CGRectMake(0, 0, frame.size.width /(float)self.values.count, 5)];
        animation.toValue = [NSValue valueWithCGRect:endBounds];
        animation.duration = .5;
        animation.beginTime = CACurrentMediaTime() + ((float)i * 2);
        [beam addAnimation:animation forKey:@"beamAnimation"];
        
        [self.beamContainer addSublayer:beam];
        beam.bounds = endBounds;
    }
    [self.layer addSublayer:self.beamContainer];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
}


@end
