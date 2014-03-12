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

+(KeychainItemWrapper *)sharedKeychainItemWrapper
{
    static KeychainItemWrapper *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[KeychainItemWrapper alloc] initWithIdentifier:[[NSBundle mainBundle] bundleIdentifier] accessGroup:nil];
        
    });
    
    return _sharedInstance;
}

+(void)rotateView:(UIView*)view{
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeRotation(M_PI - M_PI_4);
    }];
}

+(void)rotateBackView:(UIView*)view{
    [UIView animateWithDuration:0.3 animations:^{
        view.transform = CGAffineTransformMakeRotation(0);
    }];
}

+(NSString*)username{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:@"USERNAME"];
}

+(NSString*)password{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:@"PASSWORD"];
}

+(void)setUsername:(NSString*)username password:(NSString*)password{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault setObject:username forKey:@"USERNAME"];
    [userDefault setObject:password forKey:@"PASSWORD"];
    [userDefault synchronize];
}

+(void)logout{
    NSUserDefaults* userDefault = [NSUserDefaults standardUserDefaults];
    [userDefault removeObjectForKey:@"USERNAME"];
    [userDefault removeObjectForKey:@"PASSWORD"];
    [userDefault synchronize];
}

@end
