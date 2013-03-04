//
//  Expense.h
//  Apsiape
//
//  Created by Dario Lass on 02.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Tag;

@interface Expense : NSManagedObject

@property (nonatomic, retain) id image;
@property (nonatomic, retain) id location;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSSet *tags;
@end

@interface Expense (CoreDataGeneratedAccessors)

- (void)addTagsObject:(Tag *)value;
- (void)removeTagsObject:(Tag *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
