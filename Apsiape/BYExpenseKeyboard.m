//
//  BYExpenseKeyboard.m
//  Apsiape
//
//  Created by Dario Lass on 20.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//
#import "BYExpenseKeyboard.h"

@interface BYKeyboardButtonView : UIView {
    UILabel *_label;
    id targetKeyboard;
    SEL keyBoardAction;
}

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIFont *font;

@end

@implementation BYKeyboardButtonView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _label = [[UILabel alloc]initWithFrame:CGRectZero];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.backgroundColor = [UIColor clearColor];
        _label.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:_label];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    [self layoutSubviews];
}

- (void)addTarget:(id)target action:(SEL)action
{
    targetKeyboard = target;
    keyBoardAction = action;
}

- (void)layoutSubviews
{
    _label.frame = self.bounds;
    _label.text = self.title;
    _label.font = self.font;
}

- (void)didMoveToSuperview
{
    [self layoutSubviews];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    self.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [targetKeyboard performSelector:keyBoardAction withObject:self afterDelay:0];
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.backgroundColor = [UIColor clearColor];
    } completion:nil];
}
- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        self.backgroundColor = [UIColor clearColor];
    } completion:nil];
}

@end

@interface BYExpenseKeyboard ()

@property (nonatomic, strong) NSArray *buttonArray;

- (void)prepareButtons;
- (void)buttonPressed:(UIButton*)sender;

@end


@implementation BYExpenseKeyboard

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:0.0];
    }
    return self;
}

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    [self prepareButtons];
    
    for (UIButton *button in self.buttonArray) {
        [self addSubview:button];
    }
}

- (void)prepareButtons {
    NSMutableArray *mButtonArray = [[NSMutableArray alloc]initWithCapacity:12];
    
    CGSize keyboardSize = self.frame.size;
    
    CGSize buttonSize = CGSizeMake(keyboardSize.width/3 - 0.25, keyboardSize.height/4 - 0.5);
    
    
    for (int i = 0; i < 12; i++) {
        BYKeyboardButtonView *button = [[BYKeyboardButtonView alloc]init];
        button.font = self.font;
        CGPoint buttonOrigin = CGPointMake(32, 13);
        switch (i) {
            case 0:
                [button setTitle:@"1"];
                buttonOrigin = CGPointMake(0, 0);
                break;
            case 1:
                [button setTitle:@"2"];
                buttonOrigin = CGPointMake(keyboardSize.width/2 - buttonSize.width/2, 0);
                break;
            case 2:
                [button setTitle:@"3"];
                buttonOrigin = CGPointMake(keyboardSize.width - buttonSize.width, 0);
                break;
            case 3:
                [button setTitle:@"4"];
                buttonOrigin = CGPointMake(0, keyboardSize.height * (1.0f/4.0f));
                break;
            case 4:
                [button setTitle:@"5"];
                buttonOrigin = CGPointMake(keyboardSize.width/2 - buttonSize.width/2, keyboardSize.height * (1.0f/4.0f));
                break;
            case 5:
                [button setTitle:@"6"];
                buttonOrigin = CGPointMake(keyboardSize.width - buttonSize.width, keyboardSize.height * (1.0f/4.0f));
                break;
            case 6:
                [button setTitle:@"7"];
                buttonOrigin = CGPointMake(0, keyboardSize.height * (2.0f/4.0f));
                break;
            case 7:
                [button setTitle:@"8"];
                buttonOrigin = CGPointMake(keyboardSize.width/2 - buttonSize.width/2, keyboardSize.height * (2.0f/4.0f));
                break;
            case 8:
                [button setTitle:@"9"];
                buttonOrigin = CGPointMake(keyboardSize.width - buttonSize.width, keyboardSize.height * (2.0f/4.0f));
                break;
            case 9:
                [button setTitle:@"."];
                buttonOrigin = CGPointMake(0, keyboardSize.height * (3.0f/4.0f));
                break;
            case 10:
                [button setTitle:@"0"];
                buttonOrigin = CGPointMake(keyboardSize.width/2 - buttonSize.width/2, keyboardSize.height * (3.0f/4.0f));
                break;
            case 11:
                [button setTitle:@"Del"];
                buttonOrigin = CGPointMake(keyboardSize.width - buttonSize.width, keyboardSize.height * (3.0f/4.0f));
                break;
        }
        buttonOrigin.y += 0.5;
        button.frame = CGRectMake(buttonOrigin.x, buttonOrigin.y, buttonSize.width, buttonSize.height);
        [button addTarget:self action:@selector(buttonPressed:)];
        button.font = self.font;
        [mButtonArray addObject:button];
    }
    
    self.buttonArray = [mButtonArray copy];
}

- (void)buttonPressed:(BYKeyboardButtonView*)sender
{
    if ([sender.title isEqualToString:@"Del"]) {
        [self.delegate deleteKeyTapped];
    } else {
        [self.delegate numberKeyTapped:sender.title];
    }
}

- (void)drawRect:(CGRect)rect
{
//    [super drawRect:rect];
    
    CGFloat x0 = CGRectGetMinX(rect) + 0.5, x1 = CGRectGetMaxX(rect) * (1.0f/3.0f), x2 = CGRectGetMaxX(rect) * (2.0f/3.0f), x3 = CGRectGetMaxX(rect) * (3.0f/3.0f);
    CGFloat y0 = CGRectGetMinX(rect) + 0.5, y1 = CGRectGetMaxY(rect) * (1.0f/4.0), y2 = CGRectGetMaxY(rect) * (2.0f/4.0), y3 = CGRectGetMaxY(rect) * (3.0f/4.0), y4 = CGRectGetMaxY(rect) * (4.0f/4.0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, .5);
    CGContextSetStrokeColorWithColor(context, [UIColor grayColor].CGColor);
    
    CGContextMoveToPoint(context, x0, y0);
    CGContextAddLineToPoint(context, x3, y0);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, x1, y0);
    CGContextAddLineToPoint(context, x1, y4);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, x2, y0);
    CGContextAddLineToPoint(context, x2, y4);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, x0, y1);
    CGContextAddLineToPoint(context, x3, y1);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, x0, y2);
    CGContextAddLineToPoint(context, x3, y2);
    CGContextStrokePath(context);
    CGContextMoveToPoint(context, x0, y3);
    CGContextAddLineToPoint(context, x3, y3);
    CGContextStrokePath(context);
}

@end