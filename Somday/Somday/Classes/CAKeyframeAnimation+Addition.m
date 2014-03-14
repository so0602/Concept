//
//  CAKeyframeAnimation+Addition.m
//  Somday
//
//  Created by Tao, Steven on 3/14/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "CAKeyframeAnimation+Addition.h"

@implementation CAKeyframeAnimation (Addition)

//KeyframeParametricBlock openFunction = ^double(double time) {
//    return sin(time*M_PI_2);
//};
//KeyframeParametricBlock closeFunction = ^double(double time) {
//    return -cos(time*M_PI_2)+1;
//};

+ (id)animationWithKeyPath:(NSString *)path function:(KeyframeParametricBlock)block fromValue:(double)fromValue toValue:(double)toValue
{
    // get a keyframe animation to set up
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:path];
    // break the time into steps (the more steps, the smoother the animation)
    NSUInteger steps = 100;
    NSMutableArray *values = [NSMutableArray arrayWithCapacity:steps];
    double time = 0.0;
    double timeStep = 1.0 / (double)(steps - 1);
    for(NSUInteger i = 0; i < steps; i++) {
        double value = fromValue + (block(time) * (toValue - fromValue));
        [values addObject:[NSNumber numberWithDouble:value]];
        time += timeStep;
    }
    // we want linear animation between keyframes, with equal time steps
    animation.calculationMode = kCAAnimationLinear;
    // set keyframes and we're done
    [animation setValues:values];
    return(animation);
}

@end
