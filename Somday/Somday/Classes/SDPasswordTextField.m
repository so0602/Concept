//
//  SDPasswordTextField.m
//  Somday
//
//  Created by Freddy on 12/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDPasswordTextField.h"

#import "UITextField+Addition.h"

@interface SDTextField ()

-(void)initialize;

@end

@implementation SDPasswordTextField

#pragma mark - SDTextField Private Functions

-(void)initialize{
    self.rightImage = [UIImage imageNamed:@"icons-shadow-16px_lock"];
}

@end