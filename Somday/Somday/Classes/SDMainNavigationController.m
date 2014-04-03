//
//  SDMainNavigationController.m
//  Somday
//
//  Created by Freddy on 31/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDMainNavigationController.h"

#import "GPUImage.h"

#import "UIView+Addition.h"
#import "NSNotificationCenter+Name.h"
#import "UIImage+ImageEffects.h"
#import "UIImage+Resizing.h"

static const NSUInteger BackgroundImageCount = 5;
static const CGFloat ProcessedBackgroundImageScaleFactor = 1;

@interface SDMainNavigationController ()

@property (nonatomic, strong) NSMutableArray* backgroundImageViews;

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, strong, readwrite) UIImage* processedBackgroundImage;
@property (nonatomic, strong) UIImage* processedBackgroundImageWithDarkLayer;

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
    if( [_backgroundImage isEqual:backgroundImage] ){
        return;
    }
    _backgroundImage = backgroundImage;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"self = %@", [NSNull null]];
    __block BOOL isFirstView = [self.backgroundImageViews filteredArrayUsingPredicate:predicate].count == self.backgroundImageViews.count;
    
    if( isFirstView ){
        UIImage* image = [_backgroundImage resizeImageProportionallyWithScaleFactor:0.4];
        image = [image applyBlurWithRadius:5 tintColor:nil saturationDeltaFactor:2 maskImage:nil];
        
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.clipsToBounds = TRUE;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = image;
        
        UIViewController* viewController = self.viewControllers.firstObject;
        UIView* view = viewController.view;
        [view insertSubview:imageView atIndex:0];
        
        [self.backgroundImageViews replaceObjectAtIndex:0 withObject:imageView];
        self.currentIndex = 0;
        
        self.processedBackgroundImage = imageView.convertViewToImage;
        self.processedBackgroundImageWithDarkLayer = [self.processedBackgroundImage applyBlurWithRadius:1 tintColor:[UIColor colorWithWhite:0 alpha:0.5] saturationDeltaFactor:1 maskImage:nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:MainBackgroundImageDidChangeNotification object:self userInfo:nil];
    }else{
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
            __block UIImage* image = [_backgroundImage resizeImageProportionallyWithScaleFactor:0.4];
            image = [image applyBlurWithRadius:5 tintColor:[UIColor colorWithWhite:0 alpha:0.2] saturationDeltaFactor:2 maskImage:nil];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                __block UIImageView* imageView = nil;
                
                NSInteger index = isFirstView ? self.currentIndex : (self.currentIndex + 1) % BackgroundImageCount;
                imageView = [self.backgroundImageViews objectAtIndex:index];
                
                if( ![imageView isKindOfClass:[UIImageView class]] ){
                    imageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
                    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                    imageView.clipsToBounds = TRUE;
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                }
                imageView.image = image;
                
                self.processedBackgroundImage = [imageView.convertViewToImage resizeImageProportionallyWithScaleFactor:ProcessedBackgroundImageScaleFactor];
                self.processedBackgroundImageWithDarkLayer = [self.processedBackgroundImage applyBlurWithRadius:1 tintColor:[UIColor colorWithWhite:0 alpha:0.3] saturationDeltaFactor:1 maskImage:nil];
                
                __block UIImageView* prevImageView = (id)self.currentBackgroundView;
                
                imageView.alpha = 0.0f;
                UIViewController* viewController = self.viewControllers.firstObject;
                UIView* view = viewController.view;
                [view insertSubview:imageView atIndex:1];
                [UIView animateWithDuration:0.4 animations:^{
                    prevImageView.alpha = 0.0f;
                    imageView.alpha = 1.0f;
                } completion:^(BOOL finished) {
                    [prevImageView removeFromSuperview];
                    prevImageView.alpha = 1.0;
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:MainBackgroundImageDidChangeNotification object:self userInfo:nil];
                }];
                
                [self.backgroundImageViews replaceObjectAtIndex:index withObject:imageView];
                self.currentIndex = index;
                
                [[NSNotificationCenter defaultCenter] postNotificationName:MainBackgroundImageWillChangeNotification object:self userInfo:nil];
            });
        });
    }
}

-(UIImage*)processedBackgroundImageWithFrame:(CGRect)_frame{
    CGRect frame = _frame;
    frame.origin.x *= ProcessedBackgroundImageScaleFactor;
    frame.origin.y *= ProcessedBackgroundImageScaleFactor;
    frame.size.width *= ProcessedBackgroundImageScaleFactor;
    frame.size.height *= ProcessedBackgroundImageScaleFactor;
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.processedBackgroundImageWithDarkLayer.CGImage, frame);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

#pragma mark - Private Functions

-(void)initialize{
    self.backgroundImageViews = [NSMutableArray array];
    for( int i = 0; i < BackgroundImageCount; i++ ){
        [self.backgroundImageViews addObject:[NSNull null]];
    }
    
    self.currentIndex = 0;
}

-(UIView*)currentBackgroundView{
    UIView* obj = [self.backgroundImageViews objectAtIndex:self.currentIndex];
    return [obj isKindOfClass:[UIView class]] ? obj : nil;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    CGRect frame = self.view.bounds;
    frame.size.height = 20;
    UIView* view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
}

@end