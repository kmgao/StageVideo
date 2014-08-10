
#import "AppDelegate.h"
#import "GuideViewController.h"
#import "MainViewController.h"
#import "LoginViewController.h"
#import "MKNetworkKit.h"
#import "RegisterViewController.h"
#import "TokboxBridge.h"

//#import "BNavigationViewController.h"
//#import "KKNavigationController.h"

#import "ParserBridge.h"

@interface AppDelegate()
{

}


@end


@implementation AppDelegate


@synthesize window = _window;

+(instancetype)shareAppInstace
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
} 


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{ 
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    self.httpEngine = [[MKNetworkEngine alloc]initWithHostName:nil];
    
    [[ParserBridge shareParser] install];
    [[TokboxBridge shareTokbox] install];
    
    //    GuideViewController *guidVC = [[GuideViewController alloc] init];
    //    MainViewController  *mainVC = [[MainViewController alloc] init];
    
    UIViewController  *rootVC = nil;
    if([ParserBridge shareParser].hasRegisted)
    {
        rootVC= [MainViewController createSlidViewController];
    }
    else
    {
        rootVC = [[LoginViewController alloc] init];
    }
   //self.appNavi = [[BNavigationViewController alloc] initWithRootViewController:logVC];
    self.appNavi = [[KKNavigationController alloc] initWithRootViewController:rootVC];
    
    self.window.rootViewController = self.appNavi;
    
    [self.window makeKeyAndVisible];
    
//     [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self.appNavi setNavigationBarHidden:YES animated:NO];
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
