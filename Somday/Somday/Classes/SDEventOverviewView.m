//
//  SDEventOverviewView.m
//  Somday
//
//  Created by Freddy So on 4/7/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDEventOverviewView.h"

@interface SDEventOverviewView ()

@property (nonatomic, strong) IBOutlet UILabel* dateLabel;
@property (nonatomic, strong) IBOutlet UILabel* addressLabel;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray* userButtons;
@property (nonatomic, strong) IBOutlet UIButton* chatButton;
@property (nonatomic, strong) IBOutlet UILabel* contentLabel;

@end

@implementation SDEventOverviewView

-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.dateLabel changeFont:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    [self.addressLabel changeFont:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    [self.contentLabel changeFont:SDFontFamily_Montserrat style:SDFontStyle_Regular];
    
    for( UIButton* button in self.userButtons ){
        [button changeFont:SDFontFamily_Montserrat style:SDFontStyle_Regular];
        
        button.clipsToBounds = TRUE;
        button.layer.masksToBounds = TRUE;
        button.layer.cornerRadius = CGRectGetWidth(button.bounds) / 2;
        button.layer.shadowColor = [UIColor colorWithWhite:0 alpha:0.3].CGColor;
        button.layer.shadowOffset = CGSizeMake(0.0, 2.0);
        button.layer.shadowOpacity = 0.7f;
        button.layer.shadowPath =  [UIBezierPath bezierPathWithRoundedRect:button.bounds cornerRadius:button.layer.cornerRadius].CGPath;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithWhite:1 alpha:0.4].CGColor;
    }
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    SDStory* story = self.story;
    if( !story ) return;
    
    if( self.addressLabel && story.address ){
        CGPoint center = self.addressLabel.center;
        self.addressLabel.text = story.address;
        [self.addressLabel sizeToFitWidth];
        center.x = self.addressLabel.center.x;
        self.addressLabel.center = center;
    }
    
    if( self.contentLabel && story.content ){
        CGPoint center = self.contentLabel.center;
        self.contentLabel.text = story.content;
        [self.contentLabel sizeToFitWidth];
        center.x = self.contentLabel.center.x;
        self.contentLabel.center = center;
    }
    
    if( self.dateLabel && story.startDate && story.endDate ){
        BOOL isSameDay = [story.startDate isSameDay:story.endDate];
        NSMutableString* string = nil;
        if( isSameDay ){
            NSDateInformation startInfo = story.startDate.dateInformation;
            NSDateInformation endInfo = story.endDate.dateInformation;
            
            NSDate* currentDate = [NSDate date];
            if( [story.startDate isSameDay:currentDate] ){
                string = [NSLocalizedString(@"DateFormat_Today", nil) mutableCopy];
            }else{
                NSDateInformation currentInfo = currentDate.dateInformation;
                if( currentInfo.day == startInfo.day - 1 ){
                    string = [NSLocalizedString(@"DateFormat_Tomorrow", nil) mutableCopy];
                }else if( currentInfo.day == startInfo.day + 1 ){
                    string = [NSLocalizedString(@"DateFormat_Yesterday", nil) mutableCopy];
                }
            }
            
            [string appendFormat:@"\n%d:%d%@ - %d:%d%@",
             startInfo.hour % 12, startInfo.minute, startInfo.hour / 12 >= 1 ? @"PM" : @"AM",
             endInfo.hour % 12, endInfo.minute, endInfo.hour / 12 >= 1 ? @"PM" : @"AM"];
        }
        CGPoint center = self.dateLabel.center;
        self.dateLabel.text = string;
        [self.dateLabel sizeToFitWidth];
        center.x = self.dateLabel.center.x;
        self.dateLabel.center = center;
    }
    if( story.members ){
        NSLog(@"members: %ld", story.members.count);
        for( UIButton* button in self.userButtons ){
            button.hidden = TRUE;
        }
        
        NSUInteger maxCount = story.members.count > self.userButtons.count ? self.userButtons.count - 1 : story.members.count;
        for( int i = 0; i < maxCount; i++ ){
            NSString* imageName = story.members[i];
            UIButton* button = self.userButtons[i];
            button.hidden = FALSE;
            [button setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        }
        if( maxCount == self.userButtons.count - 1 ){
            UIButton* button = self.userButtons.lastObject;
            button.hidden = FALSE;
            if( story.members.count > self.userButtons.count ){
                [button setTitle:[NSString stringWithFormat:@"+ %ld", story.members.count - (self.userButtons.count - 1)] forState:UIControlStateNormal];
            }else{
                button.hidden = TRUE;
            }
        }
    }
}

-(void)setStory:(SDStory*)story{
    _story = story;
    
    [self setNeedsLayout];
}

@end