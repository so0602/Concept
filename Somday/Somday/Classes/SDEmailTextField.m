//
//  SDEmailTextField.m
//  Somday
//
//  Created by Freddy on 11/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDEmailTextField.h"

@interface SDTextField ()

-(void)initialize;

@end

@implementation SDEmailTextField

#pragma mark - SDTextField Private Functions

-(void)initialize{
    [super initialize];
    self.rightImage = [UIImage imageNamed:@"icons-grey-ccc-12px_mail"];
}

#pragma mark - Override

-(BOOL)checkFormat{
    BOOL checkFormat = self.text.isEmailFormat;
    if( !self.text.length ){
        self.state = SDTextFieldStateNormal;
    }else{
        self.state = checkFormat ? SDTextFieldStateCorrect : SDTextFieldStateError;
    }
    return checkFormat;
}

@end
