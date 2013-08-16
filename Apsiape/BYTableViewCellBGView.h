//
//  BYTableViewCellBGView.h
//  Apsiape
//
//  Created by Dario Lass on 09.08.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    BYTableViewCellBGViewCellPositionNone = 0,
    BYTableViewCellBGViewCellPositionSingle,
    BYTableViewCellBGViewCellPositionTop,
    BYTableViewCellBGViewCellPositionMiddle,
    BYTableViewCellBGViewCellPositionBottom
}BYTableViewCellBGViewCellPosition;

@interface BYTableViewCellBGView : UIView

- (id)initWithFrame:(CGRect)frame cellPosition:(BYTableViewCellBGViewCellPosition)position;

@end
