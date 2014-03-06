//
//  SDUtils.m
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDUtils.h"

@implementation SDUtils

+(UIStoryboard*)mainStoryboard{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+(UIMotionEffectGroup *)sharedMotionEffectGroup
{
    static UIMotionEffectGroup *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        // Set vertical effect
        UIInterpolatingMotionEffect *verticalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.y" type:UIInterpolatingMotionEffectTypeTiltAlongVerticalAxis];
        verticalMotionEffect.minimumRelativeValue = @(-10);
        verticalMotionEffect.maximumRelativeValue = @(10);
        
        // Set horizontal effect
        UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-10);
        horizontalMotionEffect.maximumRelativeValue = @(10);
        
        // Create group to combine both
        _sharedInstance = [UIMotionEffectGroup new];
        _sharedInstance.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        
    });
    
    return _sharedInstance;
}


@end
