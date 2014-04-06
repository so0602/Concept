//
//  SDTranslucentImageView.h
//  Somday
//
//  Created by Freddy on 7/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDTranslucentImageView : UIImageView

@property (nonatomic, strong) UIView* targetView;
@property (nonatomic, strong) UIImage* targetImage;

@end
