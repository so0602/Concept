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
        _dateformatter = [[NSDateFormatter alloc] init];
        [_dateformatter setLocale:[NSLocale currentLocale]];
        [_dateformatter setDateFormat:SDDateFormat_dd_MMMM_yyyy];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _dayLabel.font = [UIFont josefinSansSemiBoldFontOfSize:18];
    _dateLabel.font = [UIFont josefinSansFontOfSize:11];
    _dateLabel.text = [_dateformatter stringFromDate:[NSDate date]];
    
}

@end
