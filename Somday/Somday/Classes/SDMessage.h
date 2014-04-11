//
//  SDMessage.h
//  Somday
//
//  Created by Tao, Steven on 4/11/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDMessage : NSObject

@property (nonatomic,strong) NSNumber *ID;
@property (nonatomic,strong) NSNumber *userID;
@property (nonatomic,strong) NSString *message;
@property (nonatomic) BOOL isRead;
@property (nonatomic) BOOL isSend;

@end
