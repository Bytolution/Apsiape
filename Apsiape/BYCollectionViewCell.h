//
//  BYCollectionViewCell.h
//  Apsiape
//
//  Created by Dario Lass on 04.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BYCollectionViewCell;

@protocol BYCollectionViewCellDelegate <NSObject>

- (void)cellDidDetectTapGesture:(BYCollectionViewCell*)cell withCellIndex:(NSInteger)index;

@end

@interface BYCollectionViewCell : UIView

@property (nonatomic, strong) id <BYCollectionViewCellDelegate> delegate;

- (id)initWithFrame:(CGRect)frame cellAttributes:(NSDictionary*)attributes index:(NSInteger)index;

@end
