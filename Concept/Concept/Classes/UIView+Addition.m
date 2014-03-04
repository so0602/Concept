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
    UIGraphicsEndImageContext();
    
    return image;
}

-(IBAction)touchUpInside:(id)sender{
    
}

@end
