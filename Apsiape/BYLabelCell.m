//
//  BYLabelCell.m
//  Apsiape
//
//  Created by Dario Lass on 03.09.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYLabelCell.h"

@interface BYLabelCell ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation BYLabelCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if (!self.label) self.label = [[UILabel alloc]initWithFrame:CGRectZero];
        self.label.font = [UIFont fontWithName:@"Miso" size:40];
        self.label.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:self.label];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.label.text = _title;
}

- (void)layoutSubviews
{
    self.label.frame = self.bounds;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
