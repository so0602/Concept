//
//  SDBaseGridView.h
//  Somday
//
//  Created by Tao, Steven on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef double (^KeyframeParametricBlock)(double);
@interface CAKeyframeAnimation (SomDay)

+ (id)animationWithKeyPath:(NSString *)path
                  function:(KeyframeParametricBlock)block
                 fromValue:(double)fromValue
                   toValue:(double)toValue;

@end

@interface SDBaseGridView : UICollectionViewCell

@property (nonatomic) UIImage *image;
@property (nonatomic) UIImageView *backgroundImageView;

- (void)toggleMenu;

@end
