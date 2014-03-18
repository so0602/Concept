//
//  SDStoryBookGridView.m
//  Somday
//
//  Created by Tao, Steven on 3/18/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDStoryBookGridView.h"

#import "SDStoryBookLayoutView.h"
#import "FlipView.h"
#import "UIViewExtention.h"
#import "AFKPageFlipper.h"
#import "LayoutViewExtention.h"

#define itemsForPage 4

@interface SDStoryBookGridView () <AFKPageFlipperDataSource, UIGestureRecognizerDelegate>
@property (nonatomic) IBOutletCollection(UIView) NSArray *flipContentView;
@property (nonatomic) AnimationDelegate *animationDelegate;
@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
//@property (nonatomic) FlipView *flipView;
@property (nonatomic) AFKPageFlipper *flipView;
- (void)panned:(UIPanGestureRecognizer *)recognizer;
@end

@implementation SDStoryBookGridView

@synthesize animationDelegate, panGestureRecognizer, flipView, viewStack, dataSource;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initStoryBookGridView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initStoryBookGridView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self loadData];
}

#pragma mark - Private Functions

- (void)initStoryBookGridView
{
    // Debug
    self.dataSource = @[@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@"",@""];
    
    self.disableSwipeGesture = YES;
    [self addSubview:self.flipView];
//    [self addGestureRecognizer:self.panGestureRecognizer];
    

}

- (void)loadData
{
//    if (!self.animationDelegate.transformView) {
//        animationDelegate.transformView = flipView;
//        
//        [flipView printText:@"" usingImage:[SDUtils captureScreenForView:_imageViews[0]] backgroundColor:nil textColor:[UIColor redColor]];
//        [flipView printText:@"" usingImage:[SDUtils captureScreenForView:_imageViews[1]] backgroundColor:nil textColor:[UIColor redColor]];
//        
//        for (UIView *view in _imageViews) {
//            view.hidden = YES;
//        }
//        
//    }
    
}

- (void)panned:(UIPanGestureRecognizer *)recognizer
{
//    switch (recognizer.state) {
//        case UIGestureRecognizerStatePossible:
//            break;
//        case UIGestureRecognizerStateFailed: // cannot recognize for multi touch sequence
//            break;
//        case UIGestureRecognizerStateBegan: {
//            if (animationDelegate.animationState == 0) {
//                [NSObject cancelPreviousPerformRequestsWithTarget:self];
//                animationDelegate.sequenceType = kSequenceControlled;
//                animationDelegate.animationLock = YES;
//            }
//        }
//            break;
//        case UIGestureRecognizerStateChanged: {
//            if (animationDelegate.animationLock) {
//                switch (flipView.animationType) {
//                    case kAnimationFlipVertical:
//                    {
//                        float value = [recognizer translationInView:self].y;
//                        [animationDelegate setTransformValue:value delegating:NO];
//                    }
//                        break;
//                    case kAnimationFlipHorizontal: {
//                        float value = [recognizer translationInView:self].x;
//                        [animationDelegate setTransformValue:value delegating:NO];
//                    }
//                        break;
//                    default:break;
//                }
//            }
//        }
//            break;
//        case UIGestureRecognizerStateCancelled: // cancellation touch
//            break;
//        case UIGestureRecognizerStateEnded: {
//            if (animationDelegate.animationLock) {
//                // provide inertia to panning gesture
//                float value = sqrtf(fabsf([recognizer velocityInView:self].x))/10.0f;
//                [animationDelegate endStateWithSpeed:value];
//            }
//        }
//            break;
//        default:
//            break;
//    }
}

- (NSInteger)numberOfPages
{
    int count = (int)self.dataSource.count/itemsForPage;
	return (self.dataSource.count%itemsForPage)==0?count:count+1;
}

//#pragma mark - UIGestureRecognizerDelegate
//
//- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
//{
//    if (gestureRecognizer == self.panGestureRecognizer) {
//        
//        UIPanGestureRecognizer *panRecognizer = (UIPanGestureRecognizer *)gestureRecognizer;
//        CGPoint velocity = [panRecognizer velocityInView:self];
//        
//        return ABS(velocity.x) > ABS(velocity.y);
//    }
//    return NO;
//}

#pragma mark - Setter

- (AnimationDelegate *)animationDelegate
{
    if (!animationDelegate) {
        animationDelegate = [[AnimationDelegate alloc] initWithSequenceType:kSequenceControlled
                                                                   directionType:kDirectionForward];
        animationDelegate.controller = self;
        animationDelegate.perspectiveDepth = 2000;
    }
    return animationDelegate;
}

