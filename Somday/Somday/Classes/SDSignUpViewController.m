//
//  SDSignUpViewController.m
//  Somday
//
//  Created by Freddy on 11/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDSignUpViewController.h"

#import "SDNetworkUtils.h"
#import "SDTextField.h"

#import "SDErrorBubbleView.h"

#import "UIViewController+Addition.h"
#import "UIFont+Addition.h"
#import "UITextField+Addition.h"
#import "UIColor+Extensions.h"
#import "NSString+Addition.h"

#import "FTAnimation+UIView.h"

@interface SDSignUpViewController ()<UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIImageView* backgroundImageView;

@property (nonatomic, strong) IBOutlet UIButton* backButton;
@property (nonatomic, strong) IBOutlet UIButton* signUpButton;

@property (nonatomic, strong) IBOutlet UIImageView* textFieldBackgroundImageView;
@property (nonatomic, strong) IBOutlet SDTextField* usernameTextField;
@property (nonatomic, strong) IBOutlet SDTextField* passwordTextField;
@property (nonatomic, strong) IBOutlet SDTextField* confirmPasswordTextField;

@property (nonatomic, strong) SDErrorBubbleView* bubbleView;

@property (nonatomic, strong, readonly) NSString* errorMessage;
@property (nonatomic, strong, readonly) NSString* emailErrorMessage;
@property (nonatomic, strong) NSString* bubbleMessage;

-(void)checkEmail;

@end

@implementation SDSignUpViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.backButton changeFont:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"as your login";
    UIFont* font = [UIFont systemFontOfSize:12];
    font = [font setFontFamily:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    label.font = font;
    label.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
    label.textColor = [UIColor colorWithHexString:@"CCCCCC"];
    [label sizeToFit];
    self.usernameTextField.rightView = label;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"at least 8 characters";
    label.font = font;
    label.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
    label.textColor = [UIColor colorWithHexString:@"CCCCCC"];
    [label sizeToFit];
    self.passwordTextField.rightView = label;
    
    UIImage* image = self.textFieldBackgroundImageView.image;
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    self.textFieldBackgroundImageView.image = image;
    
    image = [self.signUpButton backgroundImageForState:UIControlStateNormal];
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    [self.signUpButton setBackgroundImage:image forState:UIControlStateNormal];
    
    UIImage* flippedImage = [UIImage imageWithCGImage:self.backgroundImage.CGImage scale:self.backgroundImage.scale orientation: UIImageOrientationUpMirrored];
    self.backgroundImageView.image = flippedImage;
    
    self.confirmPasswordTextField.rightImage = nil;
}

#pragma mark - SDViewController Override

-(void)dismissKeyboard{
    [super dismissKeyboard];
    
    [self.usernameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    [self.confirmPasswordTextField resignFirstResponder];
}

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.signUpButton isEqual:sender] ){
        [self.usernameTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        [self.confirmPasswordTextField resignFirstResponder];
        
        NSString* errorMessage = self.errorMessage;
        if( errorMessage ){
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
        }else{
            [SDNetworkUtils createUserWithUsername:self.usernameTextField.text password:self.passwordTextField.text completion:^(SDCreateUser *response) {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:response.failMessage delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            } failed:^(SDCreateUser *response) {
                UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:nil message:response.failMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alertView show];
            }];
        }
    }else if( [self.backButton isEqual:sender] ){
        [self dismissViewControllerAnimated:TRUE completion:^{
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
    if( !self.usernameTextField.text.isEmailFormat ){
        NSString* string = NSLocalizedString(@"ErrorMessage_EmailFormat", nil);
        [strings addObject:string];
    }
    if( !self.passwordTextField.text.isPasswordFormat ){
        NSString* string = NSLocalizedString(@"ErrorMessage_PasswordFormat", nil);
        [strings addObject:string];
    }
    if( ![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text] ){
        NSString* string = NSLocalizedString(@"ErrorMessage_ConfirmPasswordFormat", nil);
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

-(void)checkEmail{
    [SDNetworkUtils checkUserExistWithUsername:self.usernameTextField.text completion:^(SDCheckUserExist *response) {
        self.usernameTextField.state = SDTextFieldStateCorrect;
    } failed:^(SDCheckUserExist *response) {
        self.usernameTextField.state = SDTextFieldStateError;
        self.bubbleView.message = response.failMessage;
        if( !self.bubbleView.superview ){
            [self.view addSubview:self.bubbleView];
            [self.bubbleView popIn:0.3 delegate:nil];
        }
    }];
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

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:TRUE completion:^{
        
    }];
}

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if( [textField isKindOfClass:[SDTextField class]] ){
        ((SDTextField*)textField).state = SDTextFieldStateNormal;
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if( [textField isKindOfClass:[SDTextField class]] ){
        BOOL success = [(SDTextField*)textField checkFormat];
        if( [textField isEqual:self.usernameTextField] ){
            if( success ){
                self.bubbleMessage = nil;
                [self checkEmail];
            }else{
                self.bubbleMessage = self.errorMessage;
            }
        }else if( [textField isEqual:self.confirmPasswordTextField] ){
            ((SDTextField*)textField).state = [textField.text isEqualToString:self.passwordTextField.text] ? ((SDTextField*)textField).state : SDTextFieldStateError;
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if( [textField isKindOfClass:[SDTextField class]] ){
        BOOL success = [(SDTextField*)textField checkFormat];
        
        if( [textField isEqual:self.usernameTextField] ){
            [self.passwordTextField becomeFirstResponder];
            if( success ){
                self.bubbleMessage = nil;
                [self checkEmail];
            }else{
                self.bubbleMessage = self.errorMessage;
            }
        }else if( [textField isEqual:self.passwordTextField] ){
            [self.confirmPasswordTextField becomeFirstResponder];
        }else if( [textField isEqual:self.confirmPasswordTextField] ){
            ((SDTextField*)textField).state = [textField.text isEqualToString:self.passwordTextField.text] ? ((SDTextField*)textField).state : SDTextFieldStateError;
            [self touchUpInside:self.signUpButton];
        }
    }
    return TRUE;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    string = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if( !string.length && [textField isKindOfClass:[SDTextField class]] ){
        ((SDTextField*)textField).state = SDTextFieldStateNormal;
    }
    return TRUE;
}

@end
