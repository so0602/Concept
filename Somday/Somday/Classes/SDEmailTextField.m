//
//  SDEmailTextField.m
//  Somday
//
//  Created by Freddy on 11/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDEmailTextField.h"

#import "UITextField+Addition.h"

@interface SDTextField ()

-(void)initialize;

@end

@implementation SDEmailTextField

#pragma mark - SDTextField Private Functions

-(void)initialize{
    self.rightImage = [UIImage imageNamed:@"icons-grey-ccc-12px_mail"];
}

@end
