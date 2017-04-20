//
//  AppDelegate.m
//  SCMap
//
//  Created by SHICHUAN on 2017/4/19.
//  Copyright © 2017年 SHICHUAN. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "PlateViewController.h"
#import "SetViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1.创建窗口
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    
    
    UITabBarController *tvc = [[UITabBarController alloc] init];
    tvc.tabBar.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
    
    MainViewController *main = [[MainViewController alloc] init];
    main.tabBarItem.image = [UIImage imageNamed:@"tab_home_icon"];
    main.tabBarItem.title = @"首页";
    
    PlateViewController *plate = [[PlateViewController alloc] init];
    plate.tabBarItem.image = [UIImage imageNamed:@"js"];
    plate.tabBarItem.title = @"表盘";
    
    tvc.viewControllers = @[main,plate];
    
    // 2.设置窗口的根控制器为导航控制器
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:tvc];
    nvc.navigationBar.hidden = YES;
    
    
    self.window.rootViewController = nvc;
    
    // 3.显示窗口
    [self.window makeKeyAndVisible];
    
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
