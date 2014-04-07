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
#import "SDErrorBubbleView.h"

#import "GPUImage.h"

#import "FTAnimation+UIView.h"

@interface SDLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet GPUImageView* backgroundImageView;
@property (nonatomic, strong) GPUImageiOSBlurFilter* blurFilter;
@property (nonatomic, strong) GPUImagePicture* backgroundPicture;

@property (nonatomic, strong) IBOutlet UIImageView* textFieldBackgroundImageView;
@property (nonatomic, strong) IBOutlet SDTextField* usernameTextField;
@property (nonatomic, strong) IBOutlet SDTextField* passwordTextField;
@property (nonatomic, strong) IBOutlet UIButton* loginButton;
@property (nonatomic, strong) IBOutlet UIButton* forgotButton;
@property (nonatomic, strong) IBOutlet UIButton* loginWithFacebookButton;
@property (nonatomic, strong) IBOutlet UIButton* signUpButton;

@property (nonatomic, strong) SDErrorBubbleView* bubbleView;

@property (nonatomic, strong, readonly) NSString* errorMessage;
@property (nonatomic, strong, readonly) NSString* emailErrorMessage;
@property (nonatomic, strong) NSString* bubbleMessage;

@property (nonatomic, strong) NSString* signedUsername;
@property (nonatomic, strong) NSString* signedPassword;

@end

@implementation SDLoginViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.loginWithFacebookButton changeFont:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    [self.signUpButton changeFont:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    
    UIImage* image = self.textFieldBackgroundImageView.image;
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    self.textFieldBackgroundImageView.image = image;
    
    image = [self.loginButton backgroundImageForState:UIControlStateNormal];
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    [self.loginButton setBackgroundImage:image forState:UIControlStateNormal];
    
    self.backgroundImage = [UIImage imageNamed:@"Debug_Story_1"];
    
    self.backgroundImageView.clipsToBounds = TRUE;
    self.backgroundImageView.layer.contentsGravity = kCAGravityTop;
    self.backgroundImageView.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
    
    if( !self.blurFilter ){
        self.blurFilter = [[GPUImageiOSBlurFilter alloc] init];
        self.blurFilter.blurRadiusInPixels = 1.0f;
    }
    
    if( !self.backgroundPicture ){
        self.backgroundPicture = [[GPUImagePicture alloc] initWithImage:self.backgroundImage];
        [self.backgroundPicture addTarget:self.blurFilter];
        [self.blurFilter addTarget:self.backgroundImageView];
    }
    
    [self.backgroundPicture processImage];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.usernameTextField.text = self.signedUsername;
    self.passwordTextField.text = self.signedPassword;
    self.usernameTextField.state = SDTextFieldStateNormal;
    self.passwordTextField.state = SDTextFieldStateNormal;
}

#pragma mark - SDViewController Override

-(void)dismissKeyboard{
    [super dismissKeyboard];
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.loginButton isEqual:sender] ){
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        
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
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:response.failMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }];
        }
    }else if( [self.forgotButton isEqual:sender] ){
        SDForgotPasswordViewController* viewController = [SDForgotPasswordViewController viewControllerFromStoryboardWithIdentifier:@"ForgotPassword"];
        viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        viewController.backgroundImage = self.blurFilter.imageFromCurrentlyProcessedOutput;
        [self presentViewController:viewController animated:TRUE completion:^{
            
        }];
    }else if( [self.signUpButton isEqual:sender] ){
        SDSignUpViewController* viewController = [SDSignUpViewController viewControllerFromStoryboardWithIdentifier:@"SignUp"];
        viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
        viewController.backgroundImage = self.blurFilter.imageFromCurrentlyProcessedOutput;
        [self presentViewController:viewController animated:TRUE completion:^{
            
        }];
    }
}

#pragma mark - Private Functions

-(SDErrorBubbleView*)bubbleView{
    if( !_bubbleView ){
        _bubbleView = [SDErrorBubbleView bubbleView];
        
        CGRect frame = self.usernameTextField.frame;
        frame.origin.y -= _bubbleView.height + 12;
        frame = [self.usernameTextField.superview convertRect:frame toView:self.view];
        
        _bubbleView.x = frame.origin.x;
        _bubbleView.y = frame.origin.y;
    }
    return _bubbleView;
}

-(NSString*)errorMessage{
    NSMutableArray* strings = [NSMutableArray array];
    if( !self.usernameTextField.text.length && !self.passwordTextField.text.length ){
        NSString* string = NSLocalizedString(@"ErrorMessage_FillInfo", nil);
        [strings addObject:string];
    }else{
        if( !self.usernameTextField.text.isEmailFormat ){
            NSString* string = NSLocalizedString(@"ErrorMessage_EmailFormat", nil);
            [strings addObject:string];
        }
//        if( !self.passwordTextField.text.isPasswordFormat ){
//            NSString* string = NSLocalizedString(@"ErrorMessage_PasswordFormat", nil);
//            [strings addObject:string];
//        }
        if( (self.usernameTextField.text.length && !self.passwordTextField.text.length) ||
           (!self.usernameTextField.text.length && self.passwordTextField.text.length) ){
            NSString* string = NSLocalizedString(@"ErrorMessage_NotMatch", nil);
            [strings addObject:string];
        }
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

-(void)setBubbleMessage:(NSString *)bubbleMessage{
    _bubbleMessage = bubbleMessage;
    self.bubbleView.message = bubbleMessage;
    if( bubbleMessage.length ){
        if( !self.bubbleView.superview ){
            [self.view addSubview:self.bubbleView];
            [self.bubbleView popIn:0.3 delegate:nil];
        }
    }else{
        [self.bubbleView popOut:0.3 delegate:self.bubbleView startSelector:nil stopSelector:@selector(removeFromSuperview)];
    }
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if( [textField isKindOfClass:[SDTextField class]] ){
        ((SDTextField*)textField).state = SDTextFieldStateNormal;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if( [textField isKindOfClass:[SDTextField class]] ){
        if( [textField isEqual:self.usernameTextField] ){
            BOOL success = [(SDTextField*)textField checkFormat];
            NSString* message = success ? nil : (textField.text.length ? self.emailErrorMessage : nil);
            self.bubbleMessage = message;
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if( [textField isKindOfClass:[SDTextField class]] ){
        if( [textField isEqual:self.usernameTextField] ){
            BOOL success = [(SDTextField*)textField checkFormat];
            [self.passwordTextField becomeFirstResponder];
            NSString* message = success ? nil : (textField.text.length ? self.emailErrorMessage : nil);
            self.bubbleMessage = message;
        }else if( [textField isEqual:self.passwordTextField] ){
            [self touchUpInside:self.loginButton];
        }
    }
    return TRUE;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    string = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if( !string.length && [textField isKindOfClass:[SDTextField class]] ){
        ((SDTextField*)textField).state = SDTextFieldStateNormal;
        self.bubbleMessage = nil;
    }
    return TRUE;
}

@end
