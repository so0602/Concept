//
//  SDNetworkUtils.m
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDNetworkUtils.h"

#import "JSONKit.h"

#import "ASIFormDataRequest+Addition.h"

#define BaseUrl @"http://219.76.177.77:8100"

#define UserLoginUrl BaseUrl @"/rest/auth/login"
#define CheckUserExistUrl BaseUrl @"/rest/users/checkUserExist"
#define CreateUserUrl BaseUrl @"/rest/users/create"
#define GetStoryListUrl BaseUrl @"/rest/story/list"

const CGFloat SDTimeOutSeconds = 60.0f;

@interface SDNetworkUtils ()

+(NSDictionary*)basePostValues;

+(ASIFormDataRequest*)baseHttpRequest;

+(ASIFormDataRequest*)requestWithUrl:(NSString*)url attributes:(NSDictionary*)attributes completion:(void(^)(id<SDResponseBase> response))completionBlock failed:(void(^)(id<SDResponseBase> response))failedBlock returnClass:(Class)class;

@end

@implementation SDNetworkUtils

+(ASIHTTPRequest*)loginWithUsername:(NSString*)username password:(NSString*)password completion:(void(^)(SDLogin* response))completionBlock failed:(void(^)(SDLogin* response))failedBlock{
    NSAssert(username && password, @"Username & password must not be empty.");
    
    NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
    [attributes setObject:username forKey:SDUrlAttribute_Username];
    [attributes setObject:password forKey:SDUrlAttribute_Password];

    ASIHTTPRequest* request = [SDNetworkUtils requestWithUrl:UserLoginUrl attributes:attributes completion:completionBlock failed:failedBlock returnClass:[SDLogin class]];
    
    [request startAsynchronous];
    
    return request;
}

+(ASIHTTPRequest*)checkUserExistWithUsername:(NSString*)username completion:(void(^)(SDCheckUserExist* response))completionBlock failed:(void(^)(SDCheckUserExist* response))failedBlock{
    NSAssert(username, @"Username must not be empty.");
    
    NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
    [attributes setObject:[NSDictionary dictionaryWithObject:username forKey:SDUrlAttribute_Username] forKey:SDUrlAttribute_User];
    
    ASIHTTPRequest* request = [SDNetworkUtils requestWithUrl:CheckUserExistUrl attributes:attributes completion:completionBlock failed:failedBlock returnClass:[SDCheckUserExist class]];
    
    [request startAsynchronous];
    
    return request;
}

+(ASIHTTPRequest*)createUserWithUsername:(NSString*)username password:(NSString*)password completion:(void(^)(SDCreateUser* response))completionBlock failed:(void(^)(SDCreateUser* response))failedBlock{
    NSAssert(username && password, @"Username & password must not be empty.");
    
    NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
    [attributes setObject:username forKey:SDUrlAttribute_Username];
    [attributes setObject:password forKey:SDUrlAttribute_Password];
    attributes = [NSMutableDictionary dictionaryWithObject:attributes forKey:SDUrlAttribute_User];
    
    ASIHTTPRequest* request = [SDNetworkUtils requestWithUrl:CreateUserUrl attributes:attributes completion:completionBlock failed:failedBlock returnClass:[SDCreateUser class]];
    
    [request startAsynchronous];
    
    return request;
}

+(ASIHTTPRequest*)storiesWithUsername:(NSString*)username completion:(void(^)(SDStories* response))completionBlock failed:(void(^)(SDStories* response))failedBlock{
    NSAssert(username, @"Username must not be empty.");
    
    NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
    [attributes setObject:username forKey:SDUrlAttribute_Username];
    
    ASIHTTPRequest* request = [SDNetworkUtils requestWithUrl:GetStoryListUrl attributes:attributes completion:completionBlock failed:failedBlock returnClass:[SDStories class]];
    
    [request startAsynchronous];
    
    return request;
}

#pragma mark - Private Functions

+(NSDictionary*)basePostValues{
    NSMutableDictionary* basePostValues = [NSMutableDictionary dictionary];
    [basePostValues setObject:[NSDictionary dictionaryWithObject:@"TBC"/*TODO*/ forKey:SDUrlAttribute_SecurityToken] forKey:SDUrlAttribute_Header];
    [basePostValues setObject:@"TBC"/*TODO*/ forKey:SDUrlAttribute_RequestId];
    return basePostValues;
}

+(ASIFormDataRequest*)baseHttpRequest{
    ASIFormDataRequest* request = [ASIFormDataRequest requestWithURL:nil];
    request.timeOutSeconds = SDTimeOutSeconds;
    request.requestMethod = @"POST";
    
    [request addPostValues:[SDNetworkUtils basePostValues]];
    
    return request;
}

+(ASIFormDataRequest*)requestWithUrl:(NSString*)url attributes:(NSDictionary*)attributes completion:(void(^)(id<SDResponseBase> response))completionBlock failed:(void(^)(id<SDResponseBase> response))failedBlock returnClass:(Class)class{
    __weak ASIFormDataRequest* request = [SDNetworkUtils baseHttpRequest];
    request.url = [NSURL URLWithString:url];
    
    [request addPostValues:attributes];
    
    [request setCompletionBlock:^{
        SDResponseBase* response = [[class alloc] initWithDictionary:request.responseString.objectFromJSONString];
        if( response.isSuccess && completionBlock ){
            completionBlock(response);
        }else if( !response.isSuccess && failedBlock ){
            failedBlock(response);
        }
    }];
    
    [request setFailedBlock:^{
        if( failedBlock ){
            SDResponseBase* response = [[class alloc] initWithDictionary:nil];
            response.request = request;
            failedBlock(response);
        }
    }];
    
    return request;
}

@end

NSString* SDUrlAttribute_Header = @"header";
NSString* SDUrlAttribute_SecurityToken = @"securityToken";
NSString* SDUrlAttribute_RequestId = @"requestId";
NSString* SDUrlAttribute_User = @"user";
NSString* SDUrlAttribute_Username = @"username";
NSString* SDUrlAttribute_Password = @"password";

NSString* SDUrlAttribute_Status = @"status";
NSString* SDUrlAttribute_Code = @"code";
NSString* SDUrlAttribute_Message = @"message";

NSString* SDUrlAttribute_Stories = @"stories";