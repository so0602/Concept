//
//  SDTextField.m
//  Somday
//
//  Created by Freddy on 12/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDTextField.h"

@interface SDTextField ()

-(void)initialize;

@end

@implementation SDTextField

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if( self = [super initWithCoder:aDecoder] ){
        [self initialize];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if( self = [super initWithFrame:frame] ){
        [self initialize];
    }
    return self;
}

#pragma mark - Private Functions

-(void)initialize{
}

@end
