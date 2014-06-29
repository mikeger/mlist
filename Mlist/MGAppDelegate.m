//
//  MGAppDelegate.m
//  Mlist
//
//  Created by Mihail Gerasimenko on 6/29/14.
//  Copyright (c) 2014 Mike Gerasimenko. All rights reserved.
//

#import "MGAppDelegate.h"
#import "MGListViewController.h"
#import "MGItemDetailViewController.h"
#import <JASidePanels/JASidePanelController.h>

@implementation MGAppDelegate

+ (MGAppDelegate*)appDelegate {
	return (MGAppDelegate*)[[UIApplication sharedApplication] delegate];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[self tweakAppearance];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
	MGListViewController* listController = [MGListViewController viewCtrl];

	UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:listController];

	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		self.sidePanelController = [[JASidePanelController alloc] init];
		self.sidePanelController.leftPanel = [[UINavigationController alloc] initWithRootViewController:listController];
		self.detailController = [[MGItemDetailViewController alloc] initWithNib];
		self.centerNavigationController = [[UINavigationController alloc] initWithRootViewController:self.detailController];
		self.sidePanelController.centerPanel = self.centerNavigationController;
		self.sidePanelController.style = JASidePanelMultipleActive;
		self.sidePanelController.leftFixedWidth = 320.0f;
		[self.sidePanelController showLeftPanel:YES];
		self.sidePanelController.shouldDelegateAutorotateToVisiblePanel = NO;
		self.window.rootViewController = self.sidePanelController;
	}
	else {
		self.window.rootViewController = navigationController;
	}
	[self.window makeKeyAndVisible];

    return YES;
}

- (void)tweakAppearance {
	UIColor* styleColor = [UIColor colorWithRed:102.0f/255.0f green:0.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
	[[UINavigationBar appearance] setTintColor:styleColor];
	[[UINavigationBar appearance] setTitleTextAttributes:@{UITextAttributeTextColor:styleColor}];
	[[UIButton appearance] setTitleColor:styleColor forState:UIControlStateNormal];
	[[UIButton appearance] setTitleColor:styleColor forState:UIControlStateHighlighted];
}

@end
