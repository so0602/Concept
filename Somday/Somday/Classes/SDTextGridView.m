//
//  SDTextGridView.m
//  Somday
//
//  Created by Freddy on 18/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDTextGridView.h"

@interface SDBaseGridView ()

-(void)initBackgroundImageView;

@end

@interface SDTextGridView ()

@property (nonatomic, strong) IBOutlet UIView* textBackgroudView;
@property (nonatomic, strong) IBOutlet UIImageView* arrowImageView;

@end

@implementation SDTextGridView

+ (CGFloat)heightForCell{
    return 152;
}

-(void)initBackgroundImageView{
    [super initBackgroundImageView];
    
    [self.backgroundImageView addSubview:self.textBackgroudView];
    [self.backgroundImageView addSubview:self.arrowImageView];
}

@end
