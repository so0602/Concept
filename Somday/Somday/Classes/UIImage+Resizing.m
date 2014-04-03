//
//  UIImage+Resizing.m
//  Somday
//
//  Created by Freddy on 3/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "UIImage+Resizing.h"

@implementation UIImage (Resizing)

- (UIImage *)resizeImageProportionallyIntoNewSize:(CGSize)newSize;
{
    CGFloat scaleWidth = 1.0f;
    CGFloat scaleHeight = 1.0f;
    
    if (CGSizeEqualToSize(self.size, newSize) == NO) {
        
        //calculate "the longer side"
        if(self.size.width > self.size.height) {
            scaleWidth = self.size.width / self.size.height;
        } else {
            scaleHeight = self.size.height / self.size.width;
        }
    }
    
    //prepare source and target image
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    
    // Now we create a context in newSize and draw the image out of the bounds of the context to get
    // A proportionally scaled image by cutting of the image overlay
    UIGraphicsBeginImageContext(newSize);
    
    //Center image point so that on each egde is a little cutoff
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.size.width  = newSize.width * scaleWidth;
    thumbnailRect.size.height = newSize.height * scaleHeight;
    thumbnailRect.origin.x = (int) (newSize.width - thumbnailRect.size.width) * 0.5;
    thumbnailRect.origin.y = (int) (newSize.height - thumbnailRect.size.height) * 0.5;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if(newImage == nil) NSLog(@"could not scale image");
    
    return newImage ;
}

-(UIImage *)resizeImageProportionallyWithScaleFactor:(CGFloat)scaleFactor{
    CGSize size = self.size;
    size.width *= scaleFactor;
    size.height *= scaleFactor;
    return [self resizeImageProportionallyIntoNewSize:size];
}

@end
