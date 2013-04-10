//
//  BYLocationTagView.m
//  Apsiape
//
//  Created by Dario Lass on 07.04.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYLocationTagView.h"
#import "Colours.h"

@implementation BYLocationTagView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)didMoveToSuperview {

}

- (void)drawRect:(CGRect)rect
{
//    rect = CGRectInset(rect, 0.5f, 0.5f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGFloat minX = CGRectGetMinX(rect), midX = CGRectGetMidX(rect), maxX = CGRectGetMaxX(rect);
    CGFloat minY = CGRectGetMinY(rect), midY = CGRectGetMidY(rect), maxY = CGRectGetMaxY(rect);
    
    CGContextMoveToPoint(context, midX, midY);
    CGContextAddLineToPoint(context, minX, midY);
    CGContextAddLineToPoint(context, maxX, minY);
    CGContextAddLineToPoint(context, midX, maxY);
    CGContextClosePath(context);
    
    [[UIColor whiteColor] setStroke];
    
    UIColor *fillColor = ColorPastelGreen;
    [fillColor setFill];
    
    CGContextDrawPath(context, kCGPathStroke);
        
    [[UIColor greenColor] setStroke];
    CGContextSetLineWidth(context, 3);
    CGContextAddRect(context, self.bounds);
    CGContextDrawPath(context, kCGPathStroke);

}


@end
