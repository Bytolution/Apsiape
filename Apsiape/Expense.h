//
//  Expense.h
//  Apsiape
//
//  Created by Dario Lass on 22.07.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Expense : NSManagedObject

@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * fullResolutionImagePath;
@property (nonatomic, retain) NSData * location;
@property (nonatomic, retain) NSNumber * numberValue;
@property (nonatomic, retain) NSString * screenResolutionImagePath;
@property (nonatomic, retain) NSString * screenResolutionMonochromeImagePath;
@property (nonatomic, retain) NSString * stringValue;
@property (nonatomic, retain) NSString * thumbnailResolutionImagePath;
@property (nonatomic, retain) NSString * thumbnailResolutionMonochromeImagePath;
@property (nonatomic, retain) NSString * locationString;

@end
