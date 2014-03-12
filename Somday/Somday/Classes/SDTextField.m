//
//  SDTextField.m
//  Somday
//
//  Created by Freddy on 12/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDTextField.h"

#import "UITextField+Addition.h"

@interface SDTextField ()

-(void)initialize;

@property (nonatomic, strong) UIImageView* rightImageView;

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
            break;
        case SDTextFieldStateError:
        {
            UIImageView* rightImageView = self.rightImageView;
            rightImageView.image = [UIImage imageNamed:@"icons-shadow-16px_warning"];
            if( !CGSizeEqualToSize(rightImageView.frame.size, rightImageView.image.size) ){
                [rightImageView sizeToFit];
            }
        }
            break;
        case SDTextFieldStateCorrect:
        {
            UIImageView* rightImageView = self.rightImageView;
            rightImageView.image = [UIImage imageNamed:@"icons-shadow-16px_tick"];
            if( !CGSizeEqualToSize(rightImageView.frame.size, rightImageView.image.size) ){
                [rightImageView sizeToFit];
            }
        }
            break;
    }
}

#pragma mark - Private Functions

-(void)initialize{
}

-(UIImageView*)rightImageView{
    if( !self.rightView || [self.rightView isKindOfClass:[UIImageView class]] ){
        if( !_rightImageView ){
            _rightImageView = [[UIImageView alloc] initWithImage:nil];
            self.rightView = _rightImageView;
            self.rightViewMode = UITextFieldViewModeAlways;
        }
    }else{
        _rightImageView = (id)self.rightView;
    }
    
    return _rightImageView;
}

@end
