//
//  _DCTWebViewControllerActivityController.h
//  DCTWebViewController
//
//  Created by Daniel Tull on 05.01.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

@import UIKit;

@interface _DCTWebBrowserActivityController : NSObject

+ (void)presentActivityItems:(NSArray *)activityItems
	   applicationActivities:(NSArray *)applicationActivities
	   excludedActivityTypes:(NSArray *)excludedActivityTypes
		  fromViewController:(UIViewController *)viewController
			   barButtonItem:(UIBarButtonItem *)item;

@end
