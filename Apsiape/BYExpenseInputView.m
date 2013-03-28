//
//  BYExpenseInputView.m
//  Apsiape
//
//  Created by Dario Lass on 20.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYExpenseInputView.h"
#import "InterfaceConstants.h"

@interface BYExpenseInputView ()

@property (nonatomic, strong) NSMutableString *expenseValue;

@end

@implementation BYExpenseInputView

- (NSMutableString *)expenseValue
{
    if (!_expenseValue) _expenseValue = [[NSMutableString alloc]init];
    return _expenseValue;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)didMoveToSuperview {
    self.backgroundColor = [UIColor grayColor];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    } else {
        [self resignFirstResponder];
    }

}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)hasText {
    return YES;
}

- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeDecimalPad;
}

- (UIKeyboardAppearance)keyboardAppearance {
    return UIKeyboardAppearanceAlert;
}

- (void)insertText:(NSString *)text {
    NSRange decSeparatorRange = [self.expenseValue rangeOfString:@"."];
    if (decSeparatorRange.location < self.expenseValue.length - 2 && decSeparatorRange.location < 10) return;
    [self.expenseValue appendString:text];
    [self setNeedsDisplay];
}

- (void)deleteBackward {
    if (self.expenseValue.length < 1) {
        return;
    } else {
        NSRange range = NSMakeRange(self.expenseValue.length - 1, 1);
        [self.expenseValue deleteCharactersInRange:range];
        [self setNeedsDisplay];
    }
    
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    CGRect txtRect = rect;
    txtRect.size.width -= 50;
//    txtRect.origin.y += 5;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 4, [[UIColor blackColor] CGColor]);
    [[UIColor whiteColor] setFill];
    [self.expenseValue drawInRect:txtRect withFont:[UIFont fontWithName:@"Miso-Light" size:65] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    
    // this needs to be implemented for all currencies
    txtRect = rect;
    txtRect.origin.x = rect.size.width - 55;
    txtRect.size.width = 50;
    
    NSString *currString = @"€";
    [currString drawInRect:txtRect withFont:[UIFont fontWithName:@"Miso-Light" size:65] lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentRight];
    //
    
    CGContextDrawPath(context, kCGPathFillStroke);
}


@end
