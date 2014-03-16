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

-(void)checkEmail;

@end

@implementation SDForgotPasswordViewController

#pragma mark - View Lifecycle

-(void)viewDidLoad{
    [super viewDidLoad];
    
    UIImage* image = self.textFieldBackgroundImageView.image;
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    self.textFieldBackgroundImageView.image = image;
    
    image = [self.submitButton backgroundImageForState:UIControlStateNormal];
    image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
    [self.submitButton setBackgroundImage:image forState:UIControlStateNormal];
    
    UIImage* flippedImage = [UIImage imageWithCGImage:self.backgroundImage.CGImage scale:self.backgroundImage.scale orientation: UIImageOrientationUpMirrored];
    self.backgroundImageView.image = flippedImage;
}

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.submitButton isEqual:sender] ){
        
    }else if( [self.backButton isEqual:sender] ){
        [self dismissViewControllerAnimated:TRUE completion:^{ 
        }];
    }
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
        _bubbleView.draggable = FALSE;
    }
    return _bubbleView;
}

-(void)checkEmail{
    if( self.usernameTextField.text.isEmailFormat ){
        self.usernameTextField.state = SDTextFieldStateCorrect;
        [self.bubbleView hide:TRUE];
        [self touchUpInside:self.submitButton];
    }else{
        self.usernameTextField.state = SDTextFieldStateError;
        
        self.bubbleView.label.text = self.emailErrorMessage;
        if( !self.bubbleView.superview ){
            [self.bubbleView showInView:self.view animated:TRUE];
        }
    }
}

#pragma mark - UITextFieldDelegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if( [textField isEqual:self.usernameTextField] ){
        [self checkEmail];
    }
    return TRUE;
}

@end
