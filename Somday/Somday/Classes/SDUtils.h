//
//  SDUtils.h
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "KeychainItemWrapper.h"
#import "SDLogin.h"

#define SDLogF() SDLog(@"")
#define SDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define SDLogE(fmt, ...) NSLog((@"ERROR >> %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define SDLogW(fmt, ...) NSLog((@"WARNING >> %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define SDDateFormat_dd_MMMM_yyyy @"dd MMMM yyyy"
#define SDDateFormat_dd_MMMM @"dd MMMM"

#define LoginInfo_CountryCode (__bridge id)kSecAttrComment
#define LoginInfo_Phone (__bridge id)kSecAttrAccount
#define LoginInfo_Password (__bridge id)kSecValueData
#define LoginInfo_Token (__bridge id)kSecAttrDescription

@interface SDUtils : NSObject

+(UIStoryboard*)mainStoryboard;
+(UIMotionEffectGroup *)sharedMotionEffectGroup;
+(KeychainItemWrapper *)sharedKeychainItemWrapper;

+(void)rotateView:(UIView*)view;
+(void)rotateBackView:(UIView*)view;

+(NSString*)username;
+(NSString*)password;
+(void)setUsername:(NSString*)username password:(NSString*)password;
+(void)logout;

@end
