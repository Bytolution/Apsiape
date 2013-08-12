//
//  InterfaceDefinitions.h
//  Apsiape
//
//  Created by Dario Lass on 11.07.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#ifndef Apsiape_InterfaceDefinitions_h
#define Apsiape_InterfaceDefinitions_h


#define COLOR_ALERT_RED [UIColor colorWithRed:1 green:0.3 blue:0.3 alpha:1]
#define COLOR_CELL_BACKGROUND [UIColor colorWithRed:1 green:1 blue:1 alpha:1]
#define ULTRA_LIGHT_BLUE [UIColor colorWithRed:0.97 green:0.98 blue:1 alpha:1]
#define CELL_IMAGE_PADDING 6
#define CELL_PADDING 8
#define ROW_PADDING 8
#define CELL_HEIGHT 100
#define NAVBAR_HEIGHT 64

typedef enum  {
    BYEdgeTypeNone = 0,
    BYEdgeTypeTop,
    BYEdgeTypeLeft,
    BYEdgeTypeBottom,
    BYEdgeTypeRight
} BYEdgeType;

#endif
