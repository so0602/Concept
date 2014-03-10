//
//  SDStatus.h
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDDataObjectBase.h"

@interface SDStatus : NSObject<SDDataObjectBase>

@property (nonatomic, strong, readonly) NSString* code;
@property (nonatomic, strong, readonly) NSString* message;

@property (nonatomic, readonly, getter=isSuccess) BOOL success;

@end
