//
//  AppDelegate.m
//  BMLOL
//
//  Created by donglei on 2/23/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


//应用程序完成启动
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //在这里去加载 herolist  和 heroinfo
    NSLog(@"ssss");
    NSURLSession *getHeroList = [NSURLSession sharedSession];
 NSURLSessionDataTask *data = [getHeroList dataTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://ossweb-img.qq.com/upload/qqtalk/lol_hero/hero_list.js"]] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
   NSDictionary * d  =   [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
     
        NSLog(@"%@--%@  name:%d",d,response,[NSThread currentThread].isMainThread);
    
    }];

    [data resume];
    
    return YES;
}

//获得焦点  用户可与屏幕交互
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

//应用程序进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//进入前台
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


//获得焦点
- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

//应用程序关闭
- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
