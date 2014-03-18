//
//  SDStoryBookLayoutView.h
//  Somday
//
//  Created by Tao, Steven on 3/18/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDStoryBookLayoutView : UIView

@property (nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic) IBOutletCollection(UIView) NSArray *views;

@end
