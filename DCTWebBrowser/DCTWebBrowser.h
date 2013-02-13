//
//  DCTWebViewController.h
//  DCTWebViewController
//
//  Created by Daniel Tull on 04/01/2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DCTWebBrowser : UIViewController

- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;
- (void)evaluateJavaScriptFromString:(NSString *)script completion:(void(^)(NSString *))completion;

@property (nonatomic, copy) NSArray *applicationActivities;
@property (nonatomic, assign) BOOL doneButtonHidden;
@property (nonatomic, assign) BOOL titleHidden;

@end
