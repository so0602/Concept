//
//  UITabBarController+Additions.m
//  Somday
//
//  Created by Freddy on 20/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "UITabBarController+Additions.h"

#import "UIView+Addition.h"

@implementation UITabBarController (Additions)

-(BOOL)tabBarHidden{
	return self.tabBar.hidden;
}

-(void)setTabBarHidden:(BOOL)hidden{
	UIView* view = self.contentView;
	if( hidden ) view.frame = self.view.bounds;
	else view.size = CGSizeMake(self.view.width, self.view.height - self.tabBar.height);
	
	self.tabBar.hidden = hidden;
}

-(UIView*)contentView{
	UIView* contentView = nil;
	for( UIView* view in self.view.subviews ){
		if( [view isKindOfClass:[UITabBar class]] ) continue;
		contentView = view;
		break;
	}
	return contentView;
}

@end
