//
//  UIApplication+Folders.h
//  
//
//  Created by Mihail Gerasimenko on 11/15/11.
//  Copyright (c) 2011 Gerasimenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIApplication (Folders)
- (NSString *)documentsDirectory;
- (NSString *)cachesDirectory;
- (NSString *)libraryAppDirectory;
@end

@interface NSFileManager (xattr)
- (void)setNoBackupForItemAtPath:(NSString*)path error:(NSError**)error;
- (void)setNoBackupForItemAtURL:(NSURL*)url error:(NSError**)error;
@end
