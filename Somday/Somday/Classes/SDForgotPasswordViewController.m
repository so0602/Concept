//
//  SDForgotPasswordViewController.m
//  Somday
//
//  Created by Freddy on 11/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDForgotPasswordViewController.h"

#import "SDTextField.h"
#import "SDErrorBubbleView.h"

#import "GPUImage.h"

#import "UIImageView+LBBlurredImage.h"
#import "FTAnimation+UIView.h"

@interface SDForgotPasswordViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UIImageView* backgroundImageView;
@property (nonatomic, strong) GPUImageiOSBlurFilter* blurFilter;
@property (nonatomic, strong) GPUImagePicture* backgroundPicture;

@property (nonatomic, strong) IBOutlet UIButton* backButton;
@property (nonatomic, strong) IBOutlet UIButton* submitButton;

@property (nonatomic, strong) IBOutlet UILabel* mainTitleLabel;

@property (nonatomic, strong) IBOutlet UILabel* descriptionLabel;

@property (nonatomic, strong) IBOutlet UIImageView* textFieldBackgroundImageView;
@property (nonatomic, strong) IBOutlet SDTextField* usernameTextField;

@property (nonatomic, strong) SDErrorBubbleView* bubbleView;

@property (nonatomic, strong, readonly) NSString* errorMessage;
@property (nonatomic, strong) NSString* bubbleMessage;

@end

@implementation SDForgotPasswordViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    [self.backButton changeFont:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    
    [self.mainTitleLabel changeFont:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    
    [self.descriptionLabel changeFont:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    
    UIImage* image = self.textFieldBackgroundImageView.image;
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    self.textFieldBackgroundImageView.image = image;
    
    image = [self.submitButton backgroundImageForState:UIControlStateNormal];
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    [self.submitButton setBackgroundImage:image forState:UIControlStateNormal];
    
    UIImage* flippedImage = [UIImage imageWithCGImage:self.backgroundImage.CGImage scale:self.backgroundImage.scale orientation: UIImageOrientationUpMirrored];
    self.backgroundImageView.image = flippedImage;
}

#pragma mark - SDViewController Override

-(void)dismissKeyboard{
    [super dismissKeyboard];
    
    [self.usernameTextField resignFirstResponder];
}

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.submitButton isEqual:sender] ){
        
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
        BOOL success = [(SDTextField*)textField checkFormat];
        if( [textField isEqual:self.usernameTextField] ){
            if( success ){
                self.bubbleMessage = nil;
                [self touchUpInside:self.submitButton];
            }else{
                self.bubbleMessage = self.emailErrorMessage;
            }
        }
    }
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if( [textField isKindOfClass:[SDTextField class]] ){
        BOOL success = [(SDTextField*)textField checkFormat];
        if( [textField isEqual:self.usernameTextField] ){
            if( success ){
                self.bubbleMessage = nil;
                [self touchUpInside:self.submitButton];
            }else{
                self.bubbleMessage = self.emailErrorMessage;
            }
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
