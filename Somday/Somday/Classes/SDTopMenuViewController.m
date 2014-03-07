//
//  SDTopMenuViewController.m
//  Somday
//
//  Created by Freddy on 6/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDTopMenuViewController.h"

#import "NSNotificationCenter+Name.h"

@interface SDTopMenuViewController ()

@end

@implementation SDTopMenuViewController

#pragma mark - MSDynamicsDrawerViewControllerDelegate

-(void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController mayUpdateToPaneState:(MSDynamicsDrawerPaneState)paneState forDirection:(MSDynamicsDrawerDirection)direction{
    if( paneState == MSDynamicsDrawerPaneStateClosed ){
        [[NSNotificationCenter defaultCenter] postNotificationName:TopMenuWillClose object:nil];
    }
}
-(void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController didUpdateToPaneState:(MSDynamicsDrawerPaneState)paneState forDirection:(MSDynamicsDrawerDirection)direction{
    if( paneState == MSDynamicsDrawerPaneStateClosed ){
        [[NSNotificationCenter defaultCenter] postNotificationName:TopMenuDidClosed object:nil];
    }
}
-(BOOL)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController shouldBeginPanePan:(UIPanGestureRecognizer *)panGestureRecognizer{
    return TRUE;
}

@end
