//
//  SDHomeNavigationTitleView.m
//  Concept
//
//  Created by Tao, Steven on 3/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDHomeNavigationTitleView.h"

@interface SDHomeNavigationTitleView ()
@property (nonatomic) NSDateFormatter *dateformatter;
@end

@implementation SDHomeNavigationTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        _dayLabel.font = [UIFont josefinSansFontOfSize:20];
        _dateLabel.font = [UIFont josefinSansFontOfSize:13];
        _dateformatter = [[NSDateFormatter alloc] init];
        [_dateformatter setLocale:[NSLocale currentLocale]];
        [_dateformatter setDateFormat:SDDateFormat_dd_MMM_yyyy];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _dateLabel.text = [_dateformatter stringFromDate:[NSDate date]];
    
}

@end
