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

+(NSString*)dateString:(NSDate*)date{
    return nil;
}

+(NSString*)dateString:(NSDate*)startDate endDate:(NSDate*)endDate{
    NSMutableString* string = nil;
    if( [startDate isSameDay:endDate] ){
        NSDateInformation startInfo = startDate.dateInformation;
        NSDate* currentDate = [NSDate date];
        if( [startDate isSameDay:currentDate] ){
            string = [NSLocalizedString(@"DateFormat_Today", nil) mutableCopy];
        }else{
            NSDateInformation currentInfo = currentDate.dateInformation;
            if( currentInfo.day == startInfo.day - 1 ){
                string = [NSLocalizedString(@"DateFormat_Tomorrow", nil) mutableCopy];
            }else if( currentInfo.day == startInfo.day + 1 ){
                string = [NSLocalizedString(@"DateFormat_Yesterday", nil) mutableCopy];
            }else if( startInfo.day > currentInfo.day && (startInfo.weekday > currentInfo.weekday || startInfo.weekday == 1) ){
                NSString* key = nil;
                switch( startInfo.weekday - 1 ){
                    case 0:
                        key = @"DateFormat_ThisSunday";
                        break;
                    case 1:
                        key = @"DateFormat_ThisMonday";
                        break;
                    case 2:
                        key = @"DateFormat_ThisTueday";
                        break;
                    case 3:
                        key = @"DateFormat_ThisWednesday";
                        break;
                    case 4:
                        key = @"DateFormat_ThisThursday";
                        break;
                    case 5:
                        key = @"DateFormat_ThisFriday";
                        break;
                    case 6:
                        key = @"DateFormat_ThisSaturday";
                        break;
                }
                string = [NSLocalizedString(key, nil) mutableCopy];
            }else{
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                formatter.dateFormat = @"d MMMM yyyy";
                string = [[formatter stringFromDate:startDate] mutableCopy];
            }
        }
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"h:mma";
        NSString* timeString = [[NSString stringWithFormat:@"%@ - %@", [formatter stringFromDate:startDate], [formatter stringFromDate:endDate]] uppercaseString];
        [string appendFormat:@"\n%@", timeString];
    }else{
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"d MMMM yyyy";
        string = [NSMutableString stringWithFormat:@"%@ \n- %@", [formatter stringFromDate:startDate], [formatter stringFromDate:endDate]];
    }
    return string;
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

@end
