//
//  UIView+Addition.h
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)

-(UIImage*)convertViewToImage;

-(IBAction)touchUpInside:(id)sender;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;
- (CGFloat)height;
- (void)setHeight:(CGFloat)height;
- (void)setX:(CGFloat)x;
- (void)setY:(CGFloat)y;
- (void)setSize:(CGSize)size;
- (void)setOrigin:(CGPoint)origin;

@end
