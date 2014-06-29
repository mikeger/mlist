//
//  MGItemDetailViewController.m
//  Mlist
//
//  Created by Mihail Gerasimenko on 6/29/14.
//  Copyright (c) 2014 Mike Gerasimenko. All rights reserved.
//

#import "MGItemDetailViewController.h"
#import <FontAwesome-iOS/NSString+FontAwesome.h>
#import "MGAppDelegate.h"
#import <JASidePanels/JASidePanelController.h>
@import QuartzCore;

@interface MGItemDetailViewController ()
@property (nonatomic, strong) IBOutlet UITextView*	textView;
@property (nonatomic, strong) IBOutlet UIView*		backgroundView;
@end

@implementation MGItemDetailViewController

- (void)dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.textView.text = self.item.text;
	self.title = self.item.text;
	self.textView.font = [UIFont fontWithName:@"TakeMeOut" size:25.0f];

	[self.textView becomeFirstResponder];

	[self updateForNewText];

	UIButton* bttLeft = [UIButton buttonWithType:UIButtonTypeCustom];

	bttLeft.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18.0f];
	[bttLeft addTarget:self action:@selector(backPressed) forControlEvents:UIControlEventTouchUpInside];
	bttLeft.frame = CGRectMake(0.0f, 0.0f, 29.0f, 29.0f);
	
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[bttLeft setTitle:[NSString awesomeIcon:FaArrowsH] forState:UIControlStateNormal];
	}
	else {
		[bttLeft setTitleEdgeInsets:UIEdgeInsetsMake(2.0f, 0.0f, 0.0f, 0.0f)];
		[bttLeft setTitle:[NSString awesomeIcon:FaChevronLeft] forState:UIControlStateNormal];
	}
	
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bttLeft];

	UIButton* bttEdit = [UIButton buttonWithType:UIButtonTypeCustom];
	bttEdit.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18.0];
	[bttEdit setTitle:[NSString awesomeIcon:FaPencil] forState:UIControlStateNormal];
	[bttEdit setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
	[bttEdit addTarget:self action:@selector(editPressed) forControlEvents:UIControlEventTouchUpInside];
	bttEdit.frame = CGRectMake(0, 0, 29, 29);
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bttEdit];


	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewDidUnload {
	[super viewDidUnload];

	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

	self.item.text = self.textView.text;
	[self.item save];
}

- (BOOL)shouldAutorotate {
	return YES;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
	return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
	return UIInterfaceOrientationMaskAll;
}

- (void)updateForNewText {
	self.textView.text = self.item.text;
	self.title = self.item.text;
}

- (void)backPressed {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[[MGAppDelegate appDelegate].sidePanelController toggleLeftPanel:nil];
	}
	else {
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)editPressed {
	self.textView.editable = !self.textView.editable;
}

- (void)onKeyboardShow:(NSNotification*)notification {
	CGRect kbFrame = [[notification.userInfo valueForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
	kbFrame = [self.view convertRect:kbFrame fromView:nil];
	self.backgroundView.height = self.view.height - 20.0f - kbFrame.size.height;
	self.textView.height = self.view.height - 20.0f - kbFrame.size.height;
}

#pragma mark - Accessors

- (void)setItem:(MGListItem *)item {
	_item = item;
	
	[self updateForNewText];
}

#pragma mark - UITextView Delegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	NSString* newString = [textView.text stringByReplacingCharactersInRange:range withString:text];
	self.item.text = newString;
	[self.item save];
	self.title = self.item.text;
	return YES;
}

@end
