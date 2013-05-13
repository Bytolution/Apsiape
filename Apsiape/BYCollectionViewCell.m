//
//  BYCollectionViewCell.m
//  Apsiape
//
//  Created by Dario Lass on 04.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYCollectionViewCell.h"
#import "Expense.h"

#pragma mark ––– UICollectionViewCellContentView implementation

@interface BYCollectionViewCell ()

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation BYCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.label = [[UILabel alloc]initWithFrame:CGRectZero];
        self.label.textAlignment = NSTextAlignmentRight;
        self.label.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.6];
        self.label.textColor = [UIColor darkTextColor];
        self.label.font = [UIFont fontWithName:@"Miso" size:32];
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        self.imageView.backgroundColor = [UIColor clearColor];
        
        [self.contentView addSubview:self.imageView];
        [self.contentView addSubview:self.label];
        
        self.backgroundColor = [UIColor colorWithWhite:0.5 alpha:1];
    }
    return self;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.label.text = _title;
}

- (void)setImage:(UIImage *)image
{
    _image = image;
    self.imageView.image = _image;
}

- (void)didMoveToSuperview
{
    CGRect rect = self.contentView.bounds;
    rect.size.height = self.contentView.bounds.size.height/3;
    self.label.frame = rect;
    self.imageView.frame = self.contentView.bounds;
}

@end





