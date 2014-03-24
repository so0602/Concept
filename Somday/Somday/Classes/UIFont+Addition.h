//
//  UIFont+Addition.h
//  Concept
//
//  Created by Tao, Steven on 3/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SDFontFamily) {
    SDFontFamily_Default,
    SDFontFamily_JosefinSans,
    SDFontFamily_Montserrat,
};

// For non-default font family
typedef NS_ENUM(NSInteger, SDFontStyle) {
    SDFontStyle_Regular,
    SDFontStyle_Bold,
    SDFontStyle_BoldItalic,
    SDFontStyle_Italic,
    SDFontStyle_Light,
    SDFontStyle_LightItalic,
    SDFontStyle_SemiBold,
    SDFontStyle_SemiBoldItalic,
    SDFontStyle_Thin,
    SDFontStyle_ThinItalic,
};

@interface UIFont (Addition)

-(UIFont*)setFontFamily:(SDFontFamily)fontFamily style:(SDFontStyle)style;

+(UIFont *)josefinSansFontOfSize:(CGFloat)fontSize;
+(UIFont *)josefinSansSemiBoldFontOfSize:(CGFloat)fontSize;

+(void)allFonts;

@end
