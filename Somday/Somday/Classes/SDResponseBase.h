//
//  SDResponseBase.h
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SDDataObjectBase.h"
#import "SDStatus.h"

#import "ASIHTTPRequest.h"

@protocol SDResponseBase<SDDataObjectBase>

@property (nonatomic, strong, readonly) SDStatus* status;
@property (nonatomic, strong) ASIHTTPRequest* request;

@property (nonatomic, readonly, getter=isSuccess) BOOL success;
@property (nonatomic, readonly) NSString* failMessage;

@end

@interface SDResponseBase : NSObject<SDResponseBase>

@end