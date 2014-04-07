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
    return [self applyBlurWithRadius:1 tintColor:[UIColor colorWithWhite:0 alpha:0.2] saturationDeltaFactor:1 maskImage:nil];
}

-(UIImage*)defaultDarkBlur{
    return [self applyBlurWithRadius:1 tintColor:[UIColor colorWithWhite:0 alpha:0.3] saturationDeltaFactor:1 maskImage:nil];
}

@end
