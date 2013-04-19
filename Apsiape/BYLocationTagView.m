//
//  BYLocationTagView.m
//  Apsiape
//
//  Created by Dario Lass on 07.04.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYLocationTagView.h"
#import "Colours.h"

@interface BYLocationTagViewLayerGreen : UIView

@end

@implementation BYLocationTagViewLayerGreen



@end

@interface BYLocationTagViewLayerGrey : UIView

@end

@implementation BYLocationTagViewLayerGrey

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    rect = CGRectInset(rect, 1.5, 1.5);

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGFloat minX = CGRectGetMinX(rect), midX = CGRectGetMidX(rect), maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect), midY = CGRectGetMidY(rect), maxY = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(ctx, midX, midY);
    CGContextAddLineToPoint(ctx, minX, midY);
    CGContextAddLineToPoint(ctx, maxX, minY);
    CGContextAddLineToPoint(ctx, midX, maxY);
    CGContextClosePath(ctx);
    
    CGContextSetLineWidth(ctx, 2);
    
    [[UIColor whiteColor] setStroke];
    
    UIColor *fillColor = ColorPastelGreen;
    [fillColor setFill];
    
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGContextDrawPath(ctx, kCGPathFillStroke);

}

@end


@interface BYLocationTagView ()

@property (nonatomic, strong) BYLocationTagViewLayerGrey *greyLayer;

@end

@implementation BYLocationTagView

- (BYLocationTagViewLayerGrey *)greyLayer {
    if (!_greyLayer) _greyLayer = [[BYLocationTagViewLayerGrey alloc] init];
    return _greyLayer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    self.greyLayer.frame = self.bounds;
    [self addSubview:self.greyLayer];
}


@end
