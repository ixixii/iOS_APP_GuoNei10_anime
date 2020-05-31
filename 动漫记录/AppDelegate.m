//
//  AppDelegate.m
//  动漫记录
//
//  Created by beyond on 2020/5/25.
//  Copyright © 2020 sg32. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self copyFilmDataPlistToDoc];
    [self copyFilmUnWatchDataPlistToDoc];
    return YES;
}

#pragma mark - 帅哥动漫代码段
- (void)copyFilmDataPlistToDoc
{
    // 添加额外的
    NSString *bundlePath = [kMainBundle pathForResource:[NSString stringWithFormat:@"encode_%@",@"film_data"] ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:bundlePath];
    // 不存在，才要copy  sg__这儿要区别:如果是帅哥发布了新的版本,则要强行替换!!!
    if (![[NSFileManager defaultManager] fileExistsAtPath:kFilmDataPlistPathInDoc]) {
        [data writeToFile:kFilmDataPlistPathInDoc atomically:YES];
    }
}
#pragma mark - 帅哥动漫_未看的动漫代码段
- (void)copyFilmUnWatchDataPlistToDoc
{
    // 添加额外的
    NSString *bundlePath = [kMainBundle pathForResource:[NSString stringWithFormat:@"encode_%@",@"film_unwatch_data"] ofType:nil];
    NSData *data = [NSData dataWithContentsOfFile:bundlePath];
    // 不存在，才要copy  sg__这儿要区别:如果是帅哥发布了新的版本,则要强行替换!!!
    if (![[NSFileManager defaultManager] fileExistsAtPath:kFilmUnWatchDataPlistPathInDoc]) {
        [data writeToFile:kFilmUnWatchDataPlistPathInDoc atomically:YES];
    }
}


#pragma mark - UISceneSession lifecycle


- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
    // Called when a new scene session is being created.
    // Use this method to select a configuration to create the new scene with.
    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
}


- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
    // Called when the user discards a scene session.
    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
}


@end
