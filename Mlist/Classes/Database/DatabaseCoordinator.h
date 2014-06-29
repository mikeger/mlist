//
//  CMDatabaseCoordinator.h
//  
//
//  Created by Mihail Gerasimenko on 3/2/11.
//  Copyright 2011 Gerasimenko.me. All rights reserved.
//

#import <CoreData/CoreData.h>

extern NSString* SHContentsDirectory;
extern NSString* SHContentsThumbsDirectory;

@interface SHDatabaseCoordinator : NSObject

+ (SHDatabaseCoordinator*)sharedCoordinator;

@property (nonatomic, retain) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSPersistentStoreCoordinator *persistentStoreCoordinator;	

- (id)createObject:(NSString *)entityName;
- (void)saveContext;
@end
