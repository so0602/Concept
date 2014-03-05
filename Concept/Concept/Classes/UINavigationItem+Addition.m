//
//  UINavigationItem+Addition.m
//  Concept
//
//  Created by Tao, Steven on 3/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "UINavigationItem+Addition.h"

#import "SDHomeNavigationTitleView.h"

@implementation UINavigationItem (Addition)

- (void)showSDTitleView
{
    SDHomeNavigationTitleView *titleView = [[NSBundle mainBundle] loadNibNamed:@"SDHomeNavigationTitleView" owner:self options:nil][0];
    self.titleView = titleView;
}

@end
