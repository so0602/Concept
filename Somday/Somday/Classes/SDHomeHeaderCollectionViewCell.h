//
//  SDHomeHeaderCollectionViewCell.h
//  Concept
//
//  Created by Tao, Steven on 3/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDHomeHeaderCollectionViewCell : UICollectionViewCell

@property (nonatomic) IBOutletCollection(UILabel) NSArray *labels;
@property (nonatomic) IBOutlet UIView *baseView;

+ (CGFloat)heightForCell;
+ (UIFont *)fontForDayLabel;
+ (UIFont *)fontForDateLabel;

- (void)layoutSubviewsWithContentOffset:(CGPoint)contentOffSet;
@end
