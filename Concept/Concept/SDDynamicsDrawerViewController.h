//
//  SDDynamicsDrawerViewController.h
//  Concept
//
//  Created by Freddy So on 2/26/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MSDynamicsDrawerViewController.h"

typedef NS_ENUM(NSInteger, SDDynamicsDrawerPaneState) {
    SDDynamicsDrawerPaneStateClosed,   // Drawer view entirely hidden by pane view
    SDDynamicsDrawerPaneStateOpen,     // Drawer view revealed to open width
    SDDynamicsDrawerPaneStateOpenWide, // Drawer view entirely visible with pane opened to `paneStateOpenWideEdgeOffset`
    SDDynamicsDrawerPaneStateHalfOpen,     // Drawer view revealed to open width (60px)
};

@protocol SDDynamicsDrawerViewControllerDelegate

@optional
-(void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController paneViewPositionDidChanged:(CGPoint)position;

@end

@interface SDDynamicsDrawerViewController : MSDynamicsDrawerViewController

@property (nonatomic, weak) id<SDDynamicsDrawerViewControllerDelegate> customDelegate;

@end
