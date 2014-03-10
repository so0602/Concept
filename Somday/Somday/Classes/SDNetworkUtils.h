//
//  SDNetworkUtils.h
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ASIHTTPRequest.h"

@interface SDNetworkUtils : NSObject

// attributes: username & password
+(void)loginWithAttributes:(NSDictionary*)attributes completion:(void(^)(id<NSObject> jsonObject))completionBlock failed:(void(^)(ASIHTTPRequest*))failedBlock;

@end
