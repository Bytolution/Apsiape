//
//  BYExpenseInputView.m
//  Apsiape
//
//  Created by Dario Lass on 20.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseInputView.h"

@interface BYExpenseInputView () 

@property (nonatomic) BOOL includeDecimalSeparator;
@property (nonatomic, strong) NSMutableString *firstSubstring;
@property (nonatomic, strong) NSMutableString *secondSubstring;

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
//
//- (void)addCharacter:(NSString *)character {
//    if (![character isEqualToString:@"."]) {
//        self.includeDecimalSeparator = YES;
//    } else {
//        if (!self.includeDecimalSeparator) {
//            [self.firstSubstring appendString:character];
//        } else {
//            
//        }
//    }
//}

- (void)setText:(NSString *)text {
    _text = text;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGRect txtRect = rect;
    txtRect.size.width -= 50;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    [self.fontColor setFill];

    CGContextSetLineWidth(context, 4);
    
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 4, [self.fontColor CGColor]);
    [self.text drawInRect:txtRect withFont:[UIFont fontWithName:@"Miso-Light" size:90] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    NSString *currString = @"€";
    
    txtRect = rect;
    txtRect.origin.x = rect.size.width - 60;
    txtRect.size.width = 50;
    
    [currString drawInRect:txtRect withFont:[UIFont fontWithName:@"Miso-Light" size:65] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    
    // TODO: implementation for all currencies
    
    
    
}


@end
