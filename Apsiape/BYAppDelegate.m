
#import "BYAppDelegate.h"
#import "BYNavigationController.h"
#import "BYCollectionViewController.h"
#import "BYStorage.h"
#import "Constants.h"

@implementation BYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [BYStorage sharedStorage];
    
    self.window.rootViewController = [[BYNavigationController alloc]initWithRootViewController:[[BYCollectionViewController alloc]initWithNibName:nil bundle:nil]];
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [application setStatusBarStyle:UIStatusBarStyleDefault];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    
    application.applicationIconBadgeNumber = 0;
    application.applicationSupportsShakeToEdit = YES;
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    if ([[NSUserDefaults standardUserDefaults]boolForKey:BYApsiapeCreateOnLaunchPreferenceKey]) {
        [[NSNotificationCenter defaultCenter]postNotificationName:BYNavigationControllerShouldDisplayExpenseCreationVCNotificationName object:nil];
    }
}

@end
