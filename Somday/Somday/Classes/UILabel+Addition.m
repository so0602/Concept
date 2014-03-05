//
//  UILabel+Addition.m
//  Concept
//
//  Created by Tao, Steven on 3/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "UILabel+Addition.h"

@implementation UILabel (Addition)

-(void)setFontSize:(CGFloat)fontSize
{
    self.font = [UIFont fontWithName:self.font.fontName size:fontSize];
}

@end