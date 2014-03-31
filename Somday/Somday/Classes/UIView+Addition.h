//
//  UIView+Addition.h
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIFont+Addition.h"

@interface UIView (Addition)

-(UIImage*)convertViewToImage;

-(IBAction)touchUpInside:(id)sender;

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGFloat x;
@property (nonatomic) CGFloat y;
@property (nonatomic) CGSize size;
@property (nonatomic) CGPoint origin;

-(void)changeFont:(SDFontFamily)fontFamily style:(SDFontStyle)fontStyle;

@end
