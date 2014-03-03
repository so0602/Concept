//
//  SDDynamicsDrawerViewController.m
//  Concept
//
//  Created by Freddy So on 2/26/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDDynamicsDrawerViewController.h"

#import "SDMenuViewController.h"

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
    
    SDMenuViewController* menuViewConttroller = [[SDMenuViewController alloc] init];
    menuViewConttroller.dynamicsDrawerViewController = self;
    
    [self setDrawerViewController:menuViewConttroller forDirection:MSDynamicsDrawerDirectionLeft];
    
    [menuViewConttroller transitionToViewController:SDPaneViewControllerType_Home];
}

@end
