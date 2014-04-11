//
//  SDTextGridView.m
//  Somday
//
//  Created by Freddy on 18/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDTextGridView.h"

@interface SDTextGridView ()

@property (nonatomic, strong) IBOutlet UILabel* contentLabel;

@end

@implementation SDTextGridView

+ (CGFloat)heightForCell{
    return 152;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    SDStory* story = self.story;
    if( !story ) return;
    
    if( self.contentLabel && story.content ){
        CGPoint center = self.contentLabel.center;
        self.contentLabel.text = story.content;
        [self.contentLabel sizeToFitWidth];
        center.x = self.contentLabel.center.x;
        self.contentLabel.center = center;
    }
}

@end
