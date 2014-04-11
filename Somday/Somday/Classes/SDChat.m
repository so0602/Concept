//
//  SDChat.m
//  Somday
//
//  Created by Tao, Steven on 4/11/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDChat.h"

@implementation SDChat

-(id)initWithDictionary:(id)dictionary{
    if( self = [super init] ){
        self.rawData = dictionary;
        self.ID = [dictionary objectForKey:@""];
        self.groupImageUrl = [dictionary objectForKey:@""];
        self.groupName = [dictionary objectForKey:@""];
        self.groupNumOfPeople = [dictionary objectForKey:@""];
        self.users = [dictionary objectForKey:@""];
        self.lastMessage = [dictionary objectForKey:@""];
        self.date = [dictionary objectForKey:@""];
        self.isGroup = _users.count>1;
    }
    return self;
}

@end
