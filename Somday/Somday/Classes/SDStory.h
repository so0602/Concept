//
//  SDStory.h
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDDataObjectBase.h"

typedef NS_ENUM(NSUInteger, SDStoryType){
    SDStoryType_Text,
    SDStoryType_Photo,
    SDStoryType_Event,
    SDStoryType_Storybook,
    SDStoryType_Link,
    SDStoryType_Voice,
};

@interface SDStory : NSObject<SDDataObjectBase>

@property (nonatomic, strong, readonly) NSNumber* ID;
@property (nonatomic, strong, readonly) NSString* title;
@property (nonatomic, strong, readonly) NSString* summary;
@property (nonatomic, strong, readonly) NSString* content;
@property (nonatomic, strong, readonly) NSString* videoUrl;
@property (nonatomic, strong, readonly) NSString* displayLevel;
@property (nonatomic, strong, readonly) NSNumber* profileId;
@property (nonatomic, strong, readonly) NSDate* createDate;
@property (nonatomic, strong, readonly) NSDate* modifiedDate;
@property (nonatomic, strong, readonly) NSNumber* createBy;
@property (nonatomic, strong, readonly) NSNumber* modifiedBy;
@property (nonatomic, strong, readonly) NSArray* images;

// Temp Data
@property (nonatomic, strong) NSNumber* type;
@property (nonatomic, strong) NSString* imageName;

@end

extern NSString* SDStory_ID;
extern NSString* SDStory_Title;
extern NSString* SDStory_Summary;
extern NSString* SDStory_Content;
extern NSString* SDStory_VideoUrl;
extern NSString* SDStory_DisplayLevel;
extern NSString* SDStory_ProfileId;
extern NSString* SDStory_CreatedDate;
extern NSString* SDStory_ModifiedDate;
extern NSString* SDStory_CreateBy;
extern NSString* SDStory_ModifiedBy;
extern NSString* SDStory_Images;