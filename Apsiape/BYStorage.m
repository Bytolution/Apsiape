//
//  BYStorage.m
//  Apsiape
//
//  Created by Dario Lass on 18.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <CoreLocation/CoreLocation.h>
#import "BYStorage.h"
#import "UIImage+Adjustments.h"
#import "Expense.h"
#import "BYLocalizer.h"

@interface BYStorage () <CLLocationManagerDelegate>

@property (strong, nonatomic) UIManagedDocument *document;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic) BOOL localeUpdated;

- (void)docStateChanged;
- (void)openDocument;
- (void)startLocationServices;
- (void)writeImageToDisk:(UIImage *)fullResImg forBasePath:(NSString*)basePath completion:(void (^)(BOOL success))completionHandler;

@end

@implementation BYStorage

+ (BYStorage *)sharedStorage {
    static BYStorage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BYStorage alloc] init];
    });
    
    return sharedInstance;
}

- (NSManagedObjectContext *)managedObjectContext {
    return self.document.managedObjectContext;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self openDocument];
    }
    return self;
}

#pragma mark - Document handling

- (void)openDocument {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(docStateChanged) name:UIDocumentStateChangedNotification object:nil];
    
    if (!self.document) {
        NSURL *url = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"appStorage"];
        self.document = [[UIManagedDocument alloc] initWithFileURL:url];
        if (![[NSFileManager defaultManager]fileExistsAtPath:[self.document.fileURL path]]) {
            [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
                NSLog(@"File got saved");
                if (success) [self.document openWithCompletionHandler:^(BOOL success) {
                    NSLog(@"Document opened %s", success ? "successfully":"unsuccessfully");
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"BYStorageContentChangedNotification" object:nil];
                }];
            }];
        } else if (self.document.documentState == UIDocumentStateClosed) {
            [self.document openWithCompletionHandler:^(BOOL success) {
                NSLog(@"Document opened %s", success ? "successfully":"unsuccessfully");
                [[NSNotificationCenter defaultCenter]postNotificationName:@"BYStorageContentChangedNotification" object:nil];
                [self startLocationServices];
                
            }];
        }
    }
}
- (void)saveDocument {
    [self.managedObjectContext performBlock:^{
        [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
            if (success) NSLog(@"document was saved successfully");
//            [[NSNotificationCenter defaultCenter]postNotificationName:@"BYStorageContentChangedNotification" object:nil];
        }];
    }];
}
- (void)docStateChanged {
    switch (self.document.documentState) {
        case UIDocumentStateNormal:
            NSLog(@"document state OPEN");
            break;
        case UIDocumentStateClosed:
            NSLog(@"document state CLOSED");
            break;
        case UIDocumentStateInConflict:
            NSLog(@"document state IN CONFLICT");
            break;
        case UIDocumentStateEditingDisabled:
            NSLog(@"document state DISABLED");
            break;
        case UIDocumentStateSavingError:
            NSLog(@"document state SAVING ERROR");
            break;
    }
}

#pragma mark - Core Data (Expense management)

- (void)saveExpenseObjectWithStringValue:(NSString *)stringValue numberValue:(NSNumber *)numberValue fullResImage:(UIImage *)fullResImg completion:(void (^)(BOOL))completionHandler
{
    Expense *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:self.managedObjectContext];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-SS"];
    NSString *timeStamp = [dateFormatter stringFromDate:currentDate];
    NSString *documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSString *basePath = [NSString stringWithFormat:@"%@/%@image_", documentsDirectoryPath, timeStamp];
    
    [self.managedObjectContext performBlock:^{
        newExpense.date = [NSDate date];
        newExpense.stringValue = stringValue;
        newExpense.numberValue = numberValue;
        newExpense.location = [NSKeyedArchiver archivedDataWithRootObject:self.locationManager.location];
        newExpense.localeIdentifier = [BYLocalizer currentAppLocale].localeIdentifier;
        newExpense.baseFilePath = basePath;
        [[NSNotificationCenter defaultCenter]postNotificationName:@"BYStorageContentChangedNotification" object:nil];
    }];
    
    // check which thread is already finished
    __block BOOL locationStringDetermined = NO;
    __block BOOL filesSaved = NO;
    
    if (fullResImg) {
        [self writeImageToDisk:fullResImg forBasePath:basePath completion:^(BOOL success){
            NSLog(@"Files %@saved to disk", success ? @"" : @"not ");
            filesSaved = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"BYStorageContentChangedNotification" object:nil];
            NSLog(@"images");
            if (locationStringDetermined) {
                completionHandler(YES);
                [self saveDocument];
            }
        }];
    }
    if (self.locationManager.location) {
        [BYLocalizer geocodeInfoStringForLocation:self.locationManager.location completion:^(NSString *infoString) {
            [self.managedObjectContext performBlock:^{
                newExpense.locationString = infoString;
                locationStringDetermined = YES;
                [[NSNotificationCenter defaultCenter]postNotificationName:@"BYStorageContentChangedNotification" object:nil];
                NSLog(@"location");
                if (filesSaved) {
                    completionHandler(YES);
                    [self saveDocument];
                }
            }];
        }];
    }
}

