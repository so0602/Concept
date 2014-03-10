//
//  SDStories.m
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDStories.h"

#import "SDNetworkUtils.h"

@interface SDStories ()

@property (nonatomic, strong, readwrite) NSArray* stories;

@end

@implementation SDStories

-(id)initWithDictionary:(id)dictionary{
    if( self = [super initWithDictionary:dictionary] ){
        self.stories = [SDStory arrayWithDictionaries:[dictionary objectForKey:SDUrlAttribute_Stories]];
    }
    return self;
}

@end
