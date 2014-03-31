//
//  SDMainNavigationController.m
//  Somday
//
//  Created by Freddy on 31/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDMainNavigationController.h"

#import "GPUImage.h"

static const NSUInteger BackgroundImageCount = 5;

@interface SDMainNavigationController ()

@property (nonatomic, strong) NSMutableArray* backgroundImagePictures;

@property (nonatomic) NSInteger currentIndex;

-(void)initialize;

@end

@implementation SDMainNavigationController

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if( self = [super initWithCoder:aDecoder] ){
        [self initialize];
    }
    return self;
}

-(void)setBackgroundImage:(UIImage *)backgroundImage{
    _backgroundImage = backgroundImage;
    
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"class = %@", [NSNull class]];
    BOOL isFirstView = [self.backgroundImagePictures filteredArrayUsingPredicate:predicate].count == self.backgroundImagePictures.count;
    
    __block GPUImageView* imageView = nil;
    GPUImageiOSBlurFilter* filter = nil;
    
    NSInteger index = isFirstView ? self.currentIndex : (self.currentIndex + 1) % BackgroundImageCount;
    GPUImagePicture* picture = [self.backgroundImagePictures objectAtIndex:index];
    if( [picture isKindOfClass:[GPUImagePicture class]] ){
        filter = picture.targets.firstObject;
        imageView = filter.targets.firstObject;
    }else{
        imageView = [[GPUImageView alloc] initWithFrame:self.view.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.clipsToBounds = TRUE;
        imageView.layer.contentsGravity = kCAGravityTop;
        imageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
        
        filter = [[GPUImageiOSBlurFilter alloc] init];
        filter.blurRadiusInPixels = 1.0f;
        [filter addTarget:imageView];
    }
    
    picture = [[GPUImagePicture alloc] initWithImage:_backgroundImage];
    [picture addTarget:filter];
    [picture processImage];
    
    if( !isFirstView ){
        [self.view addSubview:imageView];
    }else{
        GPUImagePicture* prevPicture = [self.backgroundImagePictures objectAtIndex:self.currentIndex];
        GPUImageiOSBlurFilter* prevFilter = prevPicture.targets.firstObject;
        __block GPUImageView* prevImageView = prevFilter.targets.firstObject;
        
        imageView.alpha = 0.0f;
        [self.view addSubview:imageView];
        [UIView animateWithDuration:0.4 animations:^{
            prevImageView.alpha = 0.0f;
            imageView.alpha = 1.0f;
        } completion:^(BOOL finished) {
            [prevImageView removeFromSuperview];
        }];
    }
    
    [self.backgroundImagePictures replaceObjectAtIndex:index withObject:picture];
    self.currentIndex = index;
}

#pragma mark - Private Functions

-(void)initialize{
    self.backgroundImagePictures = [NSMutableArray array];
    for( int i = 0; i < BackgroundImageCount; i++ ){
        [self.backgroundImagePictures addObject:[NSNull null]];
    }
    
    self.currentIndex = 0;
}

@end
