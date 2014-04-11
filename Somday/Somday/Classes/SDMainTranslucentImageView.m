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

@interface SDMainTranslucentImageView ()

@property (nonatomic) BOOL keepUpdate;

@end

@interface SDMainTranslucentImageView () <SDMainNavigationControllerDelegate>

-(void)viewControllerWillUpdate:(NSNotification*)notification;
-(void)viewControllerDidUpdate:(NSNotification *)notification;

@end

@implementation SDMainTranslucentImageView

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
    
#if defined(LeftNavigationControl) && LeftNavigationControl
    SDAppDelegate* delegate = [UIApplication sharedApplication].delegate;
    [delegate.navigationController removeDelegate:self];
#endif
}

-(void)viewControllerWillUpdate:(NSNotification *)notification{
    self.keepUpdate = TRUE;
    
#if defined(LeftNavigationControl) && LeftNavigationControl
    SDAppDelegate* delegate = (id)[UIApplication sharedApplication].delegate;
    SDMainNavigationController* viewController = delegate.navigationController;
    self.targetImage = viewController.processedBackgroundImage;
    self.targetView = viewController.currentBackgroundView.superview;
#endif
    
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
