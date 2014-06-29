//
//  CMDatabaseCoordinator.m
//  
//
//  Created by Mihail Gerasimenko on 3/2/11.
//  Copyright 2011 Gerasimenko.me. All rights reserved.
//

#import "DatabaseCoordinator.h"

@implementation SHDatabaseCoordinator
@synthesize managedObjectModel, managedObjectContext, persistentStoreCoordinator;

// MARK: - CoreData maintenance

+ (SHDatabaseCoordinator*)sharedCoordinator {
	@synchronized(self) {
		static SHDatabaseCoordinator* c = nil;
	
		if (c == nil) {
			c = [[SHDatabaseCoordinator alloc] init];
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

@end
