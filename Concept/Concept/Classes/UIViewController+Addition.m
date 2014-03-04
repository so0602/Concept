//
//  UIViewController+Addition.m
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "UIViewController+Addition.h"

#import "SDUtils.h"

@implementation UIViewController (Addition)

+(instancetype)viewControllerFromStoryboard{
    return [UIViewController viewControllerFromStoryboardWithIdentifier:NSStringFromClass(self.class)];
}

+(instancetype)viewControllerFromStoryboardWithIdentifier:(NSString*)identifier{
    return [[SDUtils mainStoryboard] instantiateViewControllerWithIdentifier:(identifier ? : NSStringFromClass(self.class))];
}

-(void)touchUpInside:(id)sender{
    
}

@end
