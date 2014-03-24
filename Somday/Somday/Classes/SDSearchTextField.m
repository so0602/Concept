//
//  SDSearchTextField.m
//  Somday
//
//  Created by Freddy on 18/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDSearchTextField.h"

#import "UIView+Addition.h"
#import "UIColor+Extensions.h"

@interface SDSearchTextField ()

@property (nonatomic, strong) NSString* backgroundImageName;

-(void)initialize;

@property (nonatomic, strong) UIButton* rightButton;
@property (nonatomic, strong) UIImageView* rightImageView;

@end

@implementation SDSearchTextField

-(id)initWithCoder:(NSCoder *)aDecoder{
    if( self = [super initWithCoder:aDecoder] ){
        [self initialize];
        
        if( [self respondsToSelector:@selector(setAttributedPlaceholder:)] ){
            UIColor* color = [UIColor colorWithHexString:@"CCCCCC"];
            NSShadow* shadow = [[NSShadow alloc] init];
            shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            shadow.shadowOffset = CGSizeMake(0, 1);
            UIFont* font = [UIFont systemFontOfSize:12];
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
        shadow.shadowOffset = CGSizeMake(0, -1);
        UIFont* font = self.font;
        font = [font setFontFamily:SDFontFamily_Montserrat style:SDFontStyle_Regular];
        
        NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
        [attributes setObject:color forKey:NSForegroundColorAttributeName];
        [attributes setObject:shadow forKey:NSShadowAttributeName];
        [attributes setObject:font forKey:NSFontAttributeName];
        
        self.defaultTextAttributes = attributes;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame{
    if( self = [super initWithFrame:frame] ){
        [self initialize];
        
        if( [self respondsToSelector:@selector(setAttributedPlaceholder:)] ){
            UIColor* color = [UIColor colorWithHexString:@"CCCCCC"];
            NSShadow* shadow = [[NSShadow alloc] init];
            shadow.shadowColor = [UIColor colorWithWhite:0 alpha:0.3];
            shadow.shadowOffset = CGSizeMake(0, 1);
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
        shadow.shadowOffset = CGSizeMake(0, -1);
        UIFont* font = self.font;
        font = [font setFontFamily:SDFontFamily_Montserrat style:SDFontStyle_Regular];
        
        NSMutableDictionary* attributes = [NSMutableDictionary dictionary];
        [attributes setObject:color forKey:NSForegroundColorAttributeName];
        [attributes setObject:shadow forKey:NSShadowAttributeName];
        [attributes setObject:font forKey:NSFontAttributeName];
        
        self.defaultTextAttributes = attributes;
    }
    return self;
}

#pragma mark - UIView Additions

-(void)touchUpInside:(id)sender{
    self.text = nil;
}

#pragma mark - UIView Override

-(void)layoutSubviews{
    [super layoutSubviews];
    
    NSString* text = self.text;
    NSString* backgroundImageName = text.length ? @"textfield-1-typing" : @"textfield-1-default";
    if( ![self.backgroundImageName isEqualToString:backgroundImageName] ){
        self.backgroundImageName = backgroundImageName;
        UIImage* image = [UIImage imageNamed:backgroundImageName];
        image = [image stretchableImageWithLeftCapWidth:image.size.width / 2 topCapHeight:image.size.height / 2];
        self.background = image;
    }
    [self initialize];
}

#pragma mark - UITextField Override

-(CGRect)editingRectForBounds:(CGRect)bounds{
    bounds = CGRectInset(bounds, 10, 0);
    bounds.size.width -= CGRectGetWidth(self.rightView.bounds) - 10;
    return bounds;
}

-(CGRect)textRectForBounds:(CGRect)bounds{
    bounds = CGRectInset(bounds, 10, 0);
    bounds.size.width -= CGRectGetWidth(self.rightView.bounds) - 10;
    return bounds;
}

-(CGRect)placeholderRectForBounds:(CGRect)bounds{
    bounds = CGRectInset(bounds, 10, 0);
    bounds.size.width -= CGRectGetWidth(self.rightView.bounds) - 10;
    return bounds;
}

-(CGRect)rightViewRectForBounds:(CGRect)bounds{
    CGRect newBounds = self.rightView.bounds;
    newBounds.origin.y = CGRectGetMidY(bounds) - CGRectGetMidY(newBounds);
    newBounds.origin.x = CGRectGetWidth(bounds) - CGRectGetWidth(newBounds) - 10;
    bounds = newBounds;
    return bounds;
}

-(void)dealloc{
    UIButton* button = (id)self.rightView;
    if( button ){
        [button removeTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
}

#pragma mark - Private Functions

-(void)initialize{
    NSString* text = self.text;
    if( text.length && ![self.rightView isEqual:self.rightButton] ){
        self.rightView = self.rightButton;
        self.rightViewMode = UITextFieldViewModeAlways;
    }else if( !text.length && ![self.rightView isEqual:self.rightImageView] ){
        self.rightView = self.rightImageView;
        self.rightViewMode = UITextFieldViewModeAlways;
    }
}

-(UIButton*)rightButton{
    if( !_rightButton ){
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage* image = [UIImage imageNamed:@"icons-color-12px_cross"];
        _rightButton.frame = CGRectMake(0, 0, 28, 28);
        [_rightButton setImage:image forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(touchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _rightButton;
}

-(UIImageView*)rightImageView{
    if( !_rightImageView ){
        UIImage* image = [UIImage imageNamed:@"icons-shadow-16px_search"];
        _rightImageView = [[UIImageView alloc] initWithImage:image];
        _rightImageView.frame = CGRectMake(0, 0, 28, 28);
        _rightImageView.contentMode = UIViewContentModeCenter;
    }
    return _rightImageView;
}

@end
