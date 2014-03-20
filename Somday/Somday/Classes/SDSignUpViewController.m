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

#import "KBPopupBubbleView.h"

#import "UIViewController+Addition.h"
#import "UIFont+Addition.h"
#import "NSString+Addition.h"

@interface SDSignUpViewController ()<UIAlertViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIImageView* backgroundImageView;

@property (nonatomic, strong) IBOutlet UIButton* backButton;
@property (nonatomic, strong) IBOutlet UIButton* signUpButton;

@property (nonatomic, strong) IBOutlet UIImageView* textFieldBackgroundImageView;
@property (nonatomic, strong) IBOutlet SDTextField* usernameTextField;
@property (nonatomic, strong) IBOutlet SDTextField* passwordTextField;
@property (nonatomic, strong) IBOutlet SDTextField* confirmPasswordTextField;

@property (nonatomic, strong) KBPopupBubbleView* bubbleView;

@property (nonatomic, strong, readonly) NSString* errorMessage;
@property (nonatomic, strong, readonly) NSString* emailErrorMessage;
@property (nonatomic, strong) NSString* bubbleMessage;

-(void)checkEmail;

@end

@implementation SDSignUpViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"as your login";
    label.font = [UIFont josefinSansFontOfSize:14];
    label.textColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    [label sizeToFit];
    self.usernameTextField.rightView = label;
    self.usernameTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
    
    label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"at least 8 characters";
    label.font = [UIFont josefinSansFontOfSize:14];
    label.textColor = [UIColor colorWithWhite:0.5 alpha:0.8];
    [label sizeToFit];
    self.passwordTextField.rightView = label;
    self.passwordTextField.rightViewMode = UITextFieldViewModeUnlessEditing;
    
    UIImage* image = self.textFieldBackgroundImageView.image;
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    self.textFieldBackgroundImageView.image = image;
    
    image = [self.signUpButton backgroundImageForState:UIControlStateNormal];
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    [self.signUpButton setBackgroundImage:image forState:UIControlStateNormal];
    
    UIImage* flippedImage = [UIImage imageWithCGImage:self.backgroundImage.CGImage scale:self.backgroundImage.scale orientation: UIImageOrientationUpMirrored];
    self.backgroundImageView.image = flippedImage;
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
        _bubbleView.draggable = FALSE;
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
        self.bubbleView.label.text = response.failMessage;
        if( !self.bubbleView.superview ){
            [self.bubbleView showInView:self.view animated:TRUE];
        }
    }];
}

-(void)setBubbleMessage:(NSString *)bubbleMessage{
    _bubbleMessage = bubbleMessage;
    self.bubbleView.label.text = bubbleMessage;
    if( bubbleMessage.length ){
        if( !self.bubbleView.superview ){
            [self.bubbleView showInView:self.view animated:TRUE];
        }
    }else{
        [self.bubbleView hide:TRUE];
    }
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self dismissViewControllerAnimated:TRUE completion:^{
        
    }];
}

#pragma mark - UITextFieldDelegate

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
            [self touchUpInside:self.signUpButton];
        }
    }
    return TRUE;
}

@end