//- (FlipView *)flipView
//{
//    if (!flipView) {
//        flipView = [[FlipView alloc] initWithAnimationType:kAnimationFlipHorizontal
//                                                          frame:self.bounds];
//        flipView.backgroundColor = [UIColor clearColor];
//        flipView.layer.masksToBounds = YES;
//        flipView.layer.cornerRadius = 8.0f;
//    }
//    return flipView;
//}

- (AFKPageFlipper *)flipView
{
    if (!flipView) {
        flipView = [[AFKPageFlipper alloc] initWithFrame:self.bounds];
        flipView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        flipView.dataSource = self;
        flipView.layer.masksToBounds = YES;
        flipView.layer.cornerRadius = 8.0f;
    }
    return flipView;
}

#pragma mark -
#pragma mark Data source implementation

- (NSInteger) numberOfPagesForPageFlipper:(AFKPageFlipper *)pageFlipper {
	return [self numberOfPages];
}

- (UIView *) viewForPage:(NSInteger) page inFlipper:(AFKPageFlipper *) pageFlipper {
    
  	SDStoryBookLayoutView* layoutToReturn = [[NSBundle mainBundle] loadNibNamed:@"SDStoryBookLayoutView" owner:self options:nil][0];
    layoutToReturn.layer.masksToBounds = YES;
    layoutToReturn.layer.cornerRadius = 8.0f;
	
	int remainingMessageCount = 0;
	int totalMessageCount = (int)[dataSource count];
	remainingMessageCount = totalMessageCount - (int)(itemsForPage * page);
	
	int rangeFrom = 0;
	int rangeTo = 0;
	BOOL shouldContinue = FALSE;
	
	if (page < [self numberOfPages]) {
		rangeFrom = (int)(page * itemsForPage);
		rangeTo = itemsForPage-1;
		shouldContinue = TRUE;
	}else if (remainingMessageCount > 0) {
		rangeFrom = (int)[dataSource count]-remainingMessageCount-1;
		rangeTo = remainingMessageCount-1;
		shouldContinue = TRUE;
	}
	
//	if (shouldContinue) {
//		
//		NSRange rangeForView = NSMakeRange(rangeFrom, rangeTo);
//		
//		NSArray* messageArray= [dataSource subarrayWithRange:rangeForView];
//		
//		NSMutableDictionary* viewDictonary = [[NSMutableDictionary alloc] init];
//		TitleAndTextView* view1forLayout;
//		TitleAndTextView* view2forLayout;
//		TitleAndTextView* view3forLayout;
//		TitleAndTextView* view4forLayout;
//		TitleAndTextView* view5forLayout;
//		for (int i = 0; i < [messageArray count]; i++) {
//			if (i == 0) {
//				view1forLayout = [[[TitleAndTextView alloc] initWithMessageModel:(MessageModel*)[messageArray objectAtIndex:i]] autorelease];
//				[viewDictonary setObject:view1forLayout forKey:@"view1"];
//			}
//			if (i == 1) {
//				view2forLayout = [[[TitleAndTextView alloc] initWithMessageModel:(MessageModel*)[messageArray objectAtIndex:i]] autorelease];
//				[viewDictonary setObject:view2forLayout forKey:@"view2"];
//			}
//			if (i == 2) {
//				view3forLayout = [[[TitleAndTextView alloc] initWithMessageModel:(MessageModel*)[messageArray objectAtIndex:i]] autorelease];
//				[viewDictonary setObject:view3forLayout forKey:@"view3"];
//			}
//			if (i == 3) {
//				view4forLayout = [[[TitleAndTextView alloc] initWithMessageModel:(MessageModel*)[messageArray objectAtIndex:i]] autorelease];
//				[viewDictonary setObject:view4forLayout forKey:@"view4"];
//			}
//			if (i == 4) {
//				view5forLayout = [[[TitleAndTextView alloc] initWithMessageModel:(MessageModel*)[messageArray objectAtIndex:i]] autorelease];
//				[viewDictonary setObject:view5forLayout forKey:@"view5"];
//			}
//		}
//		
//		Class class =  NSClassFromString([NSString stringWithFormat:@"Layout%d",layoutNumber]);
//		id layoutObject = [[[class alloc] init] autorelease];
//		
//		if ([layoutObject isKindOfClass:[LayoutViewExtention class]] ) {
//			
//			layoutToReturn = (LayoutViewExtention*)layoutObject;
//			
//			[layoutToReturn initalizeViews:viewDictonary];
//			[layoutToReturn rotate:self.interfaceOrientation animation:NO];
//			[layoutToReturn setFrame:self.view.bounds];
//			layoutToReturn.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//			
//			
//		}
//	}
	
	return layoutToReturn;
}

@end
