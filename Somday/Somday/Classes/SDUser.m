//
//  SDUser.m
//  Somday
//
//  Created by Tao, Steven on 4/11/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDUser.h"

@implementation SDUser

-(id)initWithDictionary:(id)dictionary{
    if( self = [super init] ){
        self.rawData = dictionary;
        self.ID = [dictionary objectForKey:@""];
        self.profileImageURL = [dictionary objectForKey:@""];
        self.isFriend = [dictionary objectForKey:@""];
    }
    return self;
}

@end
