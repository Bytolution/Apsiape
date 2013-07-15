//
//  BYStorage.h
//  Apsiape
//
//  Created by Dario Lass on 18.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BYContainerViewController;

@interface BYStorage : NSObject

+ (BYStorage*)sharedStorage;

- (NSManagedObjectContext*)managedObjectContext;

- (void)saveDocument;
- (void)saveExpenseObjectWithStringValue:(NSString*)stringValue
                             numberValue:(NSNumber*)numberValue
                            fullResImage:(UIImage*)fullResImg
                              completion:(void(^)(BOOL success))completionHandler;

+ (NSString*)appFontName;
+ (NSString*)secondAppFontName;
+ (UIFont*)tableViewFont;

@end
