//
//  DCTWebViewController.m
//  DCTWebViewController
//
//  Created by Daniel Tull on 04/01/2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTWebViewController.h"

@interface DCTWebViewController ()
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@end

@implementation DCTWebViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	self.rotatingHeaderView = self.navigationBar;
	self.rotatingFooterView = self.toolbar;
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
}

- (IBAction)refresh:(id)sender {
}

- (IBAction)action:(id)sender {
}

- (IBAction)goBack:(id)sender {
	[self.webView goBack];
}

- (IBAction)goForward:(id)sender {
	[self.webView goForward];
}

- (IBAction)done:(id)sender {
}

@end
