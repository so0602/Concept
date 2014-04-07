//
//  UIView+Addition.m
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

-(UIImage*)convertViewToImage{
    UIGraphicsBeginImageContext(self.bounds.size);
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
//    float scale = [UIScreen mainScreen].scale;
//    if( scale > 1 ){
//        image = [UIImage imageWithCGImage:image.CGImage scale:scale orientation:image.imageOrientation];
//    }
    UIGraphicsEndImageContext();
    
    return image;
}

-(IBAction)touchUpInside:(id)sender{
    
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

-(CGFloat)x{
    return self.frame.origin.x;
}
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

-(CGFloat)y{
    return self.frame.origin.y;
}
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

-(CGSize)size{
    return self.frame.size;
}
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

-(CGPoint)origin{
    return self.frame.origin;
}
- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin.x = origin.x;
    frame.origin.y = origin.y;
    self.frame = frame;
}

-(void)changeFont:(SDFontFamily)fontFamily style:(SDFontStyle)fontStyle{
    UIFont* font = nil;
    UILabel* label = nil;
    UIButton* button = nil;
    if( [self isKindOfClass:[UILabel class]] ){
        label = (id)self;
        font = label.font;
    }else if( [self isKindOfClass:[UIButton class]] ){
        button = (id)self;
        font = button.titleLabel.font;
    }
    font = [font setFontFamily:fontFamily style:fontStyle];
    
    label.font = font;
    button.titleLabel.font = font;
}

@end
