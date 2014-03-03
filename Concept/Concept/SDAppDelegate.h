//
//  SDAppDelegate.h
//  Concept
//
//  Created by Freddy So on 2/26/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSDynamicsDrawerViewController.h"

@interface SDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) IBOutlet MSDynamicsDrawerViewController* mainViewController;


@end
