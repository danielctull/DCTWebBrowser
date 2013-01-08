//
//  ViewController.m
//  DCTWebBrowser
//
//  Created by Daniel Tull on 08.01.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "ViewController.h"
#import <DCTWebBrowser/DCTWebBrowser.h>

@implementation ViewController

- (DCTWebBrowser *)newWebBrowser {
	DCTWebBrowser *webBrowser = [DCTWebBrowser new];
	NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://t.co/dCJRhZqo"]];
	[webBrowser loadRequest:request];
	return webBrowser;
}

- (IBAction)push:(id)sender {
	[self.navigationController pushViewController:[self newWebBrowser] animated:YES];
}

- (IBAction)presentWithNavigationController:(id)sender {
	UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[self newWebBrowser]];
	[self presentViewController:navigationController animated:YES completion:NULL];
}

- (IBAction)presentWithoutNavigationController:(id)sender {
	[self presentViewController:[self newWebBrowser] animated:YES completion:NULL];
}

@end