//
//  SDAppDelegate.m
//  Concept
//
//  Created by Freddy So on 2/26/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDAppDelegate.h"

#import "MSDynamicsDrawerViewController.h"

#import "SDUtils.h"

#import "UIViewController+Addition.h"
#import "UIFont+Addition.h"
#import <GoogleMaps/GoogleMaps.h>

@implementation SDAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [GMSServices provideAPIKey:@"AIzaSyAyCESqzxtHjgNcXwwq6mwxqlspVitC3z8"];
    
    self.navigationController = (id)self.window.rootViewController;
    
//    self.mainViewController = [SDDynamicsDrawerViewController viewControllerFromStoryboardWithIdentifier:@"Main"];
    self.mainViewController = self.navigationController.viewControllers.firstObject;
//    self.mainViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    self.loginViewController = [SDLoginViewController viewControllerFromStoryboardWithIdentifier:@"Login"];
    self.loginViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    NSString* username = [SDUtils username];
    if( !username.length ){
        if( ![self.mainViewController.presentedViewController isEqual:self.loginViewController] ){
            [self.mainViewController presentViewController:self.loginViewController animated:FALSE completion:^{
                
            }];
        }
    }
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
