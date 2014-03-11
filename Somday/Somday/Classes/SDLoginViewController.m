//
//  SDLoginViewController.m
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDLoginViewController.h"

#import "SDNetworkUtils.h"

#import "SDAppDelegate.h"

#import "SDForgotPasswordViewController.h"

#import "UIViewController+Addition.h"

@interface SDLoginViewController ()

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* subtitleLabel;
@property (nonatomic, strong) IBOutlet UITextField* usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField* passwordTextField;
@property (nonatomic, strong) IBOutlet UIButton* loginButton;
@property (nonatomic, strong) IBOutlet UIButton* forgotButton;

@end

@implementation SDLoginViewController

-(void)autoLogin{
    [self touchUpInside:self.loginButton];
}

#pragma mark - View Lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont josefinSansFontOfSize:self.titleLabel.font.pointSize];
    self.subtitleLabel.font = [UIFont josefinSansSemiBoldFontOfSize:self.subtitleLabel.font.pointSize];
    
    self.usernameTextField.text = @"test9@test.com";
    self.passwordTextField.text = @"test";
    
    if( [SDUtils username] ){
        [self autoLogin];
    }
}

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.loginButton isEqual:sender] ){
        [SDNetworkUtils loginWithUsername:self.usernameTextField.text password:self.passwordTextField.text completion:^(SDLogin *response) {
            SDLog(@"%@", response.status.message);
            
            [SDUtils setUsername:self.usernameTextField.text password:self.passwordTextField.text];
            
            SDAppDelegate* delegate = [UIApplication sharedApplication].delegate;
            if( [delegate.loginViewController isEqual:self] ){
                [self presentViewController:delegate.mainViewController animated:TRUE completion:^{
                    
                }];
            }else{
                [self dismissViewControllerAnimated:TRUE completion:^{
                    
                }];
            }
        } failed:^(SDLogin *response) {
            SDLog(@"%@, %@", response.status.message, response.request.responseString);
        }];
    }else if( [self.forgotButton isEqual:sender] ){
        SDForgotPasswordViewController* viewController = [SDForgotPasswordViewController viewControllerFromStoryboardWithIdentifier:@"ForgotPassword"];
        viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:viewController animated:TRUE completion:^{
            
        }];
    }
}

@end
