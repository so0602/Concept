//
//  SDWebsiteGridView.m
//  Somday
//
//  Created by Freddy on 29/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDWebsiteGridView.h"

@interface SDWebsiteGridView ()

@property (nonatomic, strong) IBOutlet UILabel* websiteLinkLabel;
@property (nonatomic, strong) IBOutlet UIImageView* websiteImageView;

@end

@implementation SDWebsiteGridView

+(CGFloat)heightForCell{
    return 152;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.websiteLinkLabel changeFont:SDFontFamily_Montserrat style:SDFontStyle_Regular];
}

//-(void)layoutSubviews{
//    [super layoutSubviews];
//    
//    
//}

-(void)setStory:(SDStory *)story{
    [super setStory:story];
    
    self.websiteLinkLabel.text = self.story.websiteLink;
    self.websiteImageView.image = self.story.websiteImage;
}

@end
