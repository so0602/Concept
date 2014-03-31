//
//  SDTextField.m
//  Somday
//
//  Created by Freddy on 12/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDTextField.h"

#import "UITextField+Addition.h"
#import "UIColor+Extensions.h"
#import "UIView+Addition.h"

@interface SDTextField ()

-(void)initialize;

@property (nonatomic, strong) UIImageView* rightImageView;

@property (nonatomic, strong) NSDictionary* standardTextAttributes;
@property (nonatomic, strong) NSDictionary* errorTextAttributes;

@end

@implementation SDTextField

@synthesize state = _state;

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if( self = [super initWithCoder:aDecoder] ){
        [self initialize];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    if( self = [super initWithFrame:frame] ){
        [self initialize];
    }
    return self;
}

-(void)setState:(SDTextFieldState)state{
    _state = state;
    
    switch( state ){
        case SDTextFieldStateNormal:
            if( self.rightImage ){
                self.rightImage = self.rightImage;
            }
            self.defaultTextAttributes = self.standardTextAttributes;
            break;
        case SDTextFieldStateError:
        {
            UIImageView* rightImageView = self.rightImageView;
            rightImageView.image = [UIImage imageNamed:@"icons-color-12px_warning"];
            if( !CGSizeEqualToSize(rightImageView.frame.size, rightImageView.image.size) ){
                [rightImageView sizeToFit];
            }
            self.defaultTextAttributes = self.errorTextAttributes;
        }
            break;
        case SDTextFieldStateCorrect:
        {
            UIImageView* rightImageView = self.rightImageView;
            rightImageView.image = [UIImage imageNamed:@"icons-color-12px_tick"];
            if( !CGSizeEqualToSize(rightImageView.frame.size, rightImageView.image.size) ){
                [rightImageView sizeToFit];
            }
            self.defaultTextAttributes = self.standardTextAttributes;
        }
            break;
        case SDTextFieldStateLoading:
        {
            UIActivityIndicatorView* view = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [view startAnimating];
            self.rightView = view;
            self.defaultTextAttributes = self.standardTextAttributes;
        }
    }
}

-(BOOL)checkFormat{
    // Override
    return TRUE;
}

#pragma mark - Private Functions

-(void)initialize{
    if( [self respondsToSelector:@selector(setAttributedPlaceholder:)] ){
        UIColor* color = [UIColor colorWithHexString:@"666666"];
        NSShadow* shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
        shadow.shadowOffset = CGSizeMake(0, -1);
        UIFont* font = self.font;
        font = [font setFontFamily:SDFontFamily_Montserrat style:SDFontStyle_Regular];
        
        NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
        [attributes setObject:color forKey:NSForegroundColorAttributeName];
        [attributes setObject:shadow forKey:NSShadowAttributeName];
        [attributes setObject:font forKey:NSFontAttributeName];
        
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:self.placeholder attributes:attributes];
    }
    
    UIColor* color = [UIColor colorWithHexString:@"333333"];
    NSShadow* shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor colorWithWhite:1 alpha:0.3];
    shadow.shadowOffset = CGSizeMake(0, 1);
    UIFont* font = self.font;
    font = [font setFontFamily:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    
    NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
    [attributes setObject:color forKey:NSForegroundColorAttributeName];
    [attributes setObject:shadow forKey:NSShadowAttributeName];
    [attributes setObject:font forKey:NSFontAttributeName];
    
    self.standardTextAttributes = attributes;
    
    color = [UIColor colorWithHexString:@"CC3333"];
    attributes = [NSMutableDictionary dictionary];
    [attributes setObject:color forKey:NSForegroundColorAttributeName];
    [attributes setObject:shadow forKey:NSShadowAttributeName];
    [attributes setObject:font forKey:NSFontAttributeName];
    
    self.errorTextAttributes = attributes;
    
    self.defaultTextAttributes = self.standardTextAttributes;
}

-(UIImageView*)rightImageView{
    if( !self.rightView || ![self.rightView isKindOfClass:[UIImageView class]] ){
        if( !_rightImageView ){
            _rightImageView = [[UIImageView alloc] initWithImage:nil];
            _rightImageView.contentMode = UIViewContentModeLeft;
        }
        self.rightView = _rightImageView;
        self.rightViewMode = UITextFieldViewModeUnlessEditing;
    }else{
        _rightImageView = (id)self.rightView;
    }
    
    return _rightImageView;
}

#pragma mark - UITextField Override

-(CGRect)editingRectForBounds:(CGRect)bounds{
    bounds = CGRectInset(bounds, 16, 0);
    bounds.size.width += 8;
//    bounds.size.width -= (self.text.length ? 0 : CGRectGetWidth(self.rightView.bounds)) - 8;
    return bounds;
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    bounds = CGRectInset(bounds, 16, 0);
    bounds.size.width -= CGRectGetWidth(self.rightView.bounds) + 8;
//    bounds.size.width -= (self.text.length ? 0 : CGRectGetWidth(self.rightView.bounds)) - 6;
    return bounds;
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    bounds = CGRectInset(bounds, 16, 0);
    bounds.size.width -= CGRectGetWidth(self.rightView.bounds) - 16;
//    bounds.size.width -= (self.text.length ? 0 : CGRectGetWidth(self.rightView.bounds)) - 6;
    return bounds;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect newBounds = self.rightView.bounds;
    newBounds.origin.y = CGRectGetMidY(bounds) - CGRectGetMidY(newBounds);
    newBounds.origin.x = CGRectGetWidth(bounds) - CGRectGetWidth(newBounds) - 16;
    bounds = newBounds;
    return bounds;
}

@end
