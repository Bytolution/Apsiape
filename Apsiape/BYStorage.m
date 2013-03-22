//
//  BYStorage.m
//  Apsiape
//
//  Created by Dario Lass on 18.03.13.
//  Copyright (c) 2013 Bytolution. All rights reserved.
//

#import "BYStorage.h"
#import "BYAppDelegate.h"
#import "BYContainerViewController.h"
#import <CoreData/CoreData.h>

@interface BYStorage ()

@property (strong, nonatomic) UIManagedDocument *document;

- (void)docStateChanged;
- (void)openDocument;

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
//                    if (success) [self checkForUserInfo];
                }];
            }];
        } else if (self.document.documentState == UIDocumentStateClosed) {
            [self.document openWithCompletionHandler:^(BOOL success) {
                NSLog(@"Document opened %s", success ? "successfully":"unsuccessfully");
//                if (success) [self checkForUserInfo];
            }];
        }
    }
}

- (void)saveDocument {
    [self.document saveToURL:self.document.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
        if (success) NSLog(@"document was saved successfully in '-saveDocument'");
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
