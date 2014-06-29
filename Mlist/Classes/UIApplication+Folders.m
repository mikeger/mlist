//
//  UIApplication+Folders.m
//  
//
//  Created by Mihail Gerasimenko on 11/15/11.
//  Copyright (c) 2011 Gerasimenko. All rights reserved.
//

#import "UIApplication+Folders.h"
#include <sys/xattr.h>

@interface UIApplication(Internal)
- (NSString*)userDomainDirectory:(NSSearchPathDirectory)directory;
@end


@implementation UIApplication (Folders)

- (NSString*)userDomainDirectory:(NSSearchPathDirectory)directory {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(directory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (NSString *)documentsDirectory {
	return [self userDomainDirectory:NSDocumentDirectory];
}

- (NSString *)cachesDirectory {
	return [self userDomainDirectory:NSCachesDirectory];
}

- (NSString *)libraryAppDirectory {
	NSArray* paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, true);
	NSString* lib_path = [paths objectAtIndex:0];
	NSMutableString* path = [NSMutableString stringWithString:lib_path];
	[path appendFormat:@"/%@", [[NSBundle mainBundle] bundleIdentifier]];
	
	if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
		NSFileManager* fm = [NSFileManager new];
		NSError* error = 0;
		[fm createDirectoryAtPath:path withIntermediateDirectories:true attributes:0 error:&error];
		
		if (error != nil) {
			NSLog(@"Error: %@", error);
			error = nil;
		}
		
		[[NSFileManager defaultManager] setNoBackupForItemAtPath:path error:&error];
		if (error != nil) {
			NSLog(@"Error: %@", error);
			error = nil;
		}
	}
	
	return path;
}

@end

@implementation NSFileManager (xattr)

- (void)setNoBackupForItemAtPath:(NSString*)path error:(NSError**)error {
	const char* attr_name = "com.apple.MobileBackup";
	u_int8_t attr_value = 1;
	
	if(setxattr([path UTF8String], attr_name, &attr_value, sizeof(attr_value), 0, 0) != 0) {
		NSDictionary* userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
								  [NSString stringWithUTF8String:strerror(errno)],	NSLocalizedDescriptionKey, 
								  path,												NSFilePathErrorKey, 
								  nil];
		NSError* err = [[NSError alloc] initWithDomain:NSPOSIXErrorDomain code:errno userInfo:userInfo]; 
		*error = err;
	}
}

- (void)setNoBackupForItemAtURL:(NSURL*)url error:(NSError**)error {
	if (![url isFileURL]) {
		NSDictionary* userInfo = [NSDictionary dictionaryWithObject:@"Not a file URL." forKey:NSLocalizedDescriptionKey];
		NSError* err = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:0 userInfo:userInfo];
		*error = err;
		return;
	}
	
	NSString* path = [url absoluteString];
	NSError* err = nil;
	[self setNoBackupForItemAtPath:path error:&err];
	*error = err;
}

@end

