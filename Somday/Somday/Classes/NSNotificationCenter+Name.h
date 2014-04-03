//
//  NSNotificationCenter+Name.h
//  Somday
//
//  Created by Freddy on 8/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString* TopMenuWillClose;
extern NSString* TopMenuDidClosed;
extern NSString* HomeBackgroundImageChangedNotification;

extern NSString* MainBackgroundImageWillChangeNotification;
extern NSString* MainBackgroundImageDidChangeNotification;

extern NSString* DynamicsDrawerViewControllerMayUpdateNotification;
extern NSString* DynamicsDrawerViewControllerDidUpdateNotification;
extern NSString* DynamicsDrawerViewControllerShouldBeginPanePanNotification;

@interface NSNotificationCenter (Name)

@end
