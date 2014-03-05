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

@end
