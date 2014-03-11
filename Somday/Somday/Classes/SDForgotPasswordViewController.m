//
//  SDForgotPasswordViewController.m
//  Somday
//
//  Created by Freddy on 11/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDForgotPasswordViewController.h"

#import "UIViewController+Addition.h"

@interface SDForgotPasswordViewController ()

@property (nonatomic, strong) IBOutlet UIButton* backButton;
@property (nonatomic, strong) IBOutlet UIButton* submitButton;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* subtitleLabel;
@property (nonatomic, strong) IBOutlet UILabel* mainTitleLabel;

@property (nonatomic, strong) IBOutlet UILabel* descriptionLabel;

@property (nonatomic, strong) IBOutlet UITextField* usernameTextField;

@end

@implementation SDForgotPasswordViewController

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.submitButton isEqual:sender] ){
        
    }else if( [self.backButton isEqual:sender] ){
        [self dismissViewControllerAnimated:TRUE completion:^{ 
        }];
    }
}

@end
