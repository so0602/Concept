//
//  SDDataObject.h
//  Somday
//
//  Created by Tao, Steven on 4/11/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDDataObject : NSObject <SDDataObjectBase>
@property (nonatomic,strong) NSDictionary *rawData;
@end
