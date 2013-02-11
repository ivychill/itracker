//
//  LYAppDelegate.m
//  WhereYouAre
//
//  Created by Sean.Yie on 13-1-4.
//  Copyright (c) 2013年 Sean.Yie. All rights reserved.
//

#import "LYAppDelegate.h"
#import "LYViewController.h"
#import "LYComm4ZMQ.h"
#import "BMapKit.h"
#import "BaiduMobStat.h"

@implementation LYAppDelegate
@synthesize viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    //百度地图初始化代码
    self.baiduMapManager = [[BMKMapManager alloc]init];
    BOOL ret = [self.baiduMapManager start:@"513CBE299AB953DDFAEBC4A608F1F6557C30D685" generalDelegate:nil];
    if (!ret)
    {
        NSLog(@"manager start failed!");
    }

    //百度统计初始化
    BaiduMobStat* statTracker = [BaiduMobStat defaultStat];
    statTracker.enableExceptionLog = YES;
//    statTracker.logStrategy = BaiduMobStatLogStrategyCustom;
//    statTracker.logSendInterval = 1;
    //statTracker.channelId = @"App Store";
    //statTracker.enableExceptionLog = NO;
    [statTracker startWithAppId:@"ec71d9e50a"];
    
    self.viewController = [[LYViewController alloc] initWithNibName:@"LYViewController" bundle:nil];
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:self.viewController];
    self.window.rootViewController = self.navigationController;
    //self.window.rootViewController = self.viewController;
    self.navigationController.delegate = self;
    [self.window makeKeyAndVisible];
//    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];//UIBarStyleBlackTranslucent];
    
    //设置屏幕常亮
    [ [ UIApplication sharedApplication] setIdleTimerDisabled:YES ] ;

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    NSLog(@"applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"applicationDidBecomeActive");
    if (viewController)
    {
        [[viewController comm4AppSvr] sendCmdConnect];
        [viewController sendChechinInfo2TSS];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)navigationController:(UINavigationController *)pnavigationController willShowViewController:(UIViewController *)pviewController animated:(BOOL)animated {
    if ( pviewController ==  self.viewController)
    {
        [pnavigationController setNavigationBarHidden:YES animated:animated];
    } else if ( [pnavigationController isNavigationBarHidden] )
    {
        [pnavigationController setNavigationBarHidden:NO animated:animated];
    }
}

@end
