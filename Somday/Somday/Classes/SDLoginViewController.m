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

@interface SDLoginViewController ()

@property (nonatomic, strong) IBOutlet UITextField* usernameTextField;
@property (nonatomic, strong) IBOutlet UITextField* passwordTextField;
@property (nonatomic, strong) IBOutlet UIButton* loginButton;

@end

@implementation SDLoginViewController

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.loginButton isEqual:sender] ){
        [SDNetworkUtils loginWithUsername:self.usernameTextField.text password:self.passwordTextField.text completion:^(SDLogin *response) {
            SDLog(@"%@", response.status.message);
        } failed:^(SDLogin *response) {
            SDLog(@"%@, %@", response.status.message, response.request.responseString);
        }];
    }
}

@end
