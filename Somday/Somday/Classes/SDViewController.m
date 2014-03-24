//
//  SDViewController.m
//  Somday
//
//  Created by Freddy on 25/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDViewController.h"

@interface SDViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer* tapGestureRecognizer;

-(void)tapped:(UITapGestureRecognizer*)gesture;

@end

@implementation SDViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if( !self.tapGestureRecognizer ){
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        self.tapGestureRecognizer.numberOfTapsRequired = 1;
        self.tapGestureRecognizer.numberOfTouchesRequired = 1;
        self.tapGestureRecognizer.delegate = self;
    }
    if( !self.view.gestureRecognizers || [self.view.gestureRecognizers indexOfObject:self.tapGestureRecognizer] == NSNotFound ){
        [self.view addGestureRecognizer:self.tapGestureRecognizer];
    }
}

-(void)dealloc{
    [self.view removeGestureRecognizer:self.tapGestureRecognizer];
}

-(void)dismissKeyboard{
    // Override
}

#pragma mark - Private Functions

-(void)tapped:(UITapGestureRecognizer*)gesture{
    if( [self.tapGestureRecognizer isEqual:gesture] ){
        [self dismissKeyboard];
    }
}

#pragma mark - UIGestureRecognizerDelegate

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    BOOL receive = !([touch.view isKindOfClass:[UITextField class]] || [touch.view isKindOfClass:[UIButton class]]);
    return receive;
}

@end
