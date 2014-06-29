//
//  MGItemDetailViewController.h
//  Mlist
//
//  Created by Mihail Gerasimenko on 6/29/14.
//  Copyright (c) 2014 Mike Gerasimenko. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MGItemDetailViewController : UIViewController <UITextViewDelegate>
@property (nonatomic, strong) MGListItem* item;
@end
