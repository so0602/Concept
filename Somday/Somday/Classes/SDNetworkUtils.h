//
//  SDNetworkUtils.h
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"

#import "SDLogin.h"
#import "SDCheckUserExist.h"
#import "SDCreateUser.h"

@interface SDNetworkUtils : NSObject

+(ASIHTTPRequest*)loginWithUsername:(NSString*)username password:(NSString*)password completion:(void(^)(SDLogin* response))completionBlock failed:(void(^)(SDLogin* response))failedBlock;

+(ASIHTTPRequest*)checkUserExistWithUsername:(NSString*)username completion:(void(^)(SDCheckUserExist* response))completionBlock failed:(void(^)(SDCheckUserExist* response))failedBlock;

+(ASIHTTPRequest*)createUserWithUsername:(NSString*)username password:(NSString*)password completion:(void(^)(SDCreateUser* response))completionBlock failed:(void(^)(SDCreateUser* response))failedBlock;

@end

extern NSString* SDUrlAttribute_Header;
extern NSString* SDUrlAttribute_SecurityToken;
extern NSString* SDUrlAttribute_RequestId;
extern NSString* SDUrlAttribute_User;
extern NSString* SDUrlAttribute_Username;
extern NSString* SDUrlAttribute_Password;

extern NSString* SDUrlAttribute_Status;
extern NSString* SDUrlAttribute_Code;
extern NSString* SDUrlAttribute_Message;