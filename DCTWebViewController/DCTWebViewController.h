//
//  DCTWebViewController.h
//  DCTWebViewController
//
//  Created by Daniel Tull on 04/01/2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCTWebViewController : UIViewController

- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;

@property (nonatomic, getter=isToolbarHidden) BOOL toolbarHidden; // Default is NO
- (void)setToolbarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
