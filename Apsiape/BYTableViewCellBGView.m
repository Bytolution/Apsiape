//
//  BYTableViewCellBGView.m
//  Apsiape
//
//  Created by Dario Lass on 09.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYTableViewCellBGView.h"

@interface BYTableViewCellBGView ()

@property (nonatomic, readwrite) BYTableViewCellBGViewCellPosition cellPosition;

@end

@implementation BYTableViewCellBGView

- (id)initWithFrame:(CGRect)frame cellPosition:(BYTableViewCellBGViewCellPosition)position
{
    self = [super initWithFrame:frame];
    if (self) {
        self.cellPosition = position;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGFloat minX = CGRectGetMinX(self.bounds);
    CGFloat minY = CGRectGetMinY(self.bounds);
    CGFloat maxX = CGRectGetMaxX(self.bounds);
    CGFloat maxY = CGRectGetMaxY(self.bounds);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetStrokeColorWithColor(context, [UIColor colorWithWhite:0.9 alpha:1].CGColor);
    CGContextSetLineWidth(context, 2);
    
    switch (self.cellPosition) {
        case BYTableViewCellBGViewCellPositionSingle:
            CGContextMoveToPoint(context, minX, minY);
            CGContextAddLineToPoint(context, maxX, minY);
            CGContextStrokePath(context);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, maxX , maxY);
            CGContextAddLineToPoint(context, minX, maxY);
            CGContextStrokePath(context);
            break;
        case BYTableViewCellBGViewCellPositionTop:
            CGContextMoveToPoint(context, minX, minY);
            CGContextAddLineToPoint(context, maxX, minY);
            CGContextStrokePath(context);
            CGContextBeginPath(context);
            CGContextMoveToPoint(context, maxX , maxY);
            CGContextAddLineToPoint(context, minX + 10, maxY);
            CGContextStrokePath(context);
            break;
        case BYTableViewCellBGViewCellPositionMiddle:
            CGContextMoveToPoint(context, maxX , maxY);
            CGContextAddLineToPoint(context, minX + 10, maxY);
            CGContextStrokePath(context);
            break;
        default:
            CGContextMoveToPoint(context, maxX , maxY);
            CGContextAddLineToPoint(context, minX, maxY);
            CGContextStrokePath(context);
            break;
    }
    CGContextDrawPath(context, kCGPathStroke);
}

@end
