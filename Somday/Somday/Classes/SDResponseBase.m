//
//  SDResponseObject.m
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDResponseBase.h"

#import "SDNetworkUtils.h"

@interface SDResponseBase ()

@property (nonatomic, strong, readwrite) SDStatus* status;

@end

@implementation SDResponseBase

@synthesize request = _request;

#pragma mark - SDDataObjectBase

-(instancetype)initWithDictionary:(id)dictionary{
    if( self = [super init] ){
        self.status = [[SDStatus alloc] initWithDictionary:[dictionary objectForKey:SDUrlAttribute_Status]];
        self.request = nil;
    }
    return self;
}

-(BOOL)isSuccess{
    return self.request ? TRUE : self.status.isSuccess;
}

@end
