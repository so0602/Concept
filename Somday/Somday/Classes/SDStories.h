//
//  SDStories.h
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDResponseBase.h"

#import "SDStory.h"

@interface SDStories : SDResponseBase

@property (nonatomic, strong, readonly) NSArray* stories;

@end
