//
//  DCTWebViewController.m
//  DCTWebViewController
//
//  Created by Daniel Tull on 04/01/2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTWebViewController.h"

@interface DCTWebViewController () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previousButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@end

@implementation DCTWebViewController {
	BOOL _canPerformAction;
	void (^_request)();
	dispatch_once_t _toolbarToken;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	NSBundle *bundle = [[self class] bundle];
	return [super initWithNibName:@"DCTWebViewController" bundle:bundle];
}

- (UIView *)rotatingHeaderView {
	return self.navigationBar;
}

- (UIView *)rotatingFooterView {
	return self.toolbar;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	[self _updateButtons];
	self.previousButton.landscapeImagePhone = [[self class] imageNamed:@"UIButtonBarArrowLeftLandscape"];
	self.nextButton.landscapeImagePhone = [[self class] imageNamed:@"UIButtonBarArrowRightLandscape"];
	if (_request != NULL) {
		_request();
		_request = NULL;
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	dispatch_once(&_toolbarToken, ^{
		UINavigationController *navigationController = self.navigationController;
		if (navigationController) {
			[self.navigationController setToolbarHidden:NO animated:animated];
			[self setToolbarItems:self.toolbar.items animated:animated];
			self.webView.frame = self.view.bounds;
			[self.toolbar removeFromSuperview];
			[self.navigationBar removeFromSuperview];
		}
	});
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
	_canPerformAction = YES;
	[self.webView goBack];
}

- (IBAction)goForward:(id)sender {
	_canPerformAction = YES;
	[self.webView goForward];
}

- (IBAction)done:(id)sender {
}

- (void)_updateButtons {
	self.reloadButton.enabled = _canPerformAction;
	self.previousButton.enabled = [self.webView canGoBack];
	self.nextButton.enabled = [self.webView canGoForward];
	self.actionButton.enabled = _canPerformAction;
}

- (void)loadRequest:(NSURLRequest *)request {
	[self _loadRequestBlock:^{
		_canPerformAction = YES;
		[self.webView loadRequest:request];
	}];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
	[self _loadRequestBlock:^{
		_canPerformAction = YES;
		[self.webView loadHTMLString:string baseURL:baseURL];
	}];
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL {
	[self _loadRequestBlock:^{
		_canPerformAction = YES;
		[self.webView loadData:data MIMEType:MIMEType textEncodingName:textEncodingName baseURL:baseURL];
	}];
}

- (void)_loadRequestBlock:(void(^)())block {
	if (self.isViewLoaded) {
		block();
		return;
	}
	_request = [block copy];
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

	NSBundle *bundle = [[self class] bundle];
	NSURL *formatHTMLURL = [bundle URLForResource:@"StandardError" withExtension:@"html"];

	NSString *HTMLString = [NSString stringWithContentsOfURL:formatHTMLURL
													encoding:NSUTF8StringEncoding
													   error:NULL];

	NSString *errorString = [error localizedDescription];
	HTMLString = [HTMLString stringByReplacingOccurrencesOfString:@"%error%" withString:errorString];

	NSString *device = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? @"ipad" : @"iphone";
	HTMLString = [HTMLString stringByReplacingOccurrencesOfString:@"%device%" withString:device];

	[self loadHTMLString:HTMLString baseURL:[bundle bundleURL]];
	_canPerformAction = NO;
	[self _updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self _updateButtons];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[self _updateButtons];
}

#pragma mark - Bundle loading

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