- (void)writeImageToDisk:(UIImage *)fullResImg forBasePath:(NSString*)basePath completion:(void (^)(BOOL success))completionHandler
{
    dispatch_queue_t saveQueue = dispatch_queue_create("User data fetcher", NULL);
    dispatch_async(saveQueue, ^{
        NSData *fullResolutionImageData = UIImageJPEGRepresentation(fullResImg, 1.0);
        BOOL fullResWriteSuccesfull = [fullResolutionImageData writeToFile:[NSString stringWithFormat:@"%@full.jpg", basePath] atomically:NO];
        NSData *screenResolutionImageData = UIImageJPEGRepresentation([fullResImg cropWithSquareRatioAndResolution:640], 1.0);
        BOOL screenResSuccessfull = [screenResolutionImageData writeToFile:[NSString stringWithFormat:@"%@screen.jpg", basePath] atomically:NO];
        NSData *thumbnailResolutionImageData = UIImageJPEGRepresentation([fullResImg cropWithSquareRatioAndResolution:160], 1.0);
        BOOL thumbResWriteSuccesfull = [thumbnailResolutionImageData writeToFile:[NSString stringWithFormat:@"%@thumb.jpg", basePath] atomically:NO];
        NSData *screenResolutionMonochromeImageData = UIImageJPEGRepresentation([[fullResImg cropWithSquareRatioAndResolution:640] monochromeImage], 1.0);
        BOOL screenResMonoWriteSuccesfull = [screenResolutionMonochromeImageData writeToFile:[NSString stringWithFormat:@"%@screen-mono.jpg", basePath] atomically:NO];
        NSData *thumbnailResolutionMonochromeImageData = UIImageJPEGRepresentation([[fullResImg cropWithSquareRatioAndResolution:160] monochromeImage], 1.0);
        BOOL thumbResMonoWriteSuccesfull = [thumbnailResolutionMonochromeImageData writeToFile:[NSString stringWithFormat:@"%@thumb-mono.jpg", basePath] atomically:NO];
        [self.managedObjectContext performBlock:^{
            if (fullResWriteSuccesfull && screenResMonoWriteSuccesfull && screenResSuccessfull && thumbResMonoWriteSuccesfull && thumbResWriteSuccesfull){
                completionHandler(YES);
            } else {
                completionHandler(NO);
            }
        }];
    });

}
- (void)deleteExpenseObject:(Expense *)expense completion:(void (^)())completionHandler
{
    dispatch_queue_t deleteQueue = dispatch_queue_create("DeleteQueue", nil);
    dispatch_async(deleteQueue, ^{
        NSError *error;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtPath:expense.fullResolutionImagePath error:&error];
        [fileManager removeItemAtPath:expense.screenResolutionImagePath error:&error];
        [fileManager removeItemAtPath:expense.screenResolutionMonochromeImagePath error:&error];
        [fileManager removeItemAtPath:expense.thumbnailResolutionImagePath error:&error];
        [fileManager removeItemAtPath:expense.thumbnailResolutionMonochromeImagePath error:&error];
        [self.managedObjectContext performBlock:^{
            [self.managedObjectContext deleteObject:expense];
            completionHandler();
        }];
    });
}

#pragma mark - Location Services

- (void)startLocationServices
{
    if (!self.locationManager) self.locationManager = [[CLLocationManager alloc]init];
    self.locationManager.pausesLocationUpdatesAutomatically = YES;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    if (manager.location.horizontalAccuracy < 1000 && !self.localeUpdated) {
        [BYLocalizer determineCurrentLocaleWithLocation:manager.location];
        self.localeUpdated = YES;
    }
}


@end
