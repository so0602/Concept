//
//  SDNetworkUtils.m
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDNetworkUtils.h"

#import "ASIFormDataRequest+Addition.h"

#import "JSONKit.h"

const CGFloat SDTimeOutSeconds = 60.0f;

@interface SDNetworkUtils ()

+(ASIFormDataRequest*)baseHttpRequest;

+(NSDictionary*)basePostValues;

@end

@implementation SDNetworkUtils

+(void)loginWithAttributes:(NSDictionary*)attributes completion:(void(^)(id<NSObject> jsonObject))completionBlock failed:(void(^)(ASIHTTPRequest*))failedBlock{
    __weak ASIFormDataRequest* request = [SDNetworkUtils baseHttpRequest];
    [request addPostValues:attributes];
    
    [request setCompletionBlock:^{
        if( completionBlock ){
            completionBlock(request.responseString.objectFromJSONString);
        }
    }];
    
    [request setFailedBlock:^{
        if( failedBlock ){
            failedBlock(request);
        }
    }];
    
    [request startAsynchronous];
}

#pragma mark - Private Functions

+(ASIFormDataRequest*)baseHttpRequest{
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:nil];
    request.timeOutSeconds = SDTimeOutSeconds;
    request.requestMethod = @"POST";
    
    [request addPostValues:[SDNetworkUtils basePostValues]];
    
    return request;
}

+(NSDictionary*)basePostValues{
    // TODO
    return nil;
}

@end
