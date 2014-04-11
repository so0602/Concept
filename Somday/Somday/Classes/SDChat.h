//
//  SDChat.h
//  Somday
//
//  Created by Tao, Steven on 4/11/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDDataObject.h"

@class SDMessage;

@interface SDChat : SDDataObject

@property (nonatomic, strong) NSNumber* ID;
@property (nonatomic, strong) NSString* groupImageUrl;
@property (nonatomic, strong) NSString* groupName;
@property (nonatomic, strong) NSString* groupNumOfPeople;
@property (nonatomic, strong) NSArray* users;
@property (nonatomic, strong) SDMessage* lastMessage;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic) BOOL isGroup;

@end
