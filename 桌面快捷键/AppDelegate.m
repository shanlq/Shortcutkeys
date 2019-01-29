//
//  AppDelegate.m
//  桌面快捷键
//
//  Created by apple on 17/7/5.
//  Copyright © 2017年 slq. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
//创建本地服务器
#import "HTTPServer.h"
#import "DDLog.h"
#import "DDTTYLogger.h"


@interface AppDelegate ()

@property (nonatomic, strong) HTTPServer *httpServer;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[ViewController alloc] init]];
    [self.window makeKeyWindow];
    
    return YES;
}

//点击app启动时不走该方法，点击快捷键启动app时才会走该方法，可用来判断是否要跳转到指定界面。
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    NSLog(@"快捷键启动app时 传递的参数 = %@", [url query]);
    NSLog(@"app的自定义Scheme = %@， 用来判断是否是快捷键启动的app", [url scheme]);
    
    if([[url query] isEqualToString:@"ABCD"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"JumpToSecondVC" object:nil];
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ShortKeyOut"];
    }
    
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
