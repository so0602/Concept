//
//  SDMenuViewController.h
//  Concept
//
//  Created by Freddy So on 3/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SDDynamicsDrawerViewController.h"

typedef NS_ENUM(NSUInteger, SDPaneViewControllerType){
    SDPaneViewControllerType_Search,
    SDPaneViewControllerType_Home,
    SDPaneViewControllerType_User,
    SDPaneViewControllerType_Friends,
    SDPaneViewControllerType_Agenda,
    SDPaneViewControllerType_Chats,
    SDPaneViewControllerType_Settings
};

@interface SDMenuViewController : UIViewController

@property (nonatomic, assign) SDPaneViewControllerType paneViewControllerType;
@property (nonatomic, weak) SDDynamicsDrawerViewController* dynamicsDrawerViewController;

-(void)transitionToViewController:(SDPaneViewControllerType)paneViewControllerType;

@end
