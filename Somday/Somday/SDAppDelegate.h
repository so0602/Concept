//
//  SDAppDelegate.h
//  Concept
//
//  Created by Freddy So on 2/26/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDDynamicsDrawerViewController.h"
#import "SDLoginViewController.h"

@interface SDAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) UINavigationController* navigationController;
@property (nonatomic, strong) SDLoginViewController* loginViewController;
@property (nonatomic, strong) SDDynamicsDrawerViewController* mainViewController;

@end
