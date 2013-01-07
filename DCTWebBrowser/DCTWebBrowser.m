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
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *forwardButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *reloadButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *actionButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *doneButton;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation DCTWebBrowser {
	NSMutableArray *_viewDidLoadTasks;
	dispatch_once_t _toolbarToken;
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
	self.backButton.landscapeImagePhone = [[self class] imageNamed:@"UIButtonBarArrowLeftLandscape"];
	self.backButton.landscapeImagePhoneInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
	self.forwardButton.landscapeImagePhone = [[self class] imageNamed:@"UIButtonBarArrowRightLandscape"];
	self.forwardButton.landscapeImagePhoneInsets = UIEdgeInsetsMake(2.0f, 0.0f, -2.0f, 0.0f);
	self.titleLabel.text = nil;
	[_viewDidLoadTasks enumerateObjectsUsingBlock:^(void(^task)(DCTWebBrowser *), NSUInteger i, BOOL *stop) {
		task(self);
	}];
	[_viewDidLoadTasks removeAllObjects];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	dispatch_once(&_toolbarToken, ^{

		if (self.presentingViewController)
			self.navigationItem.leftBarButtonItem = self.doneButton;
		
		if (self.navigationController) {
			[self setToolbarItems:self.toolbar.items animated:animated];
			[self.navigationController setToolbarHidden:NO animated:animated];
			self.webView.frame = self.view.bounds;
			self.navigationItem.titleView = self.titleLabel;
			[self.toolbar removeFromSuperview];
			[self.navigationBar removeFromSuperview];

			if (self.presentingViewController)
				self.navigationItem.leftBarButtonItem = self.doneButton;

		} else if (self.presentingViewController)
			self.navigationBar.topItem.leftBarButtonItem = self.doneButton;
	});
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

	[_viewDidLoadTasks addObject:[task copy]];
}

- (void)updateButtons {
	BOOL enabled = ![self.webView.request.URL.path hasPrefix:self.class.bundle.bundleURL.path];
	self.reloadButton.enabled = enabled;
	self.actionButton.enabled = enabled;
	self.backButton.enabled = [self.webView canGoBack];
	self.forwardButton.enabled = [self.webView canGoForward];
}

- (void)loadRequest:(NSURLRequest *)request {
	[self addViewDidLoadTask:^(DCTWebBrowser *webViewController) {
		self.titleLabel.text = request.URL.absoluteString;
		[webViewController.webView loadRequest:request];
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
	self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
	[self updateButtons];
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

		NSString *bundleName = [NSString stringWithFormat:@"%@.bundle", NSStringFromClass([self class])];
		for (NSURL *URL in enumerator)
			if ([[URL lastPathComponent] isEqualToString:bundleName])
				bundle = [NSBundle bundleWithURL:URL];
	});
	return bundle;
}

@end
