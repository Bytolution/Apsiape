
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
    
    self.window.rootViewController = [[BYNavigationController alloc]initWithRootViewController:[[BYCollectionViewController alloc]initWithNibName:nil bundle:nil]];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.window.backgroundColor = [UIColor blackColor];
    [self.window makeKeyAndVisible];
    return YES;
}


@end
