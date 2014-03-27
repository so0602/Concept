#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SDGradientView : UIView<NSCoding>

@property (nonatomic, copy) NSArray* colors;
@property (nonatomic, copy) NSArray* locations;
@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic, readonly) CAGradientLayer* gradientLayer;

@end
