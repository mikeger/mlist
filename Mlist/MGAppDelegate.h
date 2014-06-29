//
//  MGAppDelegate.h
//  Mlist
//
//  Created by Mihail Gerasimenko on 6/29/14.
//  Copyright (c) 2014 Mike Gerasimenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JASidePanelController, MGItemDetailViewController;

@interface MGAppDelegate : UIResponder <UIApplicationDelegate>
+ (MGAppDelegate*)appDelegate;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) JASidePanelController* sidePanelController;
@property (strong, nonatomic) UINavigationController* centerNavigationController;
@property (strong, nonatomic) MGItemDetailViewController* detailController;
@end
