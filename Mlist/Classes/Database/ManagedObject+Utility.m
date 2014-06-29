//
//  ManagedObject+Utility.m
//  
//
//  Created by Mihail Gerasimenko on 11/16/11.
//  Copyright (c) 2011 Gerasimenko. All rights reserved.
//

#import "ManagedObject+Utility.h"
#import "DatabaseCoordinator.h"
#import <objc/runtime.h>


@interface NSManagedObject ()
- (NSManagedObject *)initNewManagedObjectWithEntityName:(NSString *)entityName andPropertyDict:(NSDictionary*)propertyDict;
@end

@implementation NSManagedObject (Utility)

+ (id)object {
	NSManagedObject *obj = [[SHDatabaseCoordinator sharedCoordinator] createObject:NSStringFromClass([self class])];
	
	return obj;
}

+ (NSArray*)objectsWithPredicate:(NSPredicate*)predicate {
	return [self objectsWithPredicate:predicate inContext:[[SHDatabaseCoordinator sharedCoordinator] managedObjectContext]];
}

+ (NSArray*)objectsWithPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext*)context {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:NSStringFromClass(self) 
											  inManagedObjectContext:context];
    [request setEntity:entity];
	[request setPredicate:predicate];
	[request setIncludesPendingChanges:YES];
	
    NSError *error = nil;
	
	NSArray* result = [context executeFetchRequest:request 
											 error:&error];
	
	if (error != nil) {
		NSLog(@"DB error at (%s): %@", __PRETTY_FUNCTION__, error);
	}
	
	return result;
}

+ (unsigned int)countObjectsWithPredicate:(NSPredicate *)predicate {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];
	
	request.entity =[NSEntityDescription entityForName:NSStringFromClass(self) 
								inManagedObjectContext:[[SHDatabaseCoordinator sharedCoordinator] managedObjectContext]];
	request.predicate = predicate;
	request.includesSubentities = NO;
	
	NSError *err = nil;
	NSUInteger count = [[[SHDatabaseCoordinator sharedCoordinator] managedObjectContext] countForFetchRequest:request
																										error:&err];
	if(err != nil) {
		NSLog(@"Error: %@", err);
	}
	
	if (count == NSNotFound) {
		return 0;
	}
	
	return count;
}

+ (NSArray*)getAll {
	NSManagedObjectContext *context = [[SHDatabaseCoordinator sharedCoordinator] managedObjectContext];
	return [self getAllInContext:context];
}

+ (NSArray*)getAllInContext:(NSManagedObjectContext*)context {
	NSFetchRequest *request = [[NSFetchRequest alloc] init];  
	
	[request setEntity:[NSEntityDescription entityForName:NSStringFromClass([self class]) 
								   inManagedObjectContext:context]];  
	
	
	NSError *err = nil;
	NSArray *ret = [context executeFetchRequest:request error:&err];
	
	if(err != nil) {
		NSLog(@"DB error: %@", [err description]);
	}
	
	return ret;
}

+ (NSUInteger)count:(NSError**)error {
	NSFetchRequest* fetchRequest = [self fetchRequest];
    NSManagedObjectContext *ctx = [[SHDatabaseCoordinator sharedCoordinator] managedObjectContext];
	return [ctx countForFetchRequest:fetchRequest error:error];
}

+ (NSUInteger)count {
    NSError *error = nil;
    NSUInteger count = [self count:&error];
    if (error) {
        NSLog(@"%@",error);
    }
    return count;
}

+ (NSEntityDescription*)entity {
	NSString* className = [NSString stringWithCString:class_getName([self class]) encoding:NSASCIIStringEncoding];
    NSManagedObjectContext *ctx = [[SHDatabaseCoordinator sharedCoordinator] managedObjectContext];
	return [NSEntityDescription entityForName:className inManagedObjectContext:ctx];
}

+ (NSFetchRequest*)fetchRequest {
	NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entity = [self entity];
	[fetchRequest setEntity:entity];
	return fetchRequest;
}

- (void)save {
	[[SHDatabaseCoordinator sharedCoordinator] saveContext];
}

- (void)delete {
	NSManagedObjectContext *context = [[SHDatabaseCoordinator sharedCoordinator] managedObjectContext];
	[context deleteObject:self];
}


@end
