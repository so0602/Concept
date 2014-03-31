//
//  UIFont+Addition.m
//  Concept
//
//  Created by Tao, Steven on 3/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "UIFont+Addition.h"

#import "SDUtils.h"

#import <objc/runtime.h>

static const char* UIFont_FontFamilyKey = "&#_UIFont_FontFamilyKey_#&";
static const char* UIFont_FontStyleKey = "&#_UIFont_FontStyleKey_#&";

@interface UIFont (Private)

@property (nonatomic) SDFontFamily fontFamily;
@property (nonatomic) SDFontStyle fontStyle;

-(UIFont*)createNewFont;

@end

@implementation UIFont (Private)

-(UIFont*)createNewFont{
    NSString* familyName = self.familyName;
    switch( self.fontFamily ){
        case SDFontFamily_Default:
            break;
        case SDFontFamily_JosefinSans:
            switch( self.fontStyle ){
                case SDFontStyle_Regular:
                    familyName = @"JosefinSans";
                    break;
                case SDFontStyle_Bold:
                    familyName = @"JosefinSans-Bold";
                    break;
                case SDFontStyle_BoldItalic:
                    familyName = @"JosefinSans-BoldItalic";
                    break;
                case SDFontStyle_Italic:
                    familyName = @"JosefinSans-Italic";
                    break;
                case SDFontStyle_Light:
                    familyName = @"JosefinSans-Light";
                    break;
                case SDFontStyle_LightItalic:
                    familyName = @"JosefinSans-LightItalic";
                    break;
                case SDFontStyle_SemiBold:
                    familyName = @"JosefinSans-SemiBold";
                    break;
                case SDFontStyle_SemiBoldItalic:
                    familyName = @"JosefinSans-SemiBoldItalic";
                    break;
                case SDFontStyle_Thin:
                    familyName = @"JosefinSans-Thin";
                    break;
                case SDFontStyle_ThinItalic:
                    familyName = @"JosefinSans-ThinItalic";
                    break;
                default:
                    SDLog(@"FamilyName: %@, not support this style.", @"JosefinSans" );
                    familyName = @"JosefinSans";
                    break;
            }
            break;
        case SDFontFamily_Montserrat:
            switch( self.fontStyle ){
                case SDFontStyle_Regular:
                    familyName = @"Montserrat-Regular";
                    break;
                case SDFontStyle_Bold:
                    familyName = @"Montserrat-Bold";
                    break;
                default:
                    SDLog(@"FamilyName: %@, not support this style.", @"Montserrat" );
                    familyName = @"Montserrat-Regular";
                    break;
            }
            break;
    }
    
    UIFont* font = self;
    if( ![familyName isEqualToString:self.familyName] ){
        font = [UIFont fontWithName:familyName size:self.pointSize];
    }
    return font;
}

-(SDFontFamily)fontFamily{
    NSNumber* number = objc_getAssociatedObject(self, UIFont_FontFamilyKey);
    return number.intValue;
}
-(void)setFontFamily:(SDFontFamily)fontFamily{
    NSNumber* number = [NSNumber numberWithInt:fontFamily];
    objc_setAssociatedObject(self, UIFont_FontFamilyKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(SDFontStyle)fontStyle{
    NSNumber* number = objc_getAssociatedObject(self, UIFont_FontStyleKey);
    return number.intValue;
}
-(void)setFontStyle:(SDFontStyle)fontStyle{
    NSNumber* number = [NSNumber numberWithInt:fontStyle];
    objc_setAssociatedObject(self, UIFont_FontStyleKey, number, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation UIFont (Addition)

-(UIFont*)setFontFamily:(SDFontFamily)fontFamily style:(SDFontStyle)style{
    self.fontFamily = fontFamily;
    self.fontStyle = style;
    return [self createNewFont];
}

+(UIFont *)josefinSansFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"JosefinSans" size:fontSize];
}

+(UIFont *)josefinSansSemiBoldFontOfSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"JosefinSans-SemiBold" size:fontSize];
}

+(void)allFonts{
    // List all fonts on iPhone
    NSArray *familyNames = [[NSArray alloc] initWithArray:[UIFont familyNames]];
    NSArray *fontNames;
    NSInteger indFamily, indFont;
    for (indFamily=0; indFamily<[familyNames count]; ++indFamily)
    {
        NSLog(@"Family name: %@", [familyNames objectAtIndex:indFamily]);
        fontNames = [[NSArray alloc] initWithArray:
                     [UIFont fontNamesForFamilyName:
                      [familyNames objectAtIndex:indFamily]]];
        for (indFont=0; indFont<[fontNames count]; ++indFont)
        {
            NSLog(@"    Font name: %@", [fontNames objectAtIndex:indFont]);
        }
    }
}

@end
