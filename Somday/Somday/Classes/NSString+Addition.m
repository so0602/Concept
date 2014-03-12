//
//  NSString+Addition.m
//  Somday
//
//  Created by Freddy So on 3/12/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "NSString+Addition.h"

@implementation NSString (Addition)

-(BOOL)isEmailFormat{
    BOOL stricterFilter = YES; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

-(BOOL)isPasswordFormat{
    return self.length >= 8;
}

@end
