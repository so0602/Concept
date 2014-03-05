//
//  SDSearchViewController.h
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SDSearchViewController;

@protocol SDSearchViewControllerDelegate<NSObject>

@optional
-(void)backButtonDidClick:(SDSearchViewController*)searchViewController;

@end

@interface SDSearchViewController : UIViewController

@property (nonatomic, strong) UIImage* backgroundImage;
@property (nonatomic, weak) id<SDSearchViewControllerDelegate> delegate;

@end
