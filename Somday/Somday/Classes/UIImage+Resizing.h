//
//  UIImage+Resizing.h
//  Somday
//
//  Created by Freddy on 3/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Resizing)

-(UIImage *)resizeImageProportionallyIntoNewSize:(CGSize)newSize;
-(UIImage *)resizeImageProportionallyWithScaleFactor:(CGFloat)scaleFactor;

@end
