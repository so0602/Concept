//
//  SDUtils.h
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SDLogF() SDLog(@"")
#define SDLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define SDLogE(fmt, ...) NSLog((@"ERROR >> %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#define SDLogW(fmt, ...) NSLog((@"WARNING >> %s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)

#define SDDateFormat_dd_MMM_yyyy @"dd MMM yyyy"
#define SDDateFormat_dd_MMMM @"dd MMMM"

#import "SDLogin.h"

@interface SDUtils : NSObject

+(UIStoryboard*)mainStoryboard;
+(UIMotionEffectGroup *)sharedMotionEffectGroup;

+(void)rotateView:(UIView*)view;
+(void)rotateBackView:(UIView*)view;

+(NSString*)username;
+(NSString*)password;
+(void)setUsername:(NSString*)username password:(NSString*)password;

@end
