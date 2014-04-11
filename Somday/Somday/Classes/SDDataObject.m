//
//  SDDataObject.m
//  Somday
//
//  Created by Tao, Steven on 4/11/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDDataObject.h"

@implementation SDDataObject

-(id)initWithDictionary:(id)dictionary{
    if( self = [super init] ){
        NSLog(@"Please implement it!!!");
    }
    return self;
}

-(NSArray*)arrayWithDictionaries:(NSArray*)dictionaries{
    NSMutableArray* array = [NSMutableArray array];
    
    for( NSDictionary* dictionary in dictionaries ){
        SDDataObject* dataObject = [[[self class] alloc] initWithDictionary:dictionary];
        [array addObject:dataObject];
    }
    
    return array;
}

@end
