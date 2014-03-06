//
//  SDUtils.m
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDUtils.h"

#import <QuartzCore/QuartzCore.h>

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
        verticalMotionEffect.minimumRelativeValue = @(-20);
        verticalMotionEffect.maximumRelativeValue = @(20);
        
        // Set horizontal effect
        UIInterpolatingMotionEffect *horizontalMotionEffect = [[UIInterpolatingMotionEffect alloc] initWithKeyPath:@"center.x" type:UIInterpolatingMotionEffectTypeTiltAlongHorizontalAxis];
        horizontalMotionEffect.minimumRelativeValue = @(-20);
        horizontalMotionEffect.maximumRelativeValue = @(20);
        
        // Create group to combine both
        _sharedInstance = [UIMotionEffectGroup new];
        _sharedInstance.motionEffects = @[horizontalMotionEffect, verticalMotionEffect];
        
    });
    
    return _sharedInstance;
}

+(void)rotateView:(UIView*)view{
    [UIView animateWithDuration:1.0 animations:^{
        view.transform = CGAffineTransformMakeRotation(M_PI_4);
    }];
}

+(void)rotateBackView:(UIView*)view{
    [UIView animateWithDuration:1.0 animations:^{
        view.transform = CGAffineTransformMakeRotation(-M_PI_4);
    }];
}

@end
