//
//  AppDelegate.m
//  SX_YMXK_A
//
//  Created by dllo on 16/9/19.
//  Copyright © 2016年 rain. All rights reserved.
//

#import "AppDelegate.h"
#import "NewsViewController.h"
#import "GameListViewController.h"
#import "SubscribeViewController.h"
#import "SX_MenuViewController.h"
#import "AFNetworking.h"
#import "JXLDayAndNightMode.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_window makeKeyAndVisible];
    
    
    NewsViewController *newsVC = [[NewsViewController alloc] init];
    UINavigationController *newsNC = [[UINavigationController alloc] initWithRootViewController:newsVC];
    

    GameListViewController *gameListVC = [[GameListViewController alloc] init];
    UINavigationController *gameListNC = [[UINavigationController alloc] initWithRootViewController:gameListVC];
    

    
    SubscribeViewController *subscribeVC = [[SubscribeViewController alloc] init];
    UINavigationController *subscribeNC = [[UINavigationController alloc] initWithRootViewController:subscribeVC];
    
    newsVC.tabBarItem.image = [[UIImage imageNamed:@"common_Button_XinWen_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    newsVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"common_Button_XinWen_Selected_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    gameListVC.tabBarItem.image = [[UIImage imageNamed:@"common_Button_YouXiKu_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    gameListVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"common_Button_YouXiKu_Selected_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    subscribeVC.tabBarItem.image = [[UIImage imageNamed:@"common_Button_DingYue_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    subscribeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"common_Button_DingYue_Selected_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    
    
    UITabBarController *rootTC = [[UITabBarController alloc] init];
    rootTC.viewControllers = @[newsNC, gameListNC, subscribeNC];

    [rootTC.tabBar jxl_setDayMode:^(UIView *view) {
        rootTC.tabBar.barTintColor = [UIColor colorWithRed:0.9672 green:0.9621 blue:0.9723 alpha:1.0];
        newsVC.tabBarItem.image = [[UIImage imageNamed:@"common_Button_XinWen_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        newsVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"common_Button_XinWen_Selected_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        gameListVC.tabBarItem.image = [[UIImage imageNamed:@"common_Button_YouXiKu_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        gameListVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"common_Button_YouXiKu_Selected_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        subscribeVC.tabBarItem.image = [[UIImage imageNamed:@"common_Button_DingYue_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        subscribeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"common_Button_DingYue_Selected_UIMode_Day"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    } nightMode:^(UIView *view) {
        rootTC.tabBar.barTintColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.75];
        
        newsVC.tabBarItem.image = [[UIImage imageNamed:@"common_Button_XinWen_UIMode_Night"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        newsVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"common_Button_XinWen_Selected_UIMode_Night"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        gameListVC.tabBarItem.image = [[UIImage imageNamed:@"common_Button_YouXiKu_UIMode_Night"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        gameListVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"common_Button_YouXiKu_Selected_UIMode_Night"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        subscribeVC.tabBarItem.image = [[UIImage imageNamed:@"common_Button_DingYue_UIMode_Night"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        subscribeVC.tabBarItem.selectedImage = [[UIImage imageNamed:@"common_Button_DingYue_Selected_UIMode_Night"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    }];
    
    SX_MenuViewController *menuVC = [[SX_MenuViewController alloc] init];
    [menuVC addChildViewController:rootTC];
    [menuVC.view addSubview:rootTC.view];
    UINavigationController *menuNC = [[UINavigationController alloc] initWithRootViewController:menuVC];
    
    
    _window.rootViewController = menuNC;
    
    [self reachbility];
    
    
    return YES;
}


- (void)reachbility {
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:{
                NSLog(@"未识别的网络");
                break;
            }
            case AFNetworkReachabilityStatusNotReachable:{
                NSLog(@"不可达的网络");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWiFi:{
                NSLog(@"WIFI");
                break;
            }
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                NSLog(@"蜂窝网络");
                break;
            }
            default:
                break;
        }
    }];
    [manager startMonitoring];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
