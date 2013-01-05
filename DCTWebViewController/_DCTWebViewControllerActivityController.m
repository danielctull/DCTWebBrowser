//
//  _DCTWebViewControllerActivityController.m
//  DCTWebViewController
//
//  Created by Daniel Tull on 05.01.2013.
//  Copyright (c) 2013 Daniel Tull. All rights reserved.
//

#import "_DCTWebViewControllerActivityController.h"
#import <objc/runtime.h>

void* _DCTWebViewControllerActivityControllerContext = &_DCTWebViewControllerActivityControllerContext;

@interface _DCTWebViewControllerActivityController () <UIPopoverControllerDelegate>
@end

@implementation _DCTWebViewControllerActivityController {
	UIPopoverController *_popoverController;
}

+ (void)presentActivityItems:(NSArray *)activityItems
		  fromViewController:(UIViewController *)viewController
			   barButtonItem:(UIBarButtonItem *)item {

	UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
																						 applicationActivities:nil];

	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		[viewController presentViewController:activityViewController animated:YES completion:NULL];
		return;
	}

	_DCTWebViewControllerActivityController *controller = [self new];
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
