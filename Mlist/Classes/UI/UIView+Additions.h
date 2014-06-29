//
//  UIViewAdditions.h
//

#import <UIKit/UIKit.h>

@interface UIView (MFAdditions)

@property CGPoint position;
@property CGFloat x;
@property CGFloat y;

@property CGSize size;
@property CGFloat width;
@property CGFloat height;

@property (nonatomic, readonly) CGFloat right;
@property (nonatomic, readonly) CGFloat bottom;

+ (id)instanceWithXib;
+ (id)instanceWithXib:(NSString*)xibName;

- (NSArray*)deepSubviews;
@end

@interface UIViewController (CCtrl)
+ (id)viewCtrl;
- (id)initWithNib;
@end
