//
//  SDMainNavigationController.h
//  Somday
//
//  Created by Freddy on 31/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDMainNavigationController : UINavigationController

@property (nonatomic, strong) UIImage* backgroundImage;
@property (nonatomic, strong, readonly) UIImage* processedBackgroundImage;
@property (nonatomic, strong, readonly) UIView* currentBackgroundView;

-(UIImage*)processedBackgroundImageWithFrame:(CGRect)frame;

@end
