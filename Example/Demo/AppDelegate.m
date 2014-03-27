//
//  AppDelegate.m
//  Demo
//
//  Created by Aleksander Zubala on 27/03/14.
//  Copyright (c) 2014 Aleksander Zubala. All rights reserved.
//

#import "AppDelegate.h"
#import "RootViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [RootViewController new];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
