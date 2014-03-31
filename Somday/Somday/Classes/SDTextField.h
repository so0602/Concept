//
//  SDTextField.h
//  Somday
//
//  Created by Freddy on 12/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SDTextFieldState) {
    SDTextFieldStateNormal,
    SDTextFieldStateError,
    SDTextFieldStateCorrect,
    SDTextFieldStateLoading,
};

@interface SDTextField : UITextField

@property (nonatomic, assign) SDTextFieldState state;

@property (nonatomic, strong) UIView* normalRightView;

-(BOOL)checkFormat;

@end
