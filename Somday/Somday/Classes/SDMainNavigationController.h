//
//  SDMainNavigationController.h
//  Somday
//
//  Created by Freddy on 31/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDMainNavigationController;

@protocol SDMainNavigationControllerDelegate<NSObject>

-(void)navigationController:(SDMainNavigationController*)navigationController backgroundWillChange:(UIImage*)processedBackgroundImage;
-(void)navigationController:(SDMainNavigationController*)navigationController backgroundDidChange:(UIImage*)processedBackgroundImage;

@end

@interface SDMainNavigationController : UINavigationController

@property (nonatomic, strong) UIImage* backgroundImage;
@property (nonatomic, strong, readonly) UIImage* processedBackgroundImage;
@property (nonatomic, strong, readonly) UIView* currentBackgroundView;

-(UIImage*)processedBackgroundImageWithFrame:(CGRect)frame;

-(void)addDelegate:(id<SDMainNavigationControllerDelegate>)delegate;
-(void)removeDelegate:(id<SDMainNavigationControllerDelegate>)delegate;

@end
