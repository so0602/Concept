//
//  CAKeyframeAnimation+Addition.h
//  Somday
//
//  Created by Tao, Steven on 3/14/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

typedef double (^KeyframeParametricBlock)(double);

@interface CAKeyframeAnimation (Addition)

+ (id)animationWithKeyPath:(NSString *)path
                  function:(KeyframeParametricBlock)block
                 fromValue:(double)fromValue
                   toValue:(double)toValue;

@end
