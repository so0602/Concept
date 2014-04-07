//
//  SDErrorBubbleView.m
//  Somday
//
//  Created by Freddy on 27/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDErrorBubbleView.h"

@interface SDErrorBubbleView ()

@property (nonatomic, strong) IBOutlet UIImageView* backgroundImageView;
@property (nonatomic, strong) IBOutlet UILabel* label;

@end

@implementation SDErrorBubbleView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    UIImage* image = self.backgroundImageView.image;
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 3 / 4 topCapHeight:image.size.height / 2];
    self.backgroundImageView.image = image;
    
    [self.label changeFont:SDFontFamily_Montserrat style:SDFontStyle_Regular];
}

+(SDErrorBubbleView*)bubbleView{
    SDErrorBubbleView* view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].lastObject;
    return view;
}

-(NSString*)message{
    return self.label.text;
}
-(void)setMessage:(NSString *)message{
    self.label.text = message;
}

@end
