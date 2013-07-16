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
    self.beamContainer = [CALayer layer];
    CGRect frame = CGRectInset(self.bounds, 20, 20);
    self.beamContainer.frame = frame;
    self.beamContainer.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
    float maxValue = [[self.values valueForKeyPath:@"@max.floatValue"] floatValue];
    for (int i = 0; i < self.values.count; i++) {
        CALayer *beam = [CALayer layer];
        CGFloat beamHeight = ([self.values[i] floatValue] * frame.size.height) / maxValue;
        CGRect beamRect = CGRectZero;
        beamRect.origin.x = frame.size.width * ((float)i/(float)self.values.count);
        beamRect.origin.y = 0;
        beamRect.size.width = frame.size.width / (float)self.values.count;
        beamRect.size.height = 5;
        beam.frame = CGRectInset(beamRect, 5, 0);
        beam.backgroundColor = [UIColor blueColor].CGColor;
        beam.anchorPoint = CGPointMake(beam.anchorPoint.x, 0);
        
        CGRect newBounds = CGRectMake(0, 0, beam.frame.size.width, beamHeight);
        
        CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"bounds"];
        animation.fromValue = [NSValue valueWithCGRect:beam.bounds];
        animation.toValue = [NSValue valueWithCGRect:newBounds];
        animation.duration = 1;
        animation.beginTime = CACurrentMediaTime() + ((float)i * 0.1);
        [beam addAnimation:animation forKey:@"beamAnimation"];
        beam.bounds = newBounds;
        [self.beamContainer addSublayer:beam];
    }
    [self.layer addSublayer:self.beamContainer];
}

@end
