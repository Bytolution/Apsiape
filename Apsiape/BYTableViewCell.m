//
//  BYTableViewCell.m
//  Apsiape
//
//  Created by Dario Lass on 16.09.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYTableViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation BYTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.clipsToBounds = YES;
        self.textLabel.font = [UIFont fontWithName:@"Miso" size:40];
        self.textLabel.textAlignment = NSTextAlignmentRight;
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectZero];
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0.95 alpha:1];
        self.backgroundView.layer.borderColor = [UIColor colorWithWhite:0.9 alpha:1].CGColor;
        self.backgroundView.layer.borderWidth = 1;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGRect imageViewRect = CGRectMake(0, TOP_SPACE, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds) - TOP_SPACE - CELL_INSET_Y);
    CGRect labelRect = CGRectMake(0, 0, CGRectGetWidth(self.bounds), TOP_SPACE * 0.6);
    self.imageView.frame = CGRectInset(imageViewRect, CELL_INSET_X , 0);
    self.textLabel.frame = CGRectInset(labelRect, CELL_INSET_X + CELL_ADD_INSET_X, 0);
    self.backgroundView.frame = CGRectInset(self.bounds, CELL_INSET_X, CELL_INSET_Y);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
