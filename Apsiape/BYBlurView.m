//
//  BYBlurView.m
//  Apsiape
//
//  Created by Dario Lass on 30.09.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYBlurView.h"

@interface BYBlurView ()

@property (nonatomic, strong) UIImageView *imageView;
- (void)refresh;

@end

@implementation BYBlurView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [NSTimer scheduledTimerWithTimeInterval:0.03 target:self selector:@selector(refresh) userInfo:nil repeats:YES];
        if (!self.imageView) self.imageView = [[UIImageView alloc]init];
        [self addSubview:self.imageView];
        self.imageView.contentMode = UIViewContentModeTopLeft;
        self.imageView.clipsToBounds = YES;
    }
    return self;
}

- (void)refresh
{
    NSLog(@"refresh");
    
    CGPoint contentOffset = [(UITableView*)self.sourceView contentOffset];
    
    CGRect visibleRect = CGRectMake(contentOffset.x, contentOffset.y, CGRectGetWidth(self.sourceView.frame), CGRectGetHeight(self.sourceView.frame));
    
    self.imageView.frame = self.bounds;
    
    UIGraphicsBeginImageContextWithOptions(self.sourceView.bounds.size, YES, 0.2);
    [self.sourceView drawViewHierarchyInRect:visibleRect afterScreenUpdates:NO];
    UIImage *snapshotForBlur = UIGraphicsGetImageFromCurrentImageContext();
    
//    CGImageRef imageRef = CGImageCreateWithImageInRect([snapshotForBlur CGImage], self.bounds);
    
    self.imageView.image = snapshotForBlur;
}

@end