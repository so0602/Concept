//
//  SDTranslucentImageView.m
//  Somday
//
//  Created by Freddy on 7/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDTranslucentImageView.h"

@interface SDTranslucentImageView ()

@property (nonatomic) BOOL keepUpdate;

@end

@implementation SDTranslucentImageView

-(void)layoutSubviews{
    [super layoutSubviews];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if( self.targetView && self.targetImage ){
                CGRect frame = [self.superview convertRect:self.frame toView:self.targetView];
                UIImage* image = self.targetImage;
                
                CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, frame);
                image = [UIImage imageWithCGImage:imageRef];
                CGImageRelease(imageRef);
                self.image = image;
                
                if( self.width > self.image.size.width || self.height > self.image.size.height ){
                    if( frame.origin.x > 0 ){
                        self.contentMode = UIViewContentModeLeft;
                    }else if( frame.origin.x < 0 ){
                        self.contentMode = UIViewContentModeRight;
                    }else if( frame.origin.y > 0 ){
                        self.contentMode = UIViewContentModeTop;
                    }else if( frame.origin.y < 0 ){
                        self.contentMode = UIViewContentModeBottom;
                    }else{
                        self.contentMode = UIViewContentModeScaleAspectFill;
                    }
                }
                if( self.keepUpdate ){
                    [self setNeedsLayout];
                }
            }
        });
    });
}

-(void)setKeepUpdate:(BOOL)keepUpdate{
    _keepUpdate = keepUpdate;
    if( keepUpdate ){
        [self setNeedsLayout];
    }
}

@end
