//
//  AppDelegate.m
//  DCTWebViewControllerDemo
//
//  Created by Daniel Tull on 04/01/2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "AppDelegate.h"
#import <DCTWebViewController/DCTWebViewController.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://apple.com"]];
	DCTWebViewController *webViewController = [[DCTWebViewController alloc] initWithRequest:request];
	self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:webViewController];
	[self.window makeKeyAndVisible];
	return YES;
}

@end
