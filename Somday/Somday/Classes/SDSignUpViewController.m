//
//  SDSignUpViewController.m
//  Somday
//
//  Created by Freddy on 11/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDSignUpViewController.h"

#import "SDNetworkUtils.h"

#import "UIViewController+Addition.h"

@interface SDSignUpViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) IBOutlet UIImageView* backgroundImageView;

@property (nonatomic, strong) IBOutlet UIButton* backButton;
@property (nonatomic, strong) IBOutlet UIButton* signUpButton;

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* subtitleLabel;

@property (nonatomic, strong) IBOutlet UITextField* usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField* passwordTextField;
@property (nonatomic, strong) IBOutlet UITextField* confirmPasswordTextField;

@end

@implementation SDSignUpViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont josefinSansFontOfSize:self.titleLabel.font.pointSize];
    self.subtitleLabel.font = [UIFont josefinSansSemiBoldFontOfSize:self.subtitleLabel.font.pointSize];
}

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.signUpButton isEqual:sender] ){
        [SDNetworkUtils createUserWithUsername:self.usernameTextField.text password:self.passwordTextField.text completion:^(SDCreateUser *response) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:response.failMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        } failed:^(SDCreateUser *response) {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:response.failMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }];
    }else if( [self.backButton isEqual:sender] ){
        [self dismissViewControllerAnimated:TRUE completion:^{
        }];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:TRUE completion:^{
        
    }];
}

@end
