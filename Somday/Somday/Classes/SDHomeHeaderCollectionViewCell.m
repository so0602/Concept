//
//  SDHomeHeaderCollectionViewCell.m
//  Concept
//
//  Created by Tao, Steven on 3/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDHomeHeaderCollectionViewCell.h"

#import "SDUtils.h"

@interface SDHomeHeaderCollectionViewCell()
@property (nonatomic) NSDateFormatter *dateformatter;
@end

@implementation SDHomeHeaderCollectionViewCell

+ (CGFloat)heightForCell
{
    return 186.0f;
}

+ (UIFont *)fontForDayLabel
{
    return [UIFont josefinSansFontOfSize:48];
}

+ (UIFont *)fontForDateLabel
{
    return [UIFont josefinSansSemiBoldFontOfSize:16];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initHeaderCollectionViewCell];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initHeaderCollectionViewCell];
    }
    return self;
}

- (void)initHeaderCollectionViewCell
{
    self.dateformatter = [[NSDateFormatter alloc] init];
    [_dateformatter setLocale:[NSLocale currentLocale]];

}

- (void)layoutSubviews
{
    [super layoutSubviews];

    [_dateformatter setDateFormat:SDDateFormat_dd_MMMM];
    ((UILabel *)_labels[1]).text = [[_dateformatter stringFromDate:[NSDate date]] uppercaseString];
    [_dateformatter setDateFormat:@"EEEE"];
    ((UILabel *)_labels[2]).text = [[_dateformatter stringFromDate:[NSDate date]] capitalizedString];

    
    // Check user langauge and adjust label size
    ((UILabel *)_labels[0]).font = [[self class] fontForDayLabel];
    ((UILabel *)_labels[1]).font = [[self class] fontForDateLabel];
    ((UILabel *)_labels[2]).font = [[self class] fontForDateLabel];
    for (UILabel *label in _labels) {
        [label sizeToFit];
    }
    
}

- (void)layoutSubviewsWithContentOffset:(CGPoint)contentOffSet
{
    UILabel *todayLabel = ((UILabel *)_labels[0]);
    todayLabel.font = [UIFont fontWithName:todayLabel.font.fontName size:todayLabel.font.pointSize - contentOffSet.y];
}

@end
