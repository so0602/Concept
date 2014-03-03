//
//  SDDynamicsDrawerViewController.m
//  Concept
//
//  Created by Freddy So on 2/26/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDDynamicsDrawerViewController.h"

@interface SDDynamicsDrawerViewController ()

-(void)setup;

@end

@implementation SDDynamicsDrawerViewController

-(id)initWithCoder:(NSCoder *)aDecoder{
    if( self = [super initWithCoder:aDecoder] ){
        [self setup];
    }
    
    return self;
}

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ){
        [self setup];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor redColor];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Functions

-(void)setup{
    UIViewController* viewConttroller = [[UIViewController alloc] init];
    viewConttroller.view.backgroundColor = [UIColor blueColor];
    [self setDrawerViewController:viewConttroller forDirection:MSDynamicsDrawerDirectionLeft];
    
//    [self transitionToViewController:[[UIViewController alloc] init]];
}

@end
