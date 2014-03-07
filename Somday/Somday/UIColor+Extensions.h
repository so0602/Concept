//
//  UIColor+Extensions.h
//  Doulton
//
//  Created by Steven Tao on 10/1/14.
//  Copyright (c) 2014 Steven Tao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UIColor (Extensions)

+(UIColor*)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+(UIColor *)colorWithHex:(UInt32)col;
+(UIColor *)colorWithHexString:(NSString *)str;
- (UIColor*)blackOrWhiteContrastingColor;
- (CGFloat)luminosity;
- (CGFloat)luminosityDifference:(UIColor*)otherColor;
@end
