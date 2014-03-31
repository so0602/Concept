//
//  SDErrorBubbleView.h
//  Somday
//
//  Created by Freddy on 27/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDErrorBubbleView : UIView

@property (nonatomic, strong) NSString* message;

+(SDErrorBubbleView*)bubbleView;

@end
