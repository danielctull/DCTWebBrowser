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

@implementation DCTWebViewController {
	NSURLRequest *_request;
}

- (id)initWithRequest:(NSURLRequest *)URLRequest {
	NSBundle *bundle = [[self class] bundle];
	self = [self initWithNibName:@"DCTWebViewController" bundle:bundle];
	if (!self) return nil;
	_request = URLRequest;
	return self;
}

- (UIView *)rotatingHeaderView {
	return self.navigationBar;
}

- (UIView *)rotatingFooterView {
	return self.toolbar;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self.webView loadRequest:_request];
	[self _updateButtons];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	UINavigationController *navigationController = self.navigationController;
	if (navigationController) {
		[self.navigationController setToolbarHidden:NO animated:animated];
		[self setToolbarItems:self.toolbar.items animated:animated];
		self.webView.frame = self.view.bounds;
		[self.toolbar removeFromSuperview];
		[self.navigationBar removeFromSuperview];
	}
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	
}

- (IBAction)refresh:(id)sender {
	[self.webView reload];
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

- (void)_updateButtons {
	self.nextButton.enabled = [self.webView canGoForward];
	self.previousButton.enabled = [self.webView canGoBack];
}

+ (UIImage *)imageNamed:(NSString *)name {
	NSInteger scale = (NSInteger)[[UIScreen mainScreen] scale];
	NSBundle *bundle = [self bundle];
	while (scale > 0) {
		NSString *resourceName = (scale == 1) ? name : [NSString stringWithFormat:@"%@@%ix", name, scale];
		NSString *path = [bundle pathForResource:resourceName ofType:@"png"];
		UIImage *image = [UIImage imageWithContentsOfFile:path];
		if (image) return image;
		scale--;
	}
	return nil;
}

+ (NSBundle *)bundle {
	static NSBundle *bundle = nil;
	static dispatch_once_t bundleToken;
	dispatch_once(&bundleToken, ^{
		NSDirectoryEnumerator *enumerator = [[NSFileManager new] enumeratorAtURL:[[NSBundle mainBundle] bundleURL]
													  includingPropertiesForKeys:nil
																		 options:NSDirectoryEnumerationSkipsHiddenFiles
																	errorHandler:NULL];

		for (NSURL *URL in enumerator)
			if ([[URL lastPathComponent] isEqualToString:@"DCTWebViewController.bundle"])
				bundle = [NSBundle bundleWithURL:URL];
	});
	return bundle;
}

@end
