//
//  SDUtils.m
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "SDUtils.h"

#import "SDLoadingViewController.h"
#import "SDAppDelegate.h"

@interface SDUtils ()

+(UIViewController*)loadingViewController;

@end

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
    KeychainItemWrapper* keychain = [SDUtils sharedKeychainItemWrapper];
    return [keychain objectForKey:(__bridge id)kSecAttrAccount];
}

+(NSString*)password{
    KeychainItemWrapper* keychain = [SDUtils sharedKeychainItemWrapper];
    return [keychain objectForKey:(__bridge id)kSecValueData];
}

+(void)setUsername:(NSString*)username password:(NSString*)password{
    KeychainItemWrapper* keychain = [SDUtils sharedKeychainItemWrapper];
    [keychain setObject:username forKey:(__bridge id)kSecAttrAccount];
    [keychain setObject:password forKey:(__bridge id)kSecValueData];
}

+(void)logout{
    KeychainItemWrapper* keychain = [SDUtils sharedKeychainItemWrapper];
    [keychain resetKeychainItem];
}

+(UIImage*)captureScreenForView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.frame.size);
	[view.layer renderInContext:UIGraphicsGetCurrentContext()];
	UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    
    return viewImage;
}

#pragma mark - Private Functions

+(UIViewController*)loadingViewController{
    static UIViewController* loadingViewController = nil;
    static dispatch_once_t oncePredicate;
    
    dispatch_once(&oncePredicate, ^{
        loadingViewController = [SDLoadingViewController viewControllerFromStoryboardWithIdentifier:@"Loading"];
    });
    
    return loadingViewController;
}

+(void)showLoading{
    UIViewController* viewController = [SDUtils loadingViewController];
    if( !viewController.isViewLoaded ){
        [viewController viewDidLoad];
    }
    if( !viewController.view.superview ){
        SDAppDelegate* delegate = [UIApplication sharedApplication].delegate;
        UIWindow* window = delegate.window;
        [window addSubview:viewController.view];
    }
}

+(void)dismissLoading{
    UIViewController* viewController = [SDUtils loadingViewController];
    if( viewController.view.superview ){
        [viewController.view removeFromSuperview];
    }
}

@end
