//
//  AppDelegate.m
//  BMLOL
//
//  Created by donglei on 2/23/16.
//  Copyright © 2016 donglei. All rights reserved.
//

#import "AppDelegate.h"
#import "BMNetworing.h"
#import "NewsTop.h"

@interface AppDelegate()

@end

@implementation AppDelegate
//应用程序完成启动
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    const CGFloat screenWid = [UIScreen mainScreen].bounds.size.width; //定义屏幕的宽度 可再任意地方访问的
    
    
    UITabBarController *tab = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"customTabBar"];
    
//    //设置 navigation 的主题
    UINavigationBar *mainNaviBar = [UINavigationBar  appearance];
    mainNaviBar.barStyle = UIBarStyleBlack; //设置 barstyle 为黑色，使状态栏高亮
    [mainNaviBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_bg_for_seven"] forBarMetrics:UIBarMetricsDefault];
    
    
    //获取顶部的数据
    NSManagedObjectContext *context =  self.managedObjectContext;
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entiy = [NSEntityDescription entityForName:@"NewsTop" inManagedObjectContext:context];
    [fetchRequest setEntity:entiy];
    NSArray *topModel = [context executeFetchRequest:fetchRequest error:nil];
       [BMNetworing BMNetworingWithUrlString:@"http://qt.qq.com/static/pages/news/phone/index.js" commpleWithNSArray:^(NSArray *jsonData) {
        NSLog(@" json数据:%@",jsonData);
           if (topModel.count == 0 ) {  //从数据中查询 数据为空就增加 有就更新
               for (NSDictionary *d  in jsonData){
                   NewsTop *newsTopInfo =   [NSEntityDescription insertNewObjectForEntityForName:@"NewsTop" inManagedObjectContext:context];
                   [newsTopInfo addModelDataWith:d];
                   //保存到数据库中
                   NSError *saveDataToSql;
                   if (![context save:&saveDataToSql]) {
                       NSLog(@"保存失败");
                   }
               }
           }else {
               //删除数据库中的 重新增加
               for (NewsTop *model in topModel){
                   [context deleteObject:model];
               }
               
               
               for (NSDictionary *d  in jsonData){
                   NewsTop *newsTopInfo =   [NSEntityDescription insertNewObjectForEntityForName:@"NewsTop" inManagedObjectContext:context];
                   [newsTopInfo addModelDataWith:d];
                   //保存到数据库中
                   NSError *saveDataToSql;
                   if (![context save:&saveDataToSql]) {
                       NSLog(@"保存失败");
                   }
               }
               
           }
               
           
     } ];
    
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


#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "cn.bamboomoon.coreData" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"coreData.sqlite"];
   
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}


@end
