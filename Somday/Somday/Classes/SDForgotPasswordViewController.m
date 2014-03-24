//
//  SDForgotPasswordViewController.m
//  Somday
//
//  Created by Freddy on 11/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDForgotPasswordViewController.h"

#import "SDTextField.h"

#import "GPUImage.h"

#import "KBPopupBubbleView.h"

#import "UIViewController+Addition.h"
#import "UIFont+Addition.h"
#import "NSString+Addition.h"
#import "UIImageView+LBBlurredImage.h"

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

@property (nonatomic, strong) KBPopupBubbleView* bubbleView;

@property (nonatomic, strong, readonly) NSString* errorMessage;
@property (nonatomic, strong) NSString* bubbleMessage;

@end

@implementation SDForgotPasswordViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIFont* font = self.backButton.titleLabel.font;
    font = [font setFontFamily:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    self.backButton.titleLabel.font = font;
    
    font = self.mainTitleLabel.font;
    font = [font setFontFamily:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    self.mainTitleLabel.font = font;
    
    font = self.descriptionLabel.font;
    font = [font setFontFamily:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    self.descriptionLabel.font = font;
    
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
        
        UIFont* font = [UIFont systemFontOfSize:14];
        font = [font setFontFamily:SDFontFamily_JosefinSans style:14];
        _bubbleView.label.font = font;
        _bubbleView.draggable = FALSE;
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
    self.bubbleView.label.text = bubbleMessage;
    if( bubbleMessage.length ){
        if( !self.bubbleView.superview ){
            [self.bubbleView showInView:self.view animated:TRUE];
        }
    }else{
        [self.bubbleView hide:TRUE];
    }
}

#pragma mark - UITextFieldDelegate

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

@end
