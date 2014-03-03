//
//  SDMenuViewController.m
//  Concept
//
//  Created by Freddy So on 3/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDMenuViewController.h"

@interface SDMenuViewController ()

@property (nonatomic, strong) NSDictionary* paneViewControllerTitles;
@property (nonatomic, strong) NSDictionary* paneViewControllerIdentifiers;

@property (nonatomic, strong) UIBarButtonItem* menuBarButtonItem;

-(void)initialize;

@end

@implementation SDMenuViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if( self = [super initWithCoder:aDecoder] ){
        [self initialize];
    }
    return self;
}

#pragma mark - UIViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ){
        [self initialize];
    }
    return self;
}

#pragma mark - SDMenuViewController

-(void)initialize{
//    self.paneViewControllerType = NSUIntegerMax;
//    self.paneViewControllerTitles = @{
//                                      @(SDPaneViewControllerType_Search) : @"Search",
//                                      @(SDPaneViewControllerType_Home) : @"Home",
//                                      @(SDPaneViewControllerType_User) : @"User",
//                                      @(SDPaneViewControllerType_Friends) : @"Friends",
//                                      @(SDPaneViewControllerType_Agenda) : @"Agenda",
//                                      @(SDPaneViewControllerType_Chats) : @"Chats",
//                                      @(SDPaneViewControllerType_Settings) : @"Settings"
//                                      };
//    self.paneViewControllerIdentifiers = @{
//                                      @(SDPaneViewControllerType_Search) : @"Search",
//                                      @(SDPaneViewControllerType_Home) : @"Home",
//                                      @(SDPaneViewControllerType_User) : @"User",
//                                      @(SDPaneViewControllerType_Friends) : @"Friends",
//                                      @(SDPaneViewControllerType_Agenda) : @"Agenda",
//                                      @(SDPaneViewControllerType_Chats) : @"Chats",
//                                      @(SDPaneViewControllerType_Settings) : @"Settings"
//                                      };
}

-(SDPaneViewControllerType)paneViewControllerTypeForIndexPath:(NSIndexPath*)indexPath{
    SDPaneViewControllerType paneViewControllerType = indexPath.row;
    return paneViewControllerType;
}

-(void)transitionToViewController:(SDPaneViewControllerType)paneViewControllerType{
//    if( paneViewControllerType == self.paneViewControllerType ){
//        [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:TRUE allowUserInterruption:TRUE completion:nil];
//        return;
//    }
//    
//    BOOL animationTransition = self.dynamicsDrawerViewController.paneViewController != nil;
//    
//    UIViewController* paneViewController = [self.storyboard instantiateViewControllerWithIdentifier:self.paneViewControllerIdentifiers[@(paneViewControllerType)]];
//    if( !paneViewController ){
//        paneViewController = [UIViewController new];
//    }
//    
//    paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
//    
//    self.menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(dynamicsDrawerMenuBarButtonItemTapped:)];
//    paneViewController.navigationItem.leftBarButtonItem = self.menuBarButtonItem;
//    
//    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
//    [self.dynamicsDrawerViewController setPaneViewController:navigationController animated:animationTransition completion:nil];
//    
//    self.paneViewControllerType = paneViewControllerType;
}

-(void)dynamicsDrawerMenuBarButtonItemTapped:(id)sender{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:TRUE allowUserInterruption:TRUE completion:nil];
}

@end
