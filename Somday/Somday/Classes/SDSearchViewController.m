//
//  SDSearchViewController.m
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDSearchViewController.h"

#import "GPUImage.h"

#import "UIViewController+Addition.h"

@interface SDSearchViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet GPUImageView* backgroundImageView;
@property (nonatomic, strong) GPUImageiOSBlurFilter* blurFilter;
@property (nonatomic, strong) GPUImagePicture* backgroundPicture;

@property (nonatomic, strong) IBOutlet UIButton* backButton;
@property (nonatomic, strong) IBOutlet UITextField* searchTextField;

@end

@implementation SDSearchViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
//    self.backgroundImageView.clipsToBounds = TRUE;
//    self.backgroundImageView.layer.contentsGravity = kCAGravityTop;
//    
//    if( !self.blurFilter ){
//        self.blurFilter = [[GPUImageiOSBlurFilter alloc] init];
//        self.blurFilter.blurRadiusInPixels = 1.0f;
//    }
//    
//    if( !self.backgroundPicture ){
//        self.backgroundPicture = [[GPUImagePicture alloc] initWithImage:self.backgroundImage];
//        [self.backgroundPicture addTarget:self.blurFilter];
//        [self.blurFilter addTarget:self.backgroundImageView];
//    }
//    
//    [self.backgroundPicture processImage];
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
//    UIImage* image = [UIImage imageNamed:@"textfield-1-default"];
//    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
//    self.searchTextField.background = image;
}

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.backButton isEqual:sender] ){
        if( self.delegate && [self.delegate respondsToSelector:@selector(backButtonDidClick:)] ){
            [self.delegate backButtonDidClick:self];
        }
    }
}

@end
