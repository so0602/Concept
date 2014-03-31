//
//  UITextField+Addition.m
//  Somday
//
//  Created by Freddy on 12/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "UITextField+Addition.h"

#import <objc/runtime.h>

static const char* UITextField_RightImageKey = "&#_UITextField_RightImageKey_#&";

@implementation UITextField (Addition)

-(UIImage*)rightImage{
    return objc_getAssociatedObject(self, UITextField_RightImageKey);
}

-(void)setRightImage:(UIImage *)rightImage{
    objc_setAssociatedObject(self, UITextField_RightImageKey, rightImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UIImageView* rightImageView = (id)self.rightView;
    if( !rightImageView || ![rightImageView isKindOfClass:[UIImageView class]]){
        rightImageView = [[UIImageView alloc] initWithImage:rightImage];
        self.rightView = rightImageView;
        self.rightViewMode = UITextFieldViewModeUnlessEditing;
    }else{
        rightImageView.image = rightImage;
    }
}

@end
