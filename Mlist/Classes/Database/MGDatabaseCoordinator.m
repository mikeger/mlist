//
//  CMDatabaseCoordinator.m
//  
//
//  Created by Mihail Gerasimenko on 3/2/11.
//  Copyright 2011 Gerasimenko.me. All rights reserved.
//

#import "MGDatabaseCoordinator.h"

@implementation MGDatabaseCoordinator
@synthesize managedObjectModel, managedObjectContext, persistentStoreCoordinator;

// MARK: - CoreData maintenance

+ (MGDatabaseCoordinator*)sharedCoordinator {
	@synchronized(self) {
		static MGDatabaseCoordinator* c = nil;
	
		if (c == nil) {
			c = [[MGDatabaseCoordinator alloc] init];
		}
		
		return c;
	}
}

- (id)init {
	self = [super init];
	if (self != nil) {
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(contextDidSave:)
													 name:NSManagedObjectContextDidSaveNotification
												   object:nil];
	}
	return self;
}

- (void)dealloc {
	self.managedObjectModel = nil;
	self.managedObjectContext = nil;
	self.persistentStoreCoordinator = nil;
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	
	[super dealloc];
}

- (void)contextDidSave:(NSNotification*)notification {

	NSManagedObjectContext *savedContext = [notification object];

	// ignore change notifications for the main MOC
	if (self.managedObjectContext == savedContext) {
		return;
	}

	if (self.managedObjectContext.persistentStoreCoordinator != savedContext.persistentStoreCoordinator) {
		// that's another database
		return;
	}

	SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
    [self.managedObjectContext performSelectorOnMainThread:selector withObject:notification waitUntilDone:YES];
}

- (NSManagedObjectContext *)managedObjectContext {
    
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
	
	NSURL* modelURL = [[NSBundle mainBundle] URLForResource:@"Mlist" withExtension:@"momd"];
    managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL]; 
	return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    
	NSString*	libDir		= [[UIApplication sharedApplication] libraryAppDirectory];
    NSURL*		storeUrl	= [NSURL fileURLWithPath:[libDir stringByAppendingPathComponent:@"Mlist.sqlite"]];
	
    NSError *error = nil;

    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
	
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType 
												  configuration:nil 
															URL:storeUrl 
														options:options 
														  error:&error]) {
		NSLog(@"ERR: %@",[error userInfo]);
		error = nil;
    }

    return persistentStoreCoordinator;
}

- (void)saveContext {
	@try {
		
		NSError* error = nil;
		if([self.managedObjectContext hasChanges] && ![self.managedObjectContext save:&error]) {
			NSLog(@"Failed to save to data store: %@", [error localizedDescription]);
			
			NSArray* detailedErrors = [[error userInfo] objectForKey:NSDetailedErrorsKey];
			
			if(detailedErrors != nil && [detailedErrors count] > 0) {
				for(NSError* detailedError in detailedErrors) {
					NSLog(@"  DetailedError: %@", [detailedError userInfo]);
				}
			}
			else {
				NSLog(@"  %@", [error userInfo]);
			}
		}	
	}
	@catch (NSException * e) {
		NSLog(@"Error: %@", [e userInfo]);
	}
}

- (id)createObject:(NSString *)entityName {
	NSManagedObject *obj = [NSEntityDescription insertNewObjectForEntityForName:entityName 
														 inManagedObjectContext:self.managedObjectContext];
	
	return obj;
}

- (void)preloadDatabase {
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		NSManagedObjectContext *tmpContext = [[NSManagedObjectContext alloc] init];
		tmpContext.persistentStoreCoordinator = self.persistentStoreCoordinator;

		NSArray *notes = @[@{@"id":@1, @"text": @"First note"},
						   @{@"id":@2, @"text": @"Secon note with a link to http://www.google.de"},
						   @{@"id":@3, @"text": @"Third note"},
						   @{@"id":@4, @"text": @"Fourth note"},
						   @{@"id":@5, @"text": @"Fifth note with an email adress to jakob@mbraceapp.com"}, @{@"id":@6, @"text": @"6th note"},
						   @{@"id":@6, @"text": @"6th note updated"},
						   @{@"id":@7, @"text": @"7th note"},
						   @{@"id":@8, @"text": @"8th note"},
						   @{@"id":@9, @"text": @"9th note"},
						   @{@"id":@10, @"text": @"10th note"},
						   @{@"id":@11, @"text": @"11th note"},
						   @{@"id":@12, @"text": @"12th note"},
						   @{@"id":@13, @"text": @"13th note"},
						   @{@"id":@14, @"text": @"14th note"},
						   @{@"id":@15, @"text": @"get mbrace at http://www.getmbrace.com"},
						   @{@"id":@16, @"text": @"16th note"},
						   @{@"id":@17, @"text": @"17th note"},
						   @{@"id":@18, @"text": @"18th note"},
						   @{@"id":@19, @"text": @"19th note"},
						   @{@"id":@20, @"text": @"20th note"},
						   @{@"id":@21, @"text": [NSNull null]},
						   @{@"id":@22, @"text": @"22th note"},
						   @{@"id":@23, @"text": @"23th note"},
						   @{@"id":@24, @"text": @"Visit www.mbraceapp.com"},
						   @{@"id":@25, @"text": @"25th note"},
						   @{@"id":@26, @"text": @"Note that is a little bit longer than all the other notes because of consiting of some strings that are useless and take a lot of space"},
						   @{@"id":@27, @"text": @"27th note"},
						   @{@"id":@28, @"text": @"28th note"},
						   @{@"id":@29, @"text": @"29th note"},
						   @{@"id":@30, @"text": @"another email to lukas@mbraceapp.com"}, @{@"id":@31, @"text": @"31th note"},
						   @{@"id":@32, @"text": @"32th note"},
						   @{@"id":@33, @"text": @"33th note"},
						   @{@"id":@34, @"text": @"almost at the end note"},
						   @{@"id":@35, @"text": @"Last note note"},
						   @{@"id":@12, @"text": @"Updated 12th note"}];

		for (NSDictionary* dict in notes) {
			NSUInteger identifier = [dict[@"id"] unsignedIntegerValue];
			NSString*  text	      =  dict[@"text"];

			if (text == nil) {
				NSLog(@"Text cannot be nil: %@", [dict description]);
				continue;
			}

			if (![text isKindOfClass:[NSString class]]) {
				NSLog(@"Text shuold be a string: %@", [dict description]);
				continue;
			}

			NSArray* items = [MGListItem objectsWithPredicate:[NSPredicate predicateWithFormat:@"uid = %d", identifier] inContext:tmpContext];
			if (items.count != 0) {
				for (MGListItem* item in items) {
					item.text = text;
				}
			}
			else {
				MGListItem* item = [MGListItem objectInContext:tmpContext];
				item.uid = @(identifier);
				item.text = text;
			}
		}

		NSError *error;
		if (![tmpContext save:&error])
		{
			NSLog(@"Error: %@", error);
		}
	});
}

@end
