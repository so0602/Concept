//
//  SDLoginViewController.m
//  Somday
//
//  Created by Freddy So on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDLoginViewController.h"

#import "SDNetworkUtils.h"
#import "SDUtils.h"

#import "SDAppDelegate.h"

#import "SDForgotPasswordViewController.h"
#import "SDSignUpViewController.h"

#import "SDTextField.h"

#import "KBPopupBubbleView.h"

#import "NSString+Addition.h"
#import "UIViewController+Addition.h"
#import "UIFont+Addition.h"

@interface SDLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* subtitleLabel;
@property (nonatomic, strong) IBOutlet SDTextField* usernameTextField;
@property (nonatomic, strong) IBOutlet SDTextField* passwordTextField;
@property (nonatomic, strong) IBOutlet UIButton* loginButton;
@property (nonatomic, strong) IBOutlet UIButton* forgotButton;
@property (nonatomic, strong) IBOutlet UIButton* signUpButton;

@property (nonatomic, strong) UITextField* targetTextField;
@property (nonatomic, strong) KBPopupBubbleView* bubbleView;

@property (nonatomic, strong, readonly) NSString* errorMessage;
@property (nonatomic, strong, readonly) NSString* emailErrorMessage;

-(void)checkEmail;
-(void)checkPassword;

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
}

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.loginButton isEqual:sender] ){
        [self.usernameTextField resignFirstResponder];
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

-(NSString*)emailErrorMessage{
    NSMutableArray* strings = [NSMutableArray array];
    if( !self.usernameTextField.text.isEmailFormat ){
        NSString* string = NSLocalizedString(@"ErrorMessage_EmailFormat", nil);
        [strings addObject:string];
    }
    
    if( strings.count ){
        return [strings componentsJoinedByString:@"\n"];
    }
    return nil;
}

-(KBPopupBubbleView*)bubbleView{
    if( !_bubbleView ){
        CGRect frame = self.usernameTextField.frame;
        frame.origin.y -= 50;
        frame.size.height = 50;
        frame = [self.usernameTextField.superview convertRect:frame toView:self.view];
        _bubbleView = [[KBPopupBubbleView alloc] initWithFrame:frame];
        _bubbleView.position = kKBPopupPointerPositionLeft;
        _bubbleView.side = kKBPopupPointerSideBottom;
        _bubbleView.cornerRadius = 8;
        _bubbleView.useBorders = FALSE;
        _bubbleView.drawableColor = [UIColor whiteColor];
        _bubbleView.label.font = [UIFont josefinSansSemiBoldFontOfSize:14];
    }
    return _bubbleView;
}

-(void)checkEmail{
    if( self.usernameTextField.text.isEmailFormat ){
        self.usernameTextField.state = SDTextFieldStateCorrect;
        [self.bubbleView hide:TRUE];
    }else{
        self.usernameTextField.state = SDTextFieldStateError;
        
        self.bubbleView.label.text = self.emailErrorMessage;
        if( !self.bubbleView.superview ){
            [self.bubbleView showInView:self.view animated:TRUE];
        }
    }
}

-(void)checkPassword{
    self.passwordTextField.state = self.passwordTextField.text.isPasswordFormat ? SDTextFieldStateCorrect : SDTextFieldStateError;
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if( ![self.targetTextField isEqual:textField] ){
        if( [self.targetTextField isEqual:self.usernameTextField] && [textField isEqual:self.passwordTextField] ){
            [self checkEmail];
            self.targetTextField = textField;
        }else if( [self.targetTextField isEqual:self.passwordTextField] && [textField isEqual:self.usernameTextField] ){
            [self checkPassword];
            self.targetTextField = nil;
        }
        
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if( [textField isEqual:self.usernameTextField] ){
        [self.passwordTextField becomeFirstResponder];
        [self checkEmail];
        self.targetTextField = textField;
    }else if( [textField isEqual:self.passwordTextField] ){
        [self checkPassword];
        [self touchUpInside:self.loginButton];
        self.targetTextField = nil;
    }
    return TRUE;
}

@end
