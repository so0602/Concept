//
//  SDDynamicsDrawerViewController.m
//  Concept
//
//  Created by Freddy So on 2/26/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDDynamicsDrawerViewController.h"

#import "SDMenuViewController.h"

@interface SDDynamicsDrawerViewController ()

-(void)initialize;

@end

@implementation SDDynamicsDrawerViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if( self = [super initWithCoder:aDecoder] ){
        [self initialize];
    }
    
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ){
        [self initialize];
    }
    return self;
}

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
//    SDMenuViewController* menuViewConttroller = [[SDMenuViewController alloc] init];
//    menuViewConttroller.dynamicsDrawerViewController = self;
//    
//    [self setDrawerViewController:menuViewConttroller forDirection:MSDynamicsDrawerDirectionLeft];
//    
//    [menuViewConttroller transitionToViewController:SDPaneViewControllerType_Home];
}

@end
