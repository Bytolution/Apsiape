//
//  Constants.h
//  Apsiape
//
//  Created by Dario Lass on 04.11.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CELL_IMAGE_PADDING 10
#define CELL_PADDING 0
#define ROW_PADDING 1

FOUNDATION_EXPORT NSString *const BYApsiapeCreateOnLaunchPreferenceKey;

FOUNDATION_EXPORT NSString *const BYNavigationControllerShouldDisplayExpenseCreationVCNotificationName;
FOUNDATION_EXPORT NSString *const BYNavigationControllerShouldDisplayPreferenceVCNotificationName;
FOUNDATION_EXPORT NSString *const BYNavigationControllerShouldDismissExpenseCreationVCNotificationName;
FOUNDATION_EXPORT NSString *const BYNavigationControllerShouldDismissPreferencesVCNotificationName;

#define POPOVER_INSET_X 20
#define POPOVER_INSET_Y 40

typedef enum  {
    BYEdgeTypeNone = 0,
    BYEdgeTypeTop,
    BYEdgeTypeLeft,
    BYEdgeTypeBottom,
    BYEdgeTypeRight
} BYEdgeType;
