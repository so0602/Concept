//
//  SDTopMenuViewController.m
//  Somday
//
//  Created by Freddy on 6/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDTopMenuViewController.h"

#import "SDUtils.h"

#import "NSNotificationCenter+Name.h"

#import "UIViewController+Addition.h"
#import "UITabBarController+Additions.h"

@interface SDTopMenuViewController ()

@property (nonatomic, strong) IBOutlet UIButton* closeButton;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray* buttons;

@property (nonatomic, strong) UITabBarController* tabBarController;

@end

@implementation SDTopMenuViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if( [segue.identifier isEqualToString:@"TopMenuTabBarEmbed"] ){
        self.tabBarController = segue.destinationViewController;
        self.tabBarController.tabBarHidden = TRUE;
    }
}

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.closeButton isEqual:sender] ){
        [SDUtils rotateBackView:self.closeButton];
        [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:TRUE allowUserInterruption:FALSE completion:^{
            
        }];
    }else{
        NSInteger index = [self.buttons indexOfObject:sender];
        if( index != NSNotFound ){
            self.tabBarController.selectedIndex = index;
            [SDUtils rotateView:self.closeButton];
            [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpenWide animated:TRUE allowUserInterruption:FALSE completion:^{
                
            }];
        }
    }
}

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
