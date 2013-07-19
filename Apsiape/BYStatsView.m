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

- (void)executeBlockWithTimer:(NSTimer*)timer;

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
    CGRect frame = CGRectInset(self.bounds, 20, 30);
    self.beamContainer.frame = frame;
    self.beamContainer.backgroundColor = [UIColor colorWithWhite:0.98 alpha:1].CGColor;
    float maxValue = [[self.values valueForKeyPath:@"@max.floatValue"] floatValue];
    for (int i = 0; i < self.values.count; i++) {
        __block CALayer *beam = [CALayer layer];
        CGFloat beamHeight = ([self.values[i] floatValue] * frame.size.height) / maxValue;
        
        CGRect baseFrame = CGRectMake((frame.size.width * ((float)i/(float)self.values.count)), 0, (frame.size.width/(float)self.values.count), 5);
        baseFrame = CGRectInset(baseFrame, 8, 0);
        
        CGRect fromBounds = CGRectMake(0, 0, baseFrame.size.width, 5);
        CGRect toBounds = CGRectMake(0, 0, baseFrame.size.width, beamHeight);
        
        beam.backgroundColor = [UIColor colorWithRed:0.5 green:0.6 blue:1 alpha:1].CGColor;
        beam.cornerRadius = 3;
        beam.anchorPoint = CGPointMake(0, 0);
        beam.position = baseFrame.origin;
        beam.bounds = fromBounds;
        
        __block CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        animation.fromValue = [NSValue valueWithCGRect:fromBounds];
        animation.toValue = [NSValue valueWithCGRect:toBounds];
        animation.duration = 0.2;
        
        Float64 delayInSeconds = (float)i * 0.03;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
            beam.bounds = toBounds;
            [beam addAnimation:animation forKey:@"bounds"];
        });
        
        [self.beamContainer addSublayer:beam];
    }
    [self.layer addSublayer:self.beamContainer];
}

- (void)executeBlockWithTimer:(NSTimer *)timer
{
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
