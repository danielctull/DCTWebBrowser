//
//  DCTWebViewController.m
//  DCTWebViewController
//
//  Created by Daniel Tull on 04/01/2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "DCTWebBrowser.h"
#import "_DCTWebBrowserActivityController.h"

@interface DCTWebBrowser () <UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *reloadButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, strong) NSMutableArray *viewDidLoadTasks;
@property (nonatomic, strong) NSMutableArray *webViewDidLoadTasks;
@end

@implementation DCTWebBrowser

- (void)dealloc {
	UIWebView *webView = _webView;
	webView.delegate = nil;
	[webView stopLoading];
}

- (id)initWithNibName:(NSString *)name bundle:(NSBundle *)bundle {

	if (name.length == 0) {

		if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
			name = [NSString stringWithFormat:@"%@_iPad", NSStringFromClass([self class])];
		else
			name = [NSString stringWithFormat:@"%@_iPhone", NSStringFromClass([self class])];

		bundle = [[self class] bundle];
	}

	self = [super initWithNibName:name bundle:bundle];
	if (!self) return nil;

	_viewDidLoadTasks = [NSMutableArray new];
	_webViewDidLoadTasks = [NSMutableArray new];
	_doneButtonHidden = YES;

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
		self.navigationItem.rightBarButtonItems = @[self.actionButton, self.forwardButton, self.backButton, self.reloadButton];
	else
		self.toolbarItems = @[
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
			self.reloadButton,
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
			self.backButton,
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
			self.forwardButton,
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
			self.actionButton,
			[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil]
		];

	[self updateButtons];
	
	return self;
}

- (void)setDoneButtonHidden:(BOOL)doneButtonHidden {

	_doneButtonHidden = doneButtonHidden;

	[self addViewDidLoadTask:^(DCTWebBrowser *webBrowser) {
		webBrowser.navigationItem.leftBarButtonItem = doneButtonHidden ? nil : webBrowser.doneButton;
	}];
}

- (void)setTitleHidden:(BOOL)titleHidden {
	_titleHidden = titleHidden;
	self.navigationItem.title = titleHidden ? nil : self.title;
}

- (void)setTitle:(NSString *)title {
	[super setTitle:title];
	self.navigationItem.title = self.titleHidden ? nil : title;
}

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = nil;
	
	[self.viewDidLoadTasks enumerateObjectsUsingBlock:^(void(^task)(DCTWebBrowser *), NSUInteger i, BOOL *stop) {
		task(self);
	}];
	[self.viewDidLoadTasks removeAllObjects];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	UIWebView *webView = self.webView;
	webView.delegate = nil;
	[webView stopLoading];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
		[self.navigationController setToolbarHidden:NO animated:animated];
}

- (UIBarButtonItem *)reloadButton {

	if (!_reloadButton)
		_reloadButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(reload:)];

	return _reloadButton;
}

- (UIBarButtonItem *)backButton {

	if (!_backButton) {
		_backButton = [[UIBarButtonItem alloc] initWithImage:[[self class] imageNamed:@"UIButtonBarArrowLeft"]
										 landscapeImagePhone:[[self class] imageNamed:@"UIButtonBarArrowLeftLandscape"]
													   style:UIBarButtonItemStylePlain
													  target:self
													  action:@selector(goBack:)];
		_backButton.landscapeImagePhoneInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
	}

	return _backButton;
}

- (UIBarButtonItem *)forwardButton {

	if (!_forwardButton) {
		_forwardButton = [[UIBarButtonItem alloc] initWithImage:[[self class] imageNamed:@"UIButtonBarArrowRight"]
											landscapeImagePhone:[[self class] imageNamed:@"UIButtonBarArrowRightLandscape"]
														  style:UIBarButtonItemStylePlain
														 target:self
														 action:@selector(goForward:)];
		_forwardButton.landscapeImagePhoneInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
	}

	return _forwardButton;
}

- (UIBarButtonItem *)actionButton {

	if (!_actionButton)
		_actionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(action:)];
	
	return _actionButton;
}

- (IBAction)reload:(id)sender {
	[self.webView reload];
	[self updateButtons];
}

- (IBAction)goBack:(id)sender {
	[self.webView goBack];
	[self updateButtons];
}

