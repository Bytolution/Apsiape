//
//  Tag.h
//  Apsiape
//
//  Created by Dario Lass on 02.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Expense;

@interface Tag : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) Expense *expense;

@end
