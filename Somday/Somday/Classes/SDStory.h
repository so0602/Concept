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
    SDStoryType_Voice,
    SDStoryType_Event,
    SDStoryType_Storybook,
    SDStoryType_Link,
    
    SDStoryType_Min = SDStoryType_Text,
    SDStoryType_Max = SDStoryType_Link,
};

//typedef NS_ENUM(NSUInteger, SDStoryType){
//    SDStoryType_Link,
//    SDStoryType_Voice,
//    SDStoryType_Photo,
//    SDStoryType_Text,
//    SDStoryType_Event,
//    SDStoryType_Storybook,
//    
//    
//    SDStoryType_Min = SDStoryType_Link,
//    SDStoryType_Max = SDStoryType_Photo,
//};

@interface SDStory : NSObject<SDDataObjectBase>

@property (nonatomic, strong, readonly) NSNumber* ID;
//@property (nonatomic, strong, readonly) NSString* title;
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
@property (nonatomic, strong) NSString* title;
@property (nonatomic, strong) NSNumber* type;
@property (nonatomic, strong) NSString* imageName;
@property (nonatomic, strong) NSNumber* likeCount;
@property (nonatomic, strong) NSNumber* commentCount;
@property (nonatomic, strong) NSString* userIconName;
@property (nonatomic, strong) NSString* userName;
@property (nonatomic, strong) NSDate* date;
@property (nonatomic, strong) NSString* address;
@property (nonatomic, strong) NSString* audioName;
@property (nonatomic, strong) NSString* websiteLink;
@property (nonatomic, strong) UIImage* websiteImage;

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