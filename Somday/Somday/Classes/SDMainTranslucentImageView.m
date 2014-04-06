//
//  SDMainTranslucentImageView.m
//  Somday
//
//  Created by Freddy on 1/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDMainTranslucentImageView.h"

#import "SDAppDelegate.h"

#import "NSNotificationCenter+Name.h"

@interface SDTranslucentImageView ()

@property (nonatomic) BOOL keepUpdate;

@end

@interface SDMainTranslucentImageView () <SDMainNavigationControllerDelegate>

-(void)viewControllerWillUpdate:(NSNotification*)notification;
-(void)viewControllerDidUpdate:(NSNotification *)notification;

@end

@implementation SDMainTranslucentImageView

-(void)didMoveToSuperview{
    [super didMoveToSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerWillUpdate:) name:DynamicsDrawerViewControllerMayUpdateNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerWillUpdate:) name:DynamicsDrawerViewControllerShouldBeginPanePanNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerDidUpdate:) name:DynamicsDrawerViewControllerDidUpdateNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerWillUpdate:) name:MainBackgroundImageWillChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(viewControllerDidUpdate:) name:MainBackgroundImageDidChangeNotification object:nil];
}

-(void)removeFromSuperview{
    [super removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    SDAppDelegate* delegate = [UIApplication sharedApplication].delegate;
    [delegate.navigationController removeDelegate:self];
}

-(void)viewControllerWillUpdate:(NSNotification *)notification{
    self.keepUpdate = TRUE;
    
    SDAppDelegate* delegate = (id)[UIApplication sharedApplication].delegate;
    SDMainNavigationController* viewController = delegate.navigationController;
    self.targetImage = viewController.processedBackgroundImage;
    self.targetView = viewController.currentBackgroundView.superview;
    
    [self setNeedsLayout];
}

-(void)viewControllerDidUpdate:(NSNotification *)notification{
    self.keepUpdate = FALSE;
    [self setNeedsLayout];
}

#pragma mark - SDMainNavigationControllerDelegate

-(void)navigationController:(SDMainNavigationController*)navigationController backgroundWillChange:(UIImage*)processedBackgroundImage{
    [self viewControllerWillUpdate:nil];
}

-(void)navigationController:(SDMainNavigationController*)navigationController backgroundDidChange:(UIImage*)processedBackgroundImage{
    [self viewControllerDidUpdate:nil];
}

@end
