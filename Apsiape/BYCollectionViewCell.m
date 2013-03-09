//
//  BYCollectionViewCell.m
//  Apsiape
//
//  Created by Dario Lass on 04.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYCollectionViewCell.h"
#import "Expense.h"

@interface BYCollectionViewCellContentView : UIView

@end

@implementation BYCollectionViewCellContentView



@end


//----------------------------------------------------------------------------------------------
#pragma UICollectionViewCell implementation

@interface BYCollectionViewCell ()

@property (nonatomic, strong) Expense *expense;

@end

@implementation BYCollectionViewCell

- (id)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame expense:nil];
}

- (id)initWithFrame:(CGRect)frame expense:(Expense *)expense {
    self = [super init];
    if (self) {
        //initialization
    }
    return self;
}

@end
