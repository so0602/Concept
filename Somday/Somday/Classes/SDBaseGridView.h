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
@property (nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic) IBOutlet UIButton *shareButton;
@property (nonatomic) IBOutlet UIButton *moreButton;
@property (nonatomic) IBOutlet UIButton *likeButton;
@property (nonatomic) IBOutlet UIButton *commentButton;

+ (CGFloat)heightForCell;

@end
