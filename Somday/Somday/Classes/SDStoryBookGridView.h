//
//  SDStoryBookGridView.h
//  Somday
//
//  Created by Tao, Steven on 3/18/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDBaseGridView.h"


@interface SDStoryBookGridView : SDBaseGridView 

@property (nonatomic) IBOutletCollection(UIImageView) NSArray *imageViews;
@property (nonatomic) NSArray *viewStack;
@property (nonatomic) NSArray *dataSource;

@end
