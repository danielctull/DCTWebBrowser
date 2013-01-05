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
	DCTWebViewController *webViewController = [DCTWebViewController new];
	self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:webViewController];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://apple.com"]];
	[webViewController loadRequest:request];
	[self.window makeKeyAndVisible];
	return YES;
}

@end
