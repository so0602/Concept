//
//  SDLoginViewController.m
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDLoginViewController.h"

#import "UIViewController+Addition.h"

#import "SDNetworkUtils.h"

#import "SDAppDelegate.h"

@interface SDLoginViewController ()

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* subtitleLabel;
@property (nonatomic, strong) IBOutlet UITextField* usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField* passwordTextField;
@property (nonatomic, strong) IBOutlet UIButton* loginButton;

@end

@implementation SDLoginViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont josefinSansFontOfSize:self.titleLabel.font.pointSize];
    self.subtitleLabel.font = [UIFont josefinSansSemiBoldFontOfSize:self.subtitleLabel.font.pointSize];
    
    self.usernameTextField.text = @"test9@test.com";
    self.passwordTextField.text = @"test";
}

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.loginButton isEqual:sender] ){
        [SDNetworkUtils loginWithUsername:self.usernameTextField.text password:self.passwordTextField.text completion:^(SDLogin *response) {
            SDLog(@"%@", response.status.message);
            
            [SDUtils setUsername:self.usernameTextField.text password:self.passwordTextField.text];
            
            SDAppDelegate* delegate = [UIApplication sharedApplication].delegate;
            if( [delegate.loginViewController isEqual:self] ){
                [self.navigationController pushViewController:delegate.mainViewController animated:TRUE];
            }else{
                [self dismissViewControllerAnimated:TRUE completion:^{
                    
                }];
            }
        } failed:^(SDLogin *response) {
            SDLog(@"%@, %@", response.status.message, response.request.responseString);
        }];
    }
}

@end
