//
//  BYCollectionViewCell.h
//  Apsiape
//
//  Created by Dario Lass on 04.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BYCollectionViewCell.h"

#define CELL_CONTENT_INSET 5

@class BYCollectionViewCell;

@interface BYCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;

@property (nonatomic) BOOL bgIsGreen;

@end
