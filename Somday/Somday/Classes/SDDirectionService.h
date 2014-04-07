//
//  SDDirectionService.h
//  Somday
//
//  Created by Tao, Steven on 4/7/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDDirectionService : NSObject
- (void)setDirectionsQuery:(NSDictionary *)object withSelector:(SEL)selector
              withDelegate:(id)delegate;
- (void)retrieveDirections:(SEL)sel withDelegate:(id)delegate;
- (void)fetchedData:(NSData *)data withSelector:(SEL)selector
       withDelegate:(id)delegate;
@end
