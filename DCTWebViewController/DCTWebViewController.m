//
//  DCTWebViewController.m
//  DCTWebViewController
//
//  Created by Daniel Tull on 04/01/2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTWebViewController.h"

@interface DCTWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation DCTWebViewController
- (void)viewDidUnload {
	[self setWebView:nil];
	[super viewDidUnload];
}
@end
