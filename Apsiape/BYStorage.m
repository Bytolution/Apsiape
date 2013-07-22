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


@interface BYStorage () <CLLocationManagerDelegate>

@property (strong, nonatomic) UIManagedDocument *document;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *location;

- (void)docStateChanged;
- (void)openDocument;
- (void)startLocationServices;

@end

@implementation BYStorage

+ (BYStorage *)sharedStorage {
    static BYStorage *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BYStorage alloc] init];
        NSLog(@"SINGLETON: BYStorage now exists.");
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
                }];
            }];
        } else if (self.document.documentState == UIDocumentStateClosed) {
            [self.document openWithCompletionHandler:^(BOOL success) {
                NSLog(@"Document opened %s", success ? "successfully":"unsuccessfully");
                [self startLocationServices];
            }];
        }
    }
}

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
    self.location = locations[0];
}

- (void)saveDocument {
    [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) NSLog(@"document was saved successfully");
        [[NSNotificationCenter defaultCenter]postNotificationName:@"UIDocumentSavedSuccessfullyNotification" object:nil];
    }];
}

- (void)saveExpenseObjectWithStringValue:(NSString *)stringValue numberValue:(NSNumber *)numberValue fullResImage:(UIImage *)fullResImg completion:(void (^)(BOOL))completionHandler
{
    Expense *newExpense = [NSEntityDescription insertNewObjectForEntityForName:@"Expense" inManagedObjectContext:self.document.managedObjectContext];
    
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateFormatter;
    dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-SS"];
    NSString *timeStamp = [dateFormatter stringFromDate:currentDate];
    
    NSString *documentsDirectoryPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *fullResolutionImagePath = [NSString stringWithFormat:@"%@/%@image_fullRes.jpg", documentsDirectoryPath, timeStamp];
    NSString *screenResolutionImagePath = [NSString stringWithFormat:@"%@/%@image_screenRes.jpg", documentsDirectoryPath, timeStamp];
    NSString *thumbnailResolutionImagePath = [NSString stringWithFormat:@"%@/%@image_thumbRes.jpg", documentsDirectoryPath, timeStamp];
    NSString *screenResolutionMonochromeImagePath = [NSString stringWithFormat:@"%@/%@image_screenRes_monochrome.jpg", documentsDirectoryPath, timeStamp];
    NSString *thumbnailResolutionMonochromeImagePath = [NSString stringWithFormat:@"%@/%@image_thumbRes_monochrome.jpg", documentsDirectoryPath, timeStamp];
    [self.managedObjectContext performBlock:^{
        newExpense.date = [NSDate date];
        newExpense.fullResolutionImagePath = fullResolutionImagePath;
        newExpense.screenResolutionImagePath = screenResolutionImagePath;
        newExpense.screenResolutionMonochromeImagePath = screenResolutionMonochromeImagePath;
        newExpense.thumbnailResolutionImagePath = thumbnailResolutionImagePath;
        newExpense.thumbnailResolutionMonochromeImagePath = thumbnailResolutionMonochromeImagePath;
        newExpense.stringValue = stringValue;
        newExpense.numberValue = numberValue;
        newExpense.location = [NSKeyedArchiver archivedDataWithRootObject:self.location];
    }];
    dispatch_queue_t saveQueue = dispatch_queue_create("User data fetcher", NULL);
    dispatch_async(saveQueue, ^{
        NSData *fullResolutionImageData = UIImageJPEGRepresentation(fullResImg, 1.0);
        [fullResolutionImageData writeToFile:fullResolutionImagePath atomically:NO];
        fullResolutionImageData = nil;
        NSData *screenResolutionImageData = UIImageJPEGRepresentation([fullResImg cropWithSquareRatioAndResolution:640], 1.0);
        [screenResolutionImageData writeToFile:screenResolutionImagePath atomically:NO];
        screenResolutionImageData = nil;
        NSData *thumbnailResolutionImageData = UIImageJPEGRepresentation([fullResImg cropWithSquareRatioAndResolution:160], 1.0);
        [thumbnailResolutionImageData writeToFile:thumbnailResolutionImagePath atomically:NO];
        thumbnailResolutionImageData = nil;
        NSData *screenResolutionMonochromeImageData = UIImageJPEGRepresentation([[fullResImg cropWithSquareRatioAndResolution:640] monochromeImage], 1.0);
        [screenResolutionMonochromeImageData writeToFile:screenResolutionMonochromeImagePath atomically:NO];
        screenResolutionMonochromeImageData = nil;
        NSData *thumbnailResolutionMonochromeImageData = UIImageJPEGRepresentation([[fullResImg cropWithSquareRatioAndResolution:160] monochromeImage], 1.0);
        [thumbnailResolutionMonochromeImageData writeToFile:thumbnailResolutionMonochromeImagePath atomically:NO];
        thumbnailResolutionMonochromeImageData = nil;
        [self.managedObjectContext performBlock:^{
            [self saveDocument];
        }];
    });
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

+ (NSString *)appFontName {
    return @"Helvetica";
}
+ (NSString *)secondAppFontName {
    return @"Arial-ItalicMT";
}
+ (UIFont *)tableViewFont {
    return [UIFont fontWithName:@"Helvetica" size:18];
}


@end
