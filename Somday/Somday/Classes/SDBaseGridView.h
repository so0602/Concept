//
//  SDBaseGridView.h
//  Somday
//
//  Created by Tao, Steven on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface SDBaseGridView : UICollectionViewCell

@property (nonatomic) UIImage *image;
@property (nonatomic) UIImageView *backgroundImageView;
@property (nonatomic) UIButton *shareButton;
@property (nonatomic) UIButton *moreButton;
@property (nonatomic) UIButton *likeButton;
@property (nonatomic) UIButton *commentButton;

+ (CGFloat)heightForCell;

@end
