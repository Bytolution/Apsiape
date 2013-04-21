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

@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;

- (void)saveDocument;

+ (NSString*)appFontName;
+ (NSString*)secondAppFontName;
+ (UIFont*)tableViewFont;

@end
