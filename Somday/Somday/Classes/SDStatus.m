//
//  SDStatus.m
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDStatus.h"

#import "SDNetworkUtils.h"

@interface SDStatus ()

@property (nonatomic, strong, readwrite) NSString* code;
@property (nonatomic, strong, readwrite) NSString* message;

@end

@implementation SDStatus

#pragma mark - SDDataObjectBase

-(instancetype)initWithDictionary:(id)dictionary{
    if( self = [super init] ){
        self.code = [dictionary objectForKey:SDUrlAttribute_Code];
        self.message = [dictionary objectForKey:SDUrlAttribute_Message];
    }
    return self;
}

-(BOOL)isSuccess{
    return [self.code isEqualToString:@"0000"];
}

@end
