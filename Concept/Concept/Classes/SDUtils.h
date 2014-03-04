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

@interface SDUtils : NSObject

+(UIStoryboard*)mainStoryboard;

@end
