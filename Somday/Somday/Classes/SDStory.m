//
//  SDStory.m
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDStory.h"

@interface SDStory ()

@property (nonatomic, strong, readwrite) NSNumber* ID;
@property (nonatomic, strong, readwrite) NSString* title;
@property (nonatomic, strong, readwrite) NSString* summary;
@property (nonatomic, strong, readwrite) NSString* content;
@property (nonatomic, strong, readwrite) NSString* videoUrl;
@property (nonatomic, strong, readwrite) NSString* displayLevel;
@property (nonatomic, strong, readwrite) NSNumber* profileId;
@property (nonatomic, strong, readwrite) NSDate* createDate;
@property (nonatomic, strong, readwrite) NSDate* modifiedDate;
@property (nonatomic, strong, readwrite) NSNumber* createBy;
@property (nonatomic, strong, readwrite) NSNumber* modifiedBy;
@property (nonatomic, strong, readwrite) NSArray* images;

@end

@implementation SDStory

@synthesize type;
@synthesize imageName;
@synthesize likeCount;
@synthesize commentCount;

-(id)initWithDictionary:(id)dictionary{
    if( self = [super init] ){
        self.ID = [dictionary objectForKey:SDStory_ID];
        self.title = [dictionary objectForKey:SDStory_Title];
        self.summary = [dictionary objectForKey:SDStory_Summary];
        self.content = [dictionary objectForKey:SDStory_Content];
        self.videoUrl = [dictionary objectForKey:SDStory_VideoUrl];
        self.displayLevel = [dictionary objectForKey:SDStory_DisplayLevel];
        self.profileId = [dictionary objectForKey:SDStory_ProfileId];
        self.createDate = [dictionary objectForKey:SDStory_CreatedDate];
        self.modifiedDate = [dictionary objectForKey:SDStory_ModifiedDate];
        self.createBy = [dictionary objectForKey:SDStory_CreateBy];
        self.modifiedBy = [dictionary objectForKey:SDStory_ModifiedBy];
        self.images = [dictionary objectForKey:SDStory_Images];
    }
    return self;
}

-(NSArray*)arrayWithDictionaries:(NSArray*)dictionaries{
    NSMutableArray* array = [NSMutableArray array];
    
    for( NSDictionary* dictionary in dictionaries ){
        SDStory* story = [[SDStory alloc] initWithDictionary:dictionary];
        [array addObject:story];
    }
    
    return array;
}

@end

NSString* SDStory_ID = @"id";
NSString* SDStory_Title = @"title";
NSString* SDStory_Summary = @"summary";
NSString* SDStory_Content = @"content";
NSString* SDStory_VideoUrl = @"videoUrl";
NSString* SDStory_DisplayLevel = @"displayLevel";
NSString* SDStory_ProfileId = @"profileId";
NSString* SDStory_CreatedDate = @"createdDate";
NSString* SDStory_ModifiedDate = @"modifiedDate";
NSString* SDStory_CreateBy = @"createBy";
NSString* SDStory_ModifiedBy = @"modifiedBy";
NSString* SDStory_Images = @"images";