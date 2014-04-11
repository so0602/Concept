//
//  SDMessage.m
//  Somday
//
//  Created by Tao, Steven on 4/11/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDMessage.h"

@implementation SDMessage

-(id)initWithDictionary:(id)dictionary{
    if( self = [super init] ){
        self.rawData = dictionary;
        self.ID = [dictionary objectForKey:@""];
        self.userID = [dictionary objectForKey:@""];
        self.message = [dictionary objectForKey:@""];
        self.isRead = [dictionary objectForKey:@""];
        self.isSend = [dictionary objectForKey:@""];
    }
    return self;
}

@end
