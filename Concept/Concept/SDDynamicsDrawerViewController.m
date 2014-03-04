//
//  SDDynamicsDrawerViewController.m
//  Concept
//
//  Created by Freddy So on 2/26/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDDynamicsDrawerViewController.h"

#import "SDMenuViewController.h"

#import "SDUtils.h"

#import "UIViewController+Addition.h"

@interface MSDynamicsDrawerViewController ()

-(void)initialize;

@end

@interface SDDynamicsDrawerViewController ()

@end

@implementation SDDynamicsDrawerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Functions

-(void)initialize{
    [super initialize];
    
    SDMenuViewController* menuViewController = [SDMenuViewController viewControllerFromStoryboardWithIdentifier:@"MainMenu"];
    menuViewController.dynamicsDrawerViewController = self;
    
    [self setDrawerViewController:menuViewController forDirection:MSDynamicsDrawerDirectionLeft];
    
    [menuViewController transitionToViewController:SDPaneViewControllerType_Home];
    
    [self setRevealWidth:60 forDirection:MSDynamicsDrawerDirectionLeft];
}

@end
