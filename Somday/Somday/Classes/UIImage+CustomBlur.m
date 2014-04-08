//
//  UIImage+CustomBlur.m
//  Somday
//
//  Created by Freddy So on 4/7/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "UIImage+CustomBlur.h"

#import "UIImage+ImageEffects.h"

@implementation UIImage (CustomBlur)

-(UIImage*)defaultBlur{
    CGFloat scale = self.scale;
    UIImage* image = [self applyBlurWithRadius:1 tintColor:[UIColor colorWithWhite:0 alpha:0.2]saturationDeltaFactor:1 maskImage:nil];
    
    if( image.scale != scale ){
        image = [image resizeImageProportionallyWithScaleFactor:1];
    }
    
    return image;
//    return [self applyBlurWithRadius:1 tintColor:[UIColor colorWithWhite:0 alpha:0.2] saturationDeltaFactor:1 maskImage:nil];
}

-(UIImage*)defaultDarkBlur{
    CGFloat scale = self.scale;
    UIImage* image = [self applyBlurWithRadius:1 tintColor:[UIColor colorWithWhite:0 alpha:0.3] saturationDeltaFactor:1 maskImage:nil];
    
    if( image.scale != scale ){
        image = [image resizeImageProportionallyWithScaleFactor:1];
    }
    
    return image;
}

@end
