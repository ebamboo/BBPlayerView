//
//  AppDelegate.m
//  BBPlayerView
//
//  Created by 姚旭 on 2021/7/3.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[RootViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
