//
//  UIColor+Extensions.m
//  Doulton
//
//  Created by Steven Tao on 10/1/14.
//  Copyright (c) 2014 Steven Tao. All rights reserved.
//

#import "UIColor+Extensions.h"


@implementation UIColor (Extensions)

+(UIColor*)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

+(UIColor *)colorWithHex:(UInt32)col
{
    unsigned char r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:1];
}

+(UIColor *)colorWithHexString:(NSString *)str
{
    const char *cStr = [str cStringUsingEncoding:NSASCIIStringEncoding];
    long x;
    if([str characterAtIndex:0] == '#')
        x = strtol(cStr+1, NULL, 16);
    else
        x = strtol(cStr, NULL, 16);
    return [UIColor colorWithHex:x];
}

- (UIColor*)blackOrWhiteContrastingColor {
    UIColor *black = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    UIColor *white = [UIColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
    
    float blackDiff = [self luminosityDifference:black];
    float whiteDiff = [self luminosityDifference:white];
    
    return (blackDiff > whiteDiff) ? black : white;
}

- (CGFloat)luminosity {
    CGFloat red;
    CGFloat green;
    CGFloat blue;
    CGFloat alpha;
    
    BOOL success = [self getRed:&red green:&green blue:&blue alpha:&alpha];
    
    if (success)
        return 0.2126 * pow(red, 2.2f) + 0.7152 * pow(green, 2.2f) + 0.0722 * pow(blue, 2.2f);
    
    CGFloat white;
    
    success = [self getWhite:&white alpha:&alpha];
    if (success)
        return pow(white, 2.2f);
    
    return -1;
}

- (CGFloat)luminosityDifference:(UIColor*)otherColor {
    CGFloat l1 = [self luminosity];
    CGFloat l2 = [otherColor luminosity];
    
    if (l1 >= 0 && l2 >= 0) {
        if (l1 > l2) {
            return (l1+0.05f) / (l2+0.05f);
        } else {
            return (l2+0.05f) / (l1+0.05f);
        }
    }
    
    return 0.0f;
}

@end
