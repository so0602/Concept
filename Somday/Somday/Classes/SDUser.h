//
//  SDUser.h
//  Somday
//
//  Created by Tao, Steven on 4/11/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SDDataObject.h"

@interface SDUser : SDDataObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *profileImageURL;
@property (nonatomic) BOOL isFriend;

@end
