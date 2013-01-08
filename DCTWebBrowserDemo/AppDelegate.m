//
//  AppDelegate.m
//  DCTWebViewControllerDemo
//
//  Created by Daniel Tull on 04/01/2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	UIViewController *viewController = [ViewController new];
	viewController.title = @"DCTWebBrowser";
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
	self.window.rootViewController = navigationController;
	[self.window makeKeyAndVisible];
	return YES;
}

@end
