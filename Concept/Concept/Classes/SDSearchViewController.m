//
//  SDSearchViewController.m
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDSearchViewController.h"

#import "GPUImage.h"

@interface SDSearchViewController ()

@property (nonatomic, strong) IBOutlet GPUImageView* backgroundImageView;

@property (nonatomic, strong) GPUImageiOSBlurFilter* blurFilter;

@end

@implementation SDSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.backgroundImageView.clipsToBounds = TRUE;
    self.backgroundImageView.layer.contentsGravity = kCAGravityTop;
    
    if( !self.blurFilter ){
        self.blurFilter = [[GPUImageiOSBlurFilter alloc] init];
        self.blurFilter.blurRadiusInPixels = 1.0f;
    }
    
    GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:self.backgroundImage];
    [picture addTarget:self.blurFilter];
    [self.blurFilter addTarget:self.backgroundImageView];
    
    [picture processImage];
}

-(void)viewDidLoad{
    [super viewDidLoad];
}

@end
