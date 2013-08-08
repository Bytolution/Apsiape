
#import "BYAppDelegate.h"
#import "BYNavigationController.h"
#import "BYCollectionViewController.h"
#import "BYStorage.h"

@implementation BYAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    [BYStorage sharedStorage];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    self.window.rootViewController = [[BYNavigationController alloc]initWithRootViewController:[[BYCollectionViewController alloc]initWithNibName:nil bundle:nil]];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
