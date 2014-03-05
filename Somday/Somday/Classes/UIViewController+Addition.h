//
//  UIViewController+Addition.h
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIView+Addition.h"

@interface UIViewController (Addition)

+(instancetype)viewControllerFromStoryboard;
+(instancetype)viewControllerFromStoryboardWithIdentifier:(NSString*)identifier;

-(IBAction)touchUpInside:(id)sender;

@end
