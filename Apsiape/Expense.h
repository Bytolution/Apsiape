//
//  Expense.h
//  Apsiape
//
//  Created by Dario Lass on 15.04.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Expense : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) NSData * location;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * value;

@end
