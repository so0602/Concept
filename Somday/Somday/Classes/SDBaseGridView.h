//
//  SDBaseGridView.h
//  Somday
//
//  Created by Tao, Steven on 3/10/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "SDStory.h"

@interface SDBaseGridView : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIView* mainContentView;
@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, strong) IBOutlet UIButton *shareButton;
@property (nonatomic, strong) IBOutlet UIButton *moreButton;
@property (nonatomic, strong) IBOutlet UIButton *likeButton;
@property (nonatomic, strong) IBOutlet UIButton *commentButton;
@property (nonatomic, strong) IBOutlet UIButton *userButton;

+ (CGFloat)heightForCell;

+(instancetype)gridViewWithStory:(SDStory*)story collectionView:(UICollectionView*)collectionView forIndexPath:(NSIndexPath*)indexPath;
+(Class)classWithStory:(SDStory*)story;

@property (nonatomic, strong) SDStory* story;

@end
