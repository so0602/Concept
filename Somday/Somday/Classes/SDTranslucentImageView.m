//
//  SDTranslucentImageView.m
//  Somday
//
//  Created by Freddy on 1/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDTranslucentImageView.h"

#import "SDAppDelegate.h"

#import "NSNotificationCenter+Name.h"
#import "UIView+Addition.h"

@interface SDTranslucentImageView ()

-(void)viewControllerWillUpdate:(NSNotification*)notification;
-(void)viewControllerDidUpdate:(NSNotification *)notification;
@property (nonatomic) BOOL keepUpdate;

@end

@implementation SDTranslucentImageView

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
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
       dispatch_async(dispatch_get_main_queue(), ^{
           
           if( self.targetView && self.targetImage ){
               CGRect frame = [self convertRect:self.frame toView:self.targetView];
               UIImage* image = self.targetImage;
               CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
               image = [UIImage imageWithCGImage:imageRef];
               CGImageRelease(imageRef);
               self.image = image;
               if( self.width > self.image.size.width || self.height > self.image.size.height ){
                   if( frame.origin.x > 0 ){
                       self.contentMode = UIViewContentModeLeft;
                   }else if( frame.origin.x < 0 ){
                       self.contentMode = UIViewContentModeRight;
                   }else if( frame.origin.y > 0 ){
                       self.contentMode = UIViewContentModeTop;
                   }else if( frame.origin.y < 0 ){
                       self.contentMode = UIViewContentModeBottom;
                   }else{
                       self.contentMode = UIViewContentModeScaleAspectFill;
                   }
               }
               if( self.keepUpdate ){
                   [self setNeedsLayout];
               }
           }
       });
    });
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

@end
