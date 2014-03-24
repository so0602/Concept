//
//  SDPasswordTextField.m
//  Somday
//
//  Created by Freddy on 12/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDPasswordTextField.h"

#import "UITextField+Addition.h"
#import "NSString+Addition.h"

@interface SDTextField ()

-(void)initialize;

@end

@implementation SDPasswordTextField

#pragma mark - SDTextField Private Functions

-(void)initialize{
    [super initialize];
    self.rightImage = [UIImage imageNamed:@"icons-grey-ccc-12px_lock"];
}

#pragma mark - Override

-(BOOL)checkFormat{
    BOOL checkFormat = self.text.isPasswordFormat;
    self.state = checkFormat ? SDTextFieldStateCorrect : SDTextFieldStateError;
    return checkFormat;
}

@end