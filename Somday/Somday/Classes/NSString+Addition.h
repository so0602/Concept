//
//  NSString+Addition.h
//  Somday
//
//  Created by Freddy So on 3/12/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Addition)

@property (nonatomic, assign, getter=isEmailFormat, readonly) BOOL emailFormat;
@property (nonatomic, assign, getter=isPasswordFormat, readonly) BOOL passwordFormat;

@end
