//
//  MGItemCell.m
//  Mlist
//
//  Created by Mihail Gerasimenko on 6/29/14.
//  Copyright (c) 2014 Mike Gerasimenko. All rights reserved.
//

#import "MGItemCell.h"

@interface MGItemCell ()
@property (nonatomic, strong) IBOutlet UILabel* itemTitleLabel;
@property (nonatomic, strong) IBOutlet UIView* lineView;
@end

@implementation MGItemCell

+ (NSString*)reuseIdentifier {
	return NSStringFromClass([MGItemCell class]);
}

+ (CGFloat)defaultHeight {
	return 50.0f;
}

- (void)awakeFromNib {
	[super awakeFromNib];
	self.itemTitleLabel.font = [UIFont fontWithName:@"TakeMeOut" size:22.0f];

	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (NSString *)reuseIdentifier {
	return [MGItemCell reuseIdentifier];
}

- (void)setItem:(MGListItem *)item {
	_item = item;

	self.itemTitleLabel.text = item.text;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.itemTitleLabel.width = self.width - self.itemTitleLabel.x - 20.0f - (self.editing?35.0f:0.0f);
}

@end
