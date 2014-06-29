//
//  MGListItem.h
//  Mlist
//
//  Created by Mihail Gerasimenko on 6/29/14.
//  Copyright (c) 2014 Mike Gerasimenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface MGListItem : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSNumber * uid;
@property (nonatomic, retain) NSNumber * sortID;
@property (nonatomic, retain) NSDate * lastModifiedLoad;

@end
