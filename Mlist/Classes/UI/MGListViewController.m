//
//  MGListViewController.m
//  Mlist
//
//  Created by Mihail Gerasimenko on 6/29/14.
//  Copyright (c) 2014 Mike Gerasimenko. All rights reserved.
//

#import "MGListViewController.h"
#import "MGItemCell.h"
#import "MGItemDetailViewController.h"
#import <FontAwesome-iOS/NSString+FontAwesome.h>
#import "MGAppDelegate.h"
@import QuartzCore;
#import <JASidePanels/JASidePanelController.h>

@interface MGListViewController ()
@property (nonatomic, strong) IBOutlet	UITableView*				tableView;
@property (nonatomic, strong)			UIButton*					bttEdit;
@property (nonatomic, strong)			NSFetchedResultsController* fetchController;
@property (nonatomic, assign)			BOOL						userDrivenDataModelChange;
@end

@implementation MGListViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	// Navigation item initialization.
	self.title = NSLocalizedString(@"Notes", @"");

	UIButton* bttEdit = [UIButton buttonWithType:UIButtonTypeCustom];
	bttEdit.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:18.0];
	[bttEdit setTitle:[NSString awesomeIcon:FaPencil] forState:UIControlStateNormal];
	[bttEdit setTitleEdgeInsets:UIEdgeInsetsMake(0, 4, 0, 0)];
	[bttEdit addTarget:self action:@selector(editPressed) forControlEvents:UIControlEventTouchUpInside];
	bttEdit.frame = CGRectMake(0, 0, 29, 29);
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bttEdit];
	self.bttEdit = bttEdit;

	UIButton* bttAdd = [UIButton buttonWithType:UIButtonTypeCustom];
	bttAdd.titleLabel.font = [UIFont fontWithName:@"FontAwesome" size:20.0];
	[bttAdd setTitle:[NSString awesomeIcon:FaPlus] forState:UIControlStateNormal];
	[bttAdd setTitleEdgeInsets:UIEdgeInsetsMake(2, 0, 0, 0)];
	[bttAdd addTarget:self action:@selector(addPressed) forControlEvents:UIControlEventTouchUpInside];
	bttAdd.frame = CGRectMake(0, 0, 29, 29);
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:bttAdd];

	// Fetch controller creation.
	NSFetchRequest* request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([MGListItem class])];
	NSSortDescriptor* descriptor = [NSSortDescriptor sortDescriptorWithKey:@"sortID" ascending:NO];
	request.sortDescriptors = [NSArray arrayWithObject:descriptor];

	NSManagedObjectContext* mac = [MGDatabaseCoordinator sharedCoordinator].managedObjectContext;
	self.fetchController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
															   managedObjectContext:mac
																 sectionNameKeyPath:nil
																		  cacheName:nil];
	self.fetchController.delegate = self;
	NSError* error = nil;
	[self.fetchController performFetch:&error];
	[self.tableView reloadData];
	if (error != nil) {
		NSLog(@"Error: %@", error);
	}

	UIView *backView = [[UIView alloc] init];
	[self.tableView setBackgroundView:backView];

	if ([[[self.fetchController.sections objectAtIndex:0] objects] count] != 0) {
		[MGAppDelegate appDelegate].detailController.item = [[[self.fetchController.sections objectAtIndex:0] objects] objectAtIndex:0];
	}
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

#pragma mark - Actions

- (void)editPressed {
	[self.tableView setEditing:!self.tableView.editing animated:YES];
	self.bttEdit.selected = self.tableView.editing;
}

- (void)addPressed {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[MGAppDelegate appDelegate].detailController.item = [MGListItem object];
	}
	else {
		MGItemDetailViewController* detail = [MGItemDetailViewController viewCtrl];
		MGListItem* item = [MGListItem object];
		detail.item = item;
		[self.navigationController pushViewController:detail animated:YES];
	}

}

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	if (self.userDrivenDataModelChange) {
		return;
	}

    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
	   atIndexPath:(NSIndexPath *)indexPath
	 forChangeType:(NSFetchedResultsChangeType)type
	  newIndexPath:(NSIndexPath *)newIndexPath {
	if (self.userDrivenDataModelChange) {
		return;
	}

    switch(type) {

        case NSFetchedResultsChangeInsert:
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeUpdate:
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
								  withRowAnimation:UITableViewRowAnimationNone];
            break;

        case NSFetchedResultsChangeMove:
            [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
								  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex
	 forChangeType:(NSFetchedResultsChangeType)type {
	if (self.userDrivenDataModelChange) {
		return;
	}
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
						  withRowAnimation:UITableViewRowAnimationFade];
            break;

        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
						  withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	if (self.userDrivenDataModelChange) {
		return;
	}

	[self.tableView endUpdates];
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	MGItemCell* cell = [self.tableView dequeueReusableCellWithIdentifier:[MGItemCell reuseIdentifier]];

	if (cell == nil) {
		cell = [MGItemCell instanceWithXib];
	}

	cell.item = [self.fetchController objectAtIndexPath:indexPath];
	return cell;
}

- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath {
	if (editingStyle == UITableViewCellEditingStyleDelete) {
		[[self.fetchController objectAtIndexPath:indexPath] delete];
		NSError* err = nil;
		[[MGDatabaseCoordinator sharedCoordinator].managedObjectContext save:&err];
		if (err != nil) {
			NSLog(@"Error: %@", err);
		}
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		[MGAppDelegate appDelegate].detailController.item = [self.fetchController objectAtIndexPath:indexPath];
	}
	else {
		MGItemDetailViewController* detail = [MGItemDetailViewController viewCtrl];
		detail.item = [self.fetchController objectAtIndexPath:indexPath];
		[self.navigationController pushViewController:detail animated:YES];
	}
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView
		   editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleDelete;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [MGItemCell defaultHeight];
}

- (void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
	  toIndexPath:(NSIndexPath *)destinationIndexPath {
	self.userDrivenDataModelChange = YES;
	MGListItem* item1 = [self.fetchController objectAtIndexPath:sourceIndexPath];
	MGListItem* item2 = [self.fetchController objectAtIndexPath:destinationIndexPath];
	NSNumber* oldValue = item1.sortID;
	item1.sortID = item2.sortID;
	item2.sortID = oldValue;
	[item1 save];
	self.userDrivenDataModelChange = NO;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[[self.fetchController.sections objectAtIndex:0] objects] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

@end
