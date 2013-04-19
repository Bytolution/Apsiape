//
//  BYHeaderBar.m
//  Apsiape
//
//  Created by Dario Lass on 17.04.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYHeaderBar.h"

typedef enum {
    BYHeaderBarSubheaderViewPositionCenter = 0,
    BYHeaderBarSubheaderViewPositionLeft,
    BYHeaderBarSubheaderViewPositionRight
} BYHeaderBarSubheaderViewPosition;

@interface BYHeaderBarSubheaderView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic) BYHeaderBarSubheaderViewPosition position;

@end

@implementation BYHeaderBarSubheaderView

- (void)layoutSubviews {
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:self.bounds];
    titleLabel.text = self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont fontWithName:@"Avenir-BookOblique" size:30];
    [self addSubview:titleLabel];
}

@end

@interface BYHeaderBar () <UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *scrollView;
@property (nonatomic,strong) NSMutableArray *subheaderArray;

@end

@implementation BYHeaderBar

- (UIScrollView *)scrollView
{
    if (!_scrollView) _scrollView = [[UIScrollView alloc]initWithFrame:self.view.bounds];
    return _scrollView;
}

- (NSMutableArray *)subheaderArray
{
    if (!_subheaderArray) _subheaderArray = [[NSMutableArray alloc]init];
    return _subheaderArray;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor grayColor];
    
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.bounces = NO;
    [self.view addSubview:self.scrollView];

    [self addSubheaderWithTitle:@"Main"];
    [self addSubheaderWithTitle:@"Map"];
    [self addSubheaderWithTitle:@"Edit"];
    
    CGSize scrollViewSize = self.scrollView.bounds.size;
    
    for (BYHeaderBarSubheaderView *subheader in self.subheaderArray) {
        
        CGRect rect = CGRectMake(0, 0, scrollViewSize.width, scrollViewSize.height);
        if (self.subheaderArray.count == 2) {
            if (subheader.position == BYHeaderBarSubheaderViewPositionCenter) rect.origin.x = scrollViewSize.width * (1.0f/2.0f);
        } else if (self.subheaderArray.count == 3) {
            switch (subheader.position) {
                case BYHeaderBarSubheaderViewPositionCenter:
                    rect.origin.x = self.scrollView.contentSize.width * (1.0f/3.0f);
                    break;
                case BYHeaderBarSubheaderViewPositionLeft:
                    break;
                case BYHeaderBarSubheaderViewPositionRight:
                    rect.origin.x = self.scrollView.contentSize.width * (2.0f/3.0f);
                    break;
            }
        }
        
        subheader.frame = rect;
        [self.scrollView addSubview:subheader];
        
        if (self.subheaderArray.count >= 2) {
            CGRect targetRect;
            for (BYHeaderBarSubheaderView *sub in self.subheaderArray) {
                if (sub.position == BYHeaderBarSubheaderViewPositionCenter) targetRect = sub.frame;
            }
            [self.scrollView scrollRectToVisible:targetRect animated:YES];
        } 
    }
    
}

- (void)addSubheaderWithTitle:(NSString *)title
{
    if (self.subheaderArray.count <= 3) {
        BYHeaderBarSubheaderView *subheader = [[BYHeaderBarSubheaderView alloc]init];
        subheader.title = title;
        switch (self.subheaderArray.count) {
            case 0:
                subheader.position = BYHeaderBarSubheaderViewPositionCenter;
                break;
            case 1:
                subheader.position = BYHeaderBarSubheaderViewPositionLeft;
                break;
            case 2:
                subheader.position = BYHeaderBarSubheaderViewPositionRight;
                break;
        }
        [self.subheaderArray addObject:subheader];
        self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width * [self.subheaderArray count], self.scrollView.bounds.size.height);
    }
}

@end