- (IBAction)goForward:(id)sender {
	[self.webView goForward];
	[self updateButtons];
}

- (IBAction)action:(id)sender {
	[_DCTWebBrowserActivityController presentActivityItems:@[self.webView.request.URL]
									 applicationActivities:self.applicationActivities
									 excludedActivityTypes:self.excludedActivityTypes
										fromViewController:self
											 barButtonItem:sender];
}

- (IBAction)done:(id)sender {
	[self.presentingViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)addViewDidLoadTask:(void(^)(DCTWebBrowser *webViewController))task {

	if (self.isViewLoaded) {
		task(self);
		return;
	}

	[self.viewDidLoadTasks addObject:[task copy]];
}

- (void)addWebViewDidLoadTask:(void(^)(DCTWebBrowser *webViewController))task {

	UIWebView *webView = self.webView;
	if (webView && !webView.loading) {
		task(self);
		return;
	}

	[self.webViewDidLoadTasks addObject:[task copy]];
}

- (void)updateButtons {
	UIWebView *webView = self.webView;
	BOOL enabled = ![webView.request.URL.path hasPrefix:self.class.bundle.bundleURL.path];
	self.reloadButton.enabled = enabled;
	self.actionButton.enabled = enabled;
	self.backButton.enabled = [webView canGoBack];
	self.forwardButton.enabled = [webView canGoForward];
}

- (void)evaluateJavaScriptFromString:(NSString *)script completion:(void(^)(NSString *))completion {
	[self addWebViewDidLoadTask:^(DCTWebBrowser *webViewController) {
		NSString *string = [webViewController.webView stringByEvaluatingJavaScriptFromString:script];
		if (completion) completion(string);
	}];
}

- (void)loadRequest:(NSURLRequest *)request {
	[self addViewDidLoadTask:^(DCTWebBrowser *webBrowser) {
		webBrowser.title = request.URL.absoluteString;
		[webBrowser.webView loadRequest:request];
	}];
}

- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL {
	[self addViewDidLoadTask:^(DCTWebBrowser *webViewController) {
		[webViewController.webView loadHTMLString:string baseURL:baseURL];
	}];
}

- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL {
	[self addViewDidLoadTask:^(DCTWebBrowser *webViewController) {
		[webViewController.webView loadData:data MIMEType:MIMEType textEncodingName:textEncodingName baseURL:baseURL];
	}];
}

#pragma mark - UIWebViewDelegate

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

	if ([error.domain isEqualToString:NSURLErrorDomain] && error.code == NSURLErrorCancelled)
		return;

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
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
	[self updateButtons];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	[self updateButtons];

	[self.webViewDidLoadTasks enumerateObjectsUsingBlock:^(void(^task)(DCTWebBrowser *), NSUInteger i, BOOL *stop) {
		task(self);
	}];
	[self.webViewDidLoadTasks removeAllObjects];
}

#pragma mark - Bundle loading

+ (UIImage *)imageNamed:(NSString *)name {
	NSInteger deviceScale = (NSInteger)[[UIScreen mainScreen] scale];
	NSString *systemVersion = [[UIDevice currentDevice] systemVersion];
	NSString *mainVersion = [[systemVersion componentsSeparatedByString:@"."] firstObject];
	NSInteger deviceVersion = [mainVersion integerValue];
	NSBundle *bundle = [self bundle];
	for (NSInteger scale = deviceScale; scale > 0; scale--) {
		NSString *scaleString = (scale == 1) ? @"" : [NSString stringWithFormat:@"@%ix", scale];
		for (NSInteger version = deviceVersion; version > 5; version--) {
			NSString *versionString = (version == 6) ? @"" : [NSString stringWithFormat:@"-iOS%i", version];
			NSString *resourceName = [NSString stringWithFormat:@"%@%@%@", name, scaleString, versionString];
			NSString *path = [bundle pathForResource:resourceName ofType:@"png"];
			UIImage *image = [UIImage imageWithContentsOfFile:path];
			if (image) return image;
		}
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

		NSString *bundleName = [NSString stringWithFormat:@"%@.bundle", NSStringFromClass([self class])];
		for (NSURL *URL in enumerator)
			if ([[URL lastPathComponent] isEqualToString:bundleName])
				bundle = [NSBundle bundleWithURL:URL];
	});
	return bundle;
}

@end
