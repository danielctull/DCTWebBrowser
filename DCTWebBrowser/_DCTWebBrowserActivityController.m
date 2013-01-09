//
//  _DCTWebViewControllerActivityController.m
//  DCTWebViewController
//
//  Created by Daniel Tull on 05.01.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "_DCTWebBrowserActivityController.h"
#import <objc/runtime.h>

void* _DCTWebViewControllerActivityControllerContext = &_DCTWebViewControllerActivityControllerContext;

@interface _DCTWebBrowserActivityController () <UIPopoverControllerDelegate>
@end

@implementation _DCTWebBrowserActivityController {
	UIPopoverController *_popoverController;
}

+ (void)presentActivityItems:(NSArray *)activityItems
	   applicationActivities:(NSArray *)applicationActivities
		  fromViewController:(UIViewController *)viewController
			   barButtonItem:(UIBarButtonItem *)item {

	UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
																						 applicationActivities:applicationActivities];

	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		[viewController presentViewController:activityViewController animated:YES completion:NULL];
		return;
	}

	_DCTWebBrowserActivityController *controller = [self new];
	UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
	popoverController.delegate = controller;
	controller->_popoverController = popoverController;
	objc_setAssociatedObject(popoverController, _DCTWebViewControllerActivityControllerContext, controller, OBJC_ASSOCIATION_RETAIN);
	[popoverController presentPopoverFromBarButtonItem:item
							  permittedArrowDirections:UIPopoverArrowDirectionAny
											  animated:YES];
	popoverController.passthroughViews = @[];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	_popoverController = nil;
}

@end
