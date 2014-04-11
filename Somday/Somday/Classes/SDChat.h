//
//  SDChat.h
//  Somday
//
//  Created by Tao, Steven on 4/11/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDMessage.h"

@interface SDChat : NSObject<SDDataObjectBase>

@property (nonatomic, strong, readonly) NSNumber* ID;
@property (nonatomic, strong, readonly) NSString* groupImageUrl;
@property (nonatomic, strong, readonly) NSString* groupName;
@property (nonatomic, strong, readonly) NSString* groupNumOfPeople;
@property (nonatomic, strong, readonly) NSArray* users;
@property (nonatomic, strong, readonly) SDMessage* lastMessage;
@property (nonatomic, strong, readonly) NSDate* date;

@end
