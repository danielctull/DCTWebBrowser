//
//  DCTWebBrowser.h
//  DCTWebBrowser
//
//  Created by Daniel Tull on 04/01/2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

@import UIKit;

//! Project version number and string for DCTWebBrowser.
FOUNDATION_EXPORT double DCTWebBrowserVersionNumber;
FOUNDATION_EXPORT const unsigned char DCTWebBrowserVersionString[];

@interface DCTWebBrowser : UIViewController

- (void)loadRequest:(NSURLRequest *)request;
- (void)loadHTMLString:(NSString *)string baseURL:(NSURL *)baseURL;
- (void)loadData:(NSData *)data MIMEType:(NSString *)MIMEType textEncodingName:(NSString *)textEncodingName baseURL:(NSURL *)baseURL;
- (void)evaluateJavaScriptFromString:(NSString *)script completion:(void(^)(NSString *))completion;

@property (nonatomic, copy) NSArray *applicationActivities;
@property (nonatomic, copy) NSArray *excludedActivityTypes; // default is nil. activity types listed will not be displayed

@property (nonatomic, assign) BOOL doneButtonHidden;
@property (nonatomic, assign) BOOL titleHidden;

@end
