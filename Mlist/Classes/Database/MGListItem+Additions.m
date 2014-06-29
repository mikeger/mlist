//
//  MGListItem+Additions.m
//  Mlist
//
//  Created by Mihail Gerasimenko on 6/29/14.
//  Copyright (c) 2014 Mike Gerasimenko. All rights reserved.
//

#import "MGListItem+Additions.h"

@implementation MGListItem (Additions)

+ (NSInteger)getMaxSortID {
	NSManagedObjectContext* context = [MGDatabaseCoordinator sharedCoordinator].managedObjectContext;
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [NSEntityDescription entityForName:@"MGListItem" inManagedObjectContext:context];
	[request setEntity:entity];

	// Specify that the request should return dictionaries.
	[request setResultType:NSDictionaryResultType];

	// Create an expression for the key path.
	NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"sortID"];

	// Create an expression to represent the minimum value at the key path 'creationDate'
	NSExpression *minExpression = [NSExpression expressionForFunction:@"max:" arguments:[NSArray arrayWithObject:keyPathExpression]];

	// Create an expression description using the minExpression and returning a date.
	NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];

	// The name is the key that will be used in the dictionary for the return value.
	[expressionDescription setName:@"maxSortID"];
	[expressionDescription setExpression:minExpression];
	[expressionDescription setExpressionResultType:NSInteger32AttributeType];

	// Set the request's properties to fetch just the property represented by the expressions.
	[request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];

	// Execute the fetch.
	NSError *error = nil;
	NSArray *objects = [context executeFetchRequest:request error:&error];
	if (objects == nil) {
		return 0;
	}
	else {
		if ([objects count] > 0) {
			return [[[objects objectAtIndex:0] valueForKey:@"maxSortID"] intValue];
		}
		else {
			return 0;
		}
	}
}

+ (id)object {
	MGListItem* newItem = [super object];
	newItem.sortID = [NSNumber numberWithInt:[self getMaxSortID] + 1];
	return newItem;
}

@end
