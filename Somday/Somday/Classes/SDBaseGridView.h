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

@interface SDBaseGridView : UICollectionViewCell <UIGestureRecognizerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView* blurBackgroundImageView;

@property (nonatomic) BOOL disableSwipeGesture;

+ (CGFloat)heightForCell;

+(instancetype)gridViewWithStory:(SDStory*)story collectionView:(UICollectionView*)collectionView forIndexPath:(NSIndexPath*)indexPath;
+(Class)classWithStory:(SDStory*)story;

@property (nonatomic, strong) SDStory* story;

@end
