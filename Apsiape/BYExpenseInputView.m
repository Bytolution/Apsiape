//
//  BYExpenseInputView.m
//  Apsiape
//
//  Created by Dario Lass on 20.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseInputView.h"
#import "InterfaceConstants.h"
#import "BYExpenseKeyboard.h"

@interface BYExpenseInputView () 


@end

@implementation BYExpenseInputView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)didMoveToSuperview {
    self.backgroundColor = [UIColor colorWithWhite:0.1 alpha:1];
    
}

- (void)setText:(NSString *)text {
    _text = text;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGRect txtRect = rect;
    txtRect.size.width -= 50;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [[UIColor whiteColor] setFill];
    [[UIColor whiteColor] setStroke];

    CGContextMoveToPoint(context, CGRectGetMinX(rect), CGRectGetMaxY(rect));
    CGContextAddLineToPoint(context, CGRectGetMaxX(rect), CGRectGetMaxY(rect));
    CGContextSetLineWidth(context, 4);
    
    CGContextDrawPath(context, kCGPathFillStroke);
    
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 4, [[UIColor whiteColor] CGColor]);
    [self.text drawInRect:txtRect withFont:[UIFont fontWithName:@"Miso-Light" size:65] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    
    // TODO: implementation for all currencies
    txtRect = rect;
    txtRect.origin.x = rect.size.width - 60;
    txtRect.size.width = 50;
    
    NSString *currString = @"€";
    [currString drawInRect:txtRect withFont:[UIFont fontWithName:@"Miso-Light" size:65] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    //
        
    context = UIGraphicsGetCurrentContext();
    
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
