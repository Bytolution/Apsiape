//
//  BYCollectionViewCell.h
//  Apsiape
//
//  Created by Dario Lass on 04.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Expense;

@interface BYCollectionViewCell : UICollectionViewCell

- (id)initWithFrame:(CGRect)frame expense:(Expense*)expense;

@end
