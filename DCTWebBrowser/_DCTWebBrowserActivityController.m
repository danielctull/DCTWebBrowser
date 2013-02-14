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
@property (nonatomic, strong) UIPopoverController *popoverController;
@end

@implementation _DCTWebBrowserActivityController

+ (void)presentActivityItems:(NSArray *)activityItems
	   applicationActivities:(NSArray *)applicationActivities
	   excludedActivityTypes:(NSArray *)excludedActivityTypes
		  fromViewController:(UIViewController *)viewController
			   barButtonItem:(UIBarButtonItem *)item {

	UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:activityItems
																						 applicationActivities:applicationActivities];
	activityViewController.excludedActivityTypes = excludedActivityTypes;

	if (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad) {
		[viewController presentViewController:activityViewController animated:YES completion:NULL];
		return;
	}

	_DCTWebBrowserActivityController *controller = [self new];
	UIPopoverController *popoverController = [[UIPopoverController alloc] initWithContentViewController:activityViewController];
	popoverController.delegate = controller;
	controller.popoverController = popoverController;
	objc_setAssociatedObject(popoverController, _DCTWebViewControllerActivityControllerContext, controller, OBJC_ASSOCIATION_RETAIN);
	[popoverController presentPopoverFromBarButtonItem:item
							  permittedArrowDirections:UIPopoverArrowDirectionAny
											  animated:YES];
	popoverController.passthroughViews = @[];
}

- (void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	self.popoverController = nil;
}

@end
