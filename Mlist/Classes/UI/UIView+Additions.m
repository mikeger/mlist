//
//  UIViewAdditions.m
//

#import <QuartzCore/QuartzCore.h>

#import "UIView+Additions.h"

@implementation UIView (MFAdditions) 
@dynamic x, y;

- (CGPoint)position {
	return [self frame].origin;
}

- (void)setPosition:(CGPoint)position {
	CGRect rect = [self frame];
	rect.origin = position;
	[self setFrame:rect];
}

- (CGFloat)x {
	return [self frame].origin.x;
}

- (void)setX:(CGFloat)x {
	CGRect rect = [self frame];
	rect.origin.x = x;
	[self setFrame:rect];
}

- (CGFloat)y {
	return [self frame].origin.y;
}

- (void)setY:(CGFloat)y {
	CGRect rect = [self frame];
	rect.origin.y = y;
	[self setFrame:rect];
}

- (CGSize)size {
	return [self frame].size;
}

- (void)setSize: (CGSize) size {
	CGRect rect = [self frame];
	rect.size = size;
	[self setFrame:rect];
}

- (CGFloat)width {
	return [self frame].size.width;
}

- (void)setWidth: (CGFloat) width {
	CGRect rect = [self frame];
	rect.size.width = width;
	[self setFrame:rect];
}

- (CGFloat)height {
	return [self frame].size.height;
}

- (void)setHeight:(CGFloat)height {
	CGRect rect = [self frame];
	rect.size.height = height;
	[self setFrame:rect];
}

- (CGFloat)right {
	return self.x + self.width;
}

- (CGFloat)bottom {
	return self.y + self.height;
}

+ (id)instanceWithXib {
	NSString* className = NSStringFromClass([self class]);
	return [self instanceWithXib:className];
}

+ (id)instanceWithXib: (NSString*) xibName {
	NSString* nibName = xibName;
	
#ifdef NSProjectPrefix
	if ([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] == nil) {
		if ([nibName hasPrefix:NSProjectPrefix]) {
			nibName = [nibName substringFromIndex:[NSProjectPrefix length]];
		}
	}
#endif
	
	if ([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] == nil) {
		nibName = NSStringFromClass([self superclass]);
	}
	
	if ([[NSBundle mainBundle] pathForResource:nibName ofType:@"nib"] == nil) {
		return [[[self alloc] init] autorelease];
	}
	
	NSArray* elements = [[NSBundle mainBundle] loadNibNamed: nibName owner: self options: nil];
	for (NSObject* object in elements) 
	{
		if ([object isKindOfClass: self.class]) 
			return object;
	}
	
	for (NSObject* object in elements) 
	{
		if ([object isKindOfClass: self.superclass]) 
			return object;
	}
	
	return nil;
}

- (NSArray*)deepSubviews {
	NSMutableArray* all = [NSMutableArray arrayWithCapacity:self.subviews.count * 2];
	for (UIView* v in self.subviews) {
		[all addObject:v];
		[all addObjectsFromArray:[v deepSubviews]];
	}
	return all;
}

@end

@implementation UIViewController (CCtrl)

+ (id)viewCtrl {
	return [[[[self class] alloc] initWithNib] autorelease];
}

// MARK: - UIViewController methods

- (id)initWithNib
{
	NSString *name = NSStringFromClass([self class]);

	if ([[NSBundle mainBundle] pathForResource:name ofType:@"nib"] != nil)
    {
		self = [self initWithNibName:name bundle:[NSBundle mainBundle]];
	}
	else {
#ifdef NSProjectPrefix
		if ([name hasPrefix:NSProjectPrefix])
		{
			name = [name substringFromIndex:[NSProjectPrefix length]];
		}

		if ([[NSBundle mainBundle] pathForResource:name ofType:@"nib"] != nil)
		{
			self = [self initWithNibName:name bundle:[NSBundle mainBundle]];
		}
		else
		{
			name = NSStringFromClass([self superclass]);

			if ([name hasPrefix:NSProjectPrefix])
				name = [name substringFromIndex:[NSProjectPrefix length]];

			if ([[NSBundle mainBundle] pathForResource:name ofType:@"nib"] != nil)
			{
				self = [self initWithNibName:name bundle:[NSBundle mainBundle]];
			}
			else
			{
				self = [super init];
			}
		}
#else
		self = [super init];
#endif
	}

	return self;
}
@end
