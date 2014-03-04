//
//  UIViewController+Addition.h
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Addition)

+(instancetype)viewControllerFromStoryboard;
+(instancetype)viewControllerFromStoryboardWithIdentifier:(NSString*)identifier;


@end
