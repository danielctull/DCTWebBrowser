//
//  AppDelegate.m
//  DCTWebViewControllerDemo
//
//  Created by Daniel Tull on 04/01/2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "AppDelegate.h"
#import <DCTWebBrowser/DCTWebBrowser.h>

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	UIViewController *viewController = [UIViewController new];
	self.window.rootViewController = viewController;
	[self.window makeKeyAndVisible];

	dispatch_async(dispatch_get_main_queue(), ^{
		DCTWebBrowser *webBrowser = [DCTWebBrowser new];
		//UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webBrowser];
		NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://apple.com"]];
		[webBrowser loadRequest:request];
		[viewController presentViewController:webBrowser animated:YES completion:NULL];
	});
	
	return YES;
}

@end
