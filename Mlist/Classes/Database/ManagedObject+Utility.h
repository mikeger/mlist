//
//  ManagedObject+Utility.h
//  
//
//  Created by Mihail Gerasimenko on 11/16/11.
//  Copyright (c) 2011 Gerasimenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NSManagedObject (Utility)

+ (id)object;

+ (NSArray*)objectsWithPredicate:(NSPredicate*)predicate inContext:(NSManagedObjectContext*)context;
+ (NSArray*)objectsWithPredicate:(NSPredicate*)predicate;
+ (unsigned int)countObjectsWithPredicate:(NSPredicate*)predicate;

+ (NSArray*)getAll;
+ (NSArray*)getAllInContext:(NSManagedObjectContext*)context;
- (void)save;
- (void)delete;

+ (NSUInteger)count:(NSError**)error;
+ (NSUInteger)count;
+ (NSEntityDescription*)entity;
+ (NSFetchRequest*)fetchRequest;
@end
