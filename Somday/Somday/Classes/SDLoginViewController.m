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
#import "SDSignUpViewController.h"

#import "SDTextField.h"

#import "NSString+Addition.h"
#import "UIViewController+Addition.h"

@interface SDLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* subtitleLabel;
@property (nonatomic, strong) IBOutlet SDTextField* usernameTextField;
@property (nonatomic, strong) IBOutlet SDTextField* passwordTextField;
@property (nonatomic, strong) IBOutlet UIButton* loginButton;
@property (nonatomic, strong) IBOutlet UIButton* forgotButton;
@property (nonatomic, strong) IBOutlet UIButton* signUpButton;

@property (nonatomic, strong) UITextField* targetTextField;

@property (nonatomic, strong, readonly) NSString* errorMessage;

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
    
//    self.usernameTextField.text = @"test9@test.com";
//    self.passwordTextField.text = @"test";
    
    if( [SDUtils username] ){
        [self autoLogin];
    }
}

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.loginButton isEqual:sender] ){
        [self.passwordTextField resignFirstResponder];
        self.targetTextField = nil;
        
        NSString* errorMessage = self.errorMessage;
        if( errorMessage ){
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }else{
            [SDNetworkUtils loginWithUsername:self.usernameTextField.text password:self.passwordTextField.text completion:^(SDLogin *response) {
                SDLog(@"%@", response.status.message);
                
                [SDUtils setUsername:self.usernameTextField.text password:self.passwordTextField.text];
                [self dismissViewControllerAnimated:TRUE completion:^{
                    
                }];
            } failed:^(SDLogin *response) {
                SDLog(@"%@, %@", response.status.message, response.request.responseString);
            }];
        }
    }else if( [self.forgotButton isEqual:sender] ){
        SDForgotPasswordViewController* viewController = [SDForgotPasswordViewController viewControllerFromStoryboardWithIdentifier:@"ForgotPassword"];
        viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:viewController animated:TRUE completion:^{
            
        }];
    }else if( [self.signUpButton isEqual:sender] ){
        SDSignUpViewController* viewController = [SDSignUpViewController viewControllerFromStoryboardWithIdentifier:@"SignUp"];
        viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        [self presentViewController:viewController animated:TRUE completion:^{
            
        }];
    }
}

#pragma mark - Private Functions

-(NSString*)errorMessage{
    NSMutableArray* strings = [NSMutableArray array];
    if( !self.usernameTextField.text.isEmailFormat ){
        NSString* string = NSLocalizedString(@"ErrorMessage_EmailFormat", nil);
        [strings addObject:string];
    }
    if( !self.passwordTextField.text.isPasswordFormat ){
        NSString* string = NSLocalizedString(@"ErrorMessage_PasswordFormat", nil);
        [strings addObject:string];
    }
    
    if( strings.count ){
        return [strings componentsJoinedByString:@"\n"];
    }
    return nil;
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if( ![self.targetTextField isEqual:textField] ){
        if( [self.targetTextField isEqual:self.usernameTextField] && [textField isEqual:self.passwordTextField] ){
            self.usernameTextField.state = self.usernameTextField.text.isEmailFormat ? SDTextFieldStateCorrect : SDTextFieldStateError;
        }else if( [self.targetTextField isEqual:self.passwordTextField] && [textField isEqual:self.usernameTextField] ){
            self.passwordTextField.state = self.passwordTextField.text.isPasswordFormat ? SDTextFieldStateCorrect : SDTextFieldStateError;
        }
        self.targetTextField = textField;
    }
    
    return TRUE;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}
//-(BOOL)textFieldShouldEndEditing:(UITextField *)textField;          // return YES to allow editing to stop and to resign first responder status. NO to disallow the editing session to end
//-(void)textFieldDidEndEditing:(UITextField *)textField;             // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
//
//-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;   // return NO to not change text
//
//-(BOOL)textFieldShouldClear:(UITextField *)textField;               // called when clear button pressed. return NO to ignore (no notifications)

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if( [textField isEqual:self.usernameTextField] ){
        [self.passwordTextField becomeFirstResponder];
        self.usernameTextField.state = self.usernameTextField.text.isEmailFormat ? SDTextFieldStateCorrect : SDTextFieldStateError;
    }else if( [textField isEqual:self.passwordTextField] ){
        self.passwordTextField.state = self.passwordTextField.text.isPasswordFormat ? SDTextFieldStateCorrect : SDTextFieldStateError;
        [self touchUpInside:self.loginButton];
        [self.passwordTextField resignFirstResponder];
        self.targetTextField = nil;
    }
    return TRUE;
}

@end
