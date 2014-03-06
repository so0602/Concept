//
//  SDDynamicsDrawerViewController.m
//  Concept
//
//  Created by Freddy So on 2/26/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDDynamicsDrawerViewController.h"

#import "SDMenuViewController.h"
#import "SDTopMenuViewController.h"

#import "SDUtils.h"

#import "UIViewController+Addition.h"

const CGFloat MSPaneViewVelocityThreshold_Copy = 5.0;
const CGFloat MSPaneViewVelocityMultiplier_Copy = 5.0;

@interface MSDynamicsDrawerViewController ()

-(void)initialize;

@property (nonatomic, assign) MSDynamicsDrawerDirection currentDrawerDirection;
@property (nonatomic, strong) UIDynamicAnimator *dynamicAnimator;

- (MSDynamicsDrawerDirection)directionForPanWithStartLocation:(CGPoint)startLocation currentLocation:(CGPoint)currentLocation;
- (CGRect)paneViewFrameForPanWithStartLocation:(CGPoint)startLocation currentLocation:(CGPoint)currentLocation bounded:(inout BOOL *)bounded;
- (CGFloat)velocityForPanWithStartLocation:(CGPoint)startLocation currentLocation:(CGPoint)currentLocation;
- (CGPoint)paneViewOriginForPaneState:(MSDynamicsDrawerPaneState)paneState;
- (void)_setPaneState:(MSDynamicsDrawerPaneState)paneState;
- (MSDynamicsDrawerPaneState)nearestPaneState;
- (MSDynamicsDrawerPaneState)paneStateForPanVelocity:(CGFloat)panVelocity;
- (void)addDynamicsBehaviorsToCreatePaneState:(MSDynamicsDrawerPaneState)paneState;
- (CGFloat)gravityAngleForState:(MSDynamicsDrawerPaneState)state direction:(MSDynamicsDrawerDirection)direction;
- (void)addDynamicsBehaviorsToCreatePaneState:(MSDynamicsDrawerPaneState)paneState pushMagnitude:(CGFloat)pushMagnitude pushAngle:(CGFloat)pushAngle pushElasticity:(CGFloat)elasticity;
- (CGFloat)openStateRevealWidth;

@end

@interface SDDynamicsDrawerViewController ()

@property (nonatomic, strong) SDMenuViewController* menuViewController;
@property (nonatomic, strong) SDTopMenuViewController* topMenuViewController;

@property (nonatomic, strong) UIViewController* prePaneViewController;

@end

@implementation SDDynamicsDrawerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showLeftMenu{
    if( [self drawerViewControllerForDirection:MSDynamicsDrawerDirectionTop] ){
        [self setDrawerViewController:nil forDirection:MSDynamicsDrawerDirectionTop];
    }
    [self setDrawerViewController:self.menuViewController forDirection:MSDynamicsDrawerDirectionLeft];
    [self setPaneState:(MSDynamicsDrawerPaneState)SDDynamicsDrawerPaneStateMenu inDirection:MSDynamicsDrawerDirectionLeft animated:TRUE allowUserInterruption:TRUE completion:nil];
}

-(void)showTopMenu{
    if( [self drawerViewControllerForDirection:MSDynamicsDrawerDirectionLeft] ){
        [self setDrawerViewController:nil forDirection:MSDynamicsDrawerDirectionLeft];
    }
    
    UIView* view = self.addBarButtonItem.customView;
    [SDUtils rotateView:view];
    
    [self setDrawerViewController:self.topMenuViewController forDirection:MSDynamicsDrawerDirectionTop];
    [self setPaneState:(MSDynamicsDrawerPaneState)SDDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionTop animated:TRUE allowUserInterruption:TRUE completion:nil];
}

-(UIBarButtonItem*)menuBarButtonItem{
    if( !_menuBarButtonItem ){
        SEL action = @selector(showLeftMenu);
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"icons-shadow-24px_menu"] forState:UIControlStateNormal];
        [button sizeToFit];
        button.backgroundColor = [UIColor redColor];
        _menuBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        _menuBarButtonItem.target = self;
        _menuBarButtonItem.action = action;
    }
    return _menuBarButtonItem;
}

-(UIBarButtonItem*)addBarButtonItem{
    if( !_addBarButtonItem ){
        SEL action = @selector(showTopMenu);
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"icons-shadow-24px_add"] forState:UIControlStateNormal];
        [button sizeToFit];
        button.backgroundColor = [UIColor redColor];
        _addBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        _addBarButtonItem.target = self;
        _addBarButtonItem.action = action;
    }
    return _addBarButtonItem;
}

#pragma mark - Private Functions

-(void)initialize{
    [super initialize];
    
    self.menuViewController = [SDMenuViewController viewControllerFromStoryboardWithIdentifier:@"MainMenu"];
    self.menuViewController.dynamicsDrawerViewController = self;
    self.delegate = self.menuViewController;
    self.customDelegate = self.menuViewController;
    
    self.topMenuViewController = [SDTopMenuViewController viewControllerFromStoryboardWithIdentifier:@"TopMenu"];
    
    [self setDrawerViewController:self.menuViewController forDirection:MSDynamicsDrawerDirectionLeft];
    
    [self.menuViewController transitionToViewController:SDPaneViewControllerType_Home];
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setRevealWidth:CGRectGetWidth(self.view.frame) forDirection:MSDynamicsDrawerDirectionLeft];
        [self setRevealWidth:60 forDirection:MSDynamicsDrawerDirectionTop];
    });
    
    self.paneViewSlideOffAnimationEnabled = FALSE;
}

#pragma mark - MSDynamicsDrawerViewController Override

- (void)panePanned:(UIPanGestureRecognizer *)gestureRecognizer
{
    static CGPoint panStartLocation;
    static CGFloat paneVelocity;
    static MSDynamicsDrawerDirection panDirection;
    
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan: {
            // Initialize static variables
            panStartLocation = [gestureRecognizer locationInView:self.paneView];
            paneVelocity = 0.0;
            panDirection = self.currentDrawerDirection;
            break;
        }
        case UIGestureRecognizerStateChanged: {
            CGPoint currentPanLocation = [gestureRecognizer locationInView:self.paneView];
            MSDynamicsDrawerDirection currentPanDirection = [self directionForPanWithStartLocation:panStartLocation currentLocation:currentPanLocation];
            // If there's no current direction, try to determine it
            if (self.currentDrawerDirection == MSDynamicsDrawerDirectionNone) {
                MSDynamicsDrawerDirection currentDrawerDirection = MSDynamicsDrawerDirectionNone;
                // If a direction has not yet been previousy determined, use the pan direction
                if (panDirection == MSDynamicsDrawerDirectionNone) {
                    currentDrawerDirection = currentPanDirection;
                } else {
                    // Only allow a new direction to be in the same direction as before to prevent swiping between drawers in one gesture
                    if (currentPanDirection == panDirection) {
                        currentDrawerDirection = panDirection;
                    }
                }
                // If the new direction is still none, don't continue
                if (currentDrawerDirection == MSDynamicsDrawerDirectionNone) {
                    return;
                }
                // Ensure that the new current direction is:
                if ((self.possibleDrawerDirection & currentDrawerDirection) &&         // Possible
                    ([self paneDragRevealEnabledForDirection:currentDrawerDirection])) // Has drag to reveal enabled
                {
                    self.currentDrawerDirection = currentDrawerDirection;
                    // Establish the initial drawer direction if there was none
                    if (panDirection == MSDynamicsDrawerDirectionNone) {
                        panDirection = self.currentDrawerDirection;
                    }
                }
                // If these criteria aren't met, cancel the gesture
                else {
                    gestureRecognizer.enabled = NO;
                    gestureRecognizer.enabled = YES;
                    return;
                }
            }
            // If the current reveal direction's pane drag reveal is disabled, cancel the gesture
            else if (![self paneDragRevealEnabledForDirection:self.currentDrawerDirection]) {
                gestureRecognizer.enabled = NO;
                gestureRecognizer.enabled = YES;
                return;
            }
            // At this point, panning is able to move the pane independently from the dynamic animator, so remove all behaviors to prevent conflicting frames
            [self.dynamicAnimator removeAllBehaviors];
            // Update the pane frame based on the pan gesture
            BOOL paneViewFrameBounded;
            self.paneView.frame = [self paneViewFrameForPanWithStartLocation:panStartLocation currentLocation:currentPanLocation bounded:&paneViewFrameBounded];
            // Update the pane velocity based on the pan gesture
            CGFloat currentPaneVelocity = [self velocityForPanWithStartLocation:panStartLocation currentLocation:currentPanLocation];
            // If the pane view is bounded or the determined velocity is 0, don't update it
            if (!paneViewFrameBounded && (currentPaneVelocity != 0.0)) {
                paneVelocity = currentPaneVelocity;
            }
            
            if( self.customDelegate && [(NSObject*)self.customDelegate respondsToSelector:@selector(dynamicsDrawerViewController:paneViewPositionDidChanged:)]){
                [self.customDelegate dynamicsDrawerViewController:self paneViewPositionDidChanged:self.paneView.frame.origin];
            }
            // If the drawer is being swiped into the closed state, set the direciton to none and the state to closed since the user is manually doing so
            if ((self.currentDrawerDirection != MSDynamicsDrawerDirectionNone) &&
                (currentPanDirection != MSDynamicsDrawerDirectionNone) &&
                CGPointEqualToPoint(self.paneView.frame.origin, [self paneViewOriginForPaneState:MSDynamicsDrawerPaneStateClosed])) {
                [self _setPaneState:MSDynamicsDrawerPaneStateClosed];
                self.currentDrawerDirection = MSDynamicsDrawerDirectionNone;
            }
            break;
        }
        case UIGestureRecognizerStateEnded: {
            if (self.currentDrawerDirection != MSDynamicsDrawerDirectionNone) {
                // If the user released the pane over the velocity threshold
                if (fabsf(paneVelocity) > MSPaneViewVelocityThreshold_Copy) {
                    MSDynamicsDrawerPaneState state = [self paneStateForPanVelocity:paneVelocity];
                    [self addDynamicsBehaviorsToCreatePaneState:state pushMagnitude:(fabsf(paneVelocity) * MSPaneViewVelocityMultiplier_Copy) pushAngle:[self gravityAngleForState:state direction:self.currentDrawerDirection] pushElasticity:self.elasticity];
                }
                // If not released with a velocity over the threhold, update to nearest `paneState`
                else {
                    [self addDynamicsBehaviorsToCreatePaneState:[self nearestPaneState]];
                }
            }
            break;
        }
        default:
            break;
    }
}

- (MSDynamicsDrawerPaneState)nearestPaneState
{
    CGFloat minDistance = CGFLOAT_MAX;
    SDDynamicsDrawerPaneState minPaneState = NSIntegerMax;
    for (SDDynamicsDrawerPaneState currentPaneState = SDDynamicsDrawerPaneStateClosed; currentPaneState <= SDDynamicsDrawerPaneStateMenu; currentPaneState++) {
        CGPoint paneStatePaneViewOrigin = [self paneViewOriginForPaneState:(MSDynamicsDrawerPaneState)currentPaneState];
        CGPoint currentPaneViewOrigin = (CGPoint){roundf(self.paneView.frame.origin.x), roundf(self.paneView.frame.origin.y)};
        CGFloat distance = sqrt(pow((paneStatePaneViewOrigin.x - currentPaneViewOrigin.x), 2) + pow((paneStatePaneViewOrigin.y - currentPaneViewOrigin.y), 2));
//        NSLog(@"paneStatePaneViewOrigin: %@, currentPaneViewOrigin: %@, distance: %f", NSStringFromCGPoint(paneStatePaneViewOrigin), NSStringFromCGPoint(currentPaneViewOrigin), distance);
        if (distance < minDistance) {
            minDistance = distance;
            minPaneState = currentPaneState;
        }
    }
    return (MSDynamicsDrawerPaneState)minPaneState;
}

- (CGPoint)paneViewOriginForPaneState:(MSDynamicsDrawerPaneState)_paneState
{
    CGPoint paneViewOrigin = CGPointZero;
    SDDynamicsDrawerPaneState paneState = (SDDynamicsDrawerPaneState)_paneState;
    switch (paneState) {
        case SDDynamicsDrawerPaneStateMenu:
            switch (self.currentDrawerDirection) {
                case MSDynamicsDrawerDirectionTop:
                    paneViewOrigin.y = SDDynamicsDrawerViewController_MenuWidth;
                    break;
                case MSDynamicsDrawerDirectionLeft:
                    paneViewOrigin.x = SDDynamicsDrawerViewController_MenuWidth;
                    break;
                case MSDynamicsDrawerDirectionBottom:
                    paneViewOrigin.y = -SDDynamicsDrawerViewController_MenuWidth;
                    break;
                case MSDynamicsDrawerDirectionRight:
                    paneViewOrigin.x = -SDDynamicsDrawerViewController_MenuWidth;
                    break;
                default:
                    break;
            }
            break;
        case SDDynamicsDrawerPaneStateOpen:
            switch (self.currentDrawerDirection) {
                case MSDynamicsDrawerDirectionTop:
                    paneViewOrigin.y = self.openStateRevealWidth;
                    break;
                case MSDynamicsDrawerDirectionLeft:
                    paneViewOrigin.x = self.openStateRevealWidth;
                    break;
                case MSDynamicsDrawerDirectionBottom:
                    paneViewOrigin.y = -self.openStateRevealWidth;
                    break;
                case MSDynamicsDrawerDirectionRight:
                    paneViewOrigin.x = -self.openStateRevealWidth;
                    break;
                default:
                    break;
            }
            break;
        case SDDynamicsDrawerPaneStateOpenWide:
            switch (self.currentDrawerDirection) {
                case MSDynamicsDrawerDirectionLeft:
                    paneViewOrigin.x = (CGRectGetWidth(self.paneView.frame) + self.paneStateOpenWideEdgeOffset);
                    break;
                case MSDynamicsDrawerDirectionTop:
                    paneViewOrigin.y = (CGRectGetHeight(self.paneView.frame) + self.paneStateOpenWideEdgeOffset);
                    break;
                case MSDynamicsDrawerDirectionBottom:
                    paneViewOrigin.y = (CGRectGetHeight(self.paneView.frame) + self.paneStateOpenWideEdgeOffset);
                    break;
                case MSDynamicsDrawerDirectionRight:
                    paneViewOrigin.x = -(CGRectGetWidth(self.paneView.frame) + self.paneStateOpenWideEdgeOffset);
                    break;
                default:
                    break;
            }
            break;
        default:
            break;
    }
    return paneViewOrigin;
}

- (UIBezierPath *)boundaryPathForState:(MSDynamicsDrawerPaneState)_state direction:(MSDynamicsDrawerDirection)direction
{
//    NSAssert(MSDynamicsDrawerDirectionIsCardinal(direction), @"Boundary is undefined for a non-cardinal reveal direction");
    
    SDDynamicsDrawerPaneState state = (SDDynamicsDrawerPaneState)_state;
    CGRect boundary = CGRectZero;
    boundary.origin = (CGPoint){-1.0, -1.0};
    if (self.possibleDrawerDirection & MSDynamicsDrawerDirectionHorizontal) {
        boundary.size.height = (CGRectGetHeight(self.paneView.frame) + 1.0);
        switch (state) {
            case SDDynamicsDrawerPaneStateClosed:
                boundary.size.width = ((CGRectGetWidth(self.paneView.frame) * 2.0) + self.paneStateOpenWideEdgeOffset + 2.0);
                break;
            case SDDynamicsDrawerPaneStateOpen:
                boundary.size.width = ((CGRectGetWidth(self.paneView.frame) + self.openStateRevealWidth) + 2.0);
                break;
            case SDDynamicsDrawerPaneStateMenu:
                boundary.size.width = ((CGRectGetWidth(self.paneView.frame) + SDDynamicsDrawerViewController_MenuWidth) + 2.0);
                break;
            case SDDynamicsDrawerPaneStateOpenWide:
                boundary.size.width = ((CGRectGetWidth(self.paneView.frame) * 2.0) + self.paneStateOpenWideEdgeOffset + 2.0);
                break;
        }
    } else if (self.possibleDrawerDirection & MSDynamicsDrawerDirectionVertical) {
        boundary.size.width = (CGRectGetWidth(self.paneView.frame) + 1.0);
        switch (state) {
            case SDDynamicsDrawerPaneStateClosed:
                boundary.size.height = ((CGRectGetHeight(self.paneView.frame) * 2.0) + self.paneStateOpenWideEdgeOffset + 2.0);
                break;
            case SDDynamicsDrawerPaneStateOpen:
                boundary.size.height = ((CGRectGetHeight(self.paneView.frame) + self.openStateRevealWidth) + 2.0);
                break;
            case SDDynamicsDrawerPaneStateMenu:
                boundary.size.height = ((CGRectGetHeight(self.paneView.frame) + SDDynamicsDrawerViewController_MenuWidth) + 2.0);
                break;
            case SDDynamicsDrawerPaneStateOpenWide:
                boundary.size.height = ((CGRectGetHeight(self.paneView.frame) * 2.0) + self.paneStateOpenWideEdgeOffset + 2.0);
                break;
        }
    }
    switch (direction) {
        case MSDynamicsDrawerDirectionRight:
            boundary.origin.x = ((CGRectGetWidth(self.paneView.frame) + 1.0) - boundary.size.width);
            break;
        case MSDynamicsDrawerDirectionBottom:
            boundary.origin.y = ((CGRectGetHeight(self.paneView.frame) + 1.0) - boundary.size.height);
            break;
        case MSDynamicsDrawerDirectionNone:
            boundary = CGRectZero;
            break;
        default:
            break;
    }
    NSLog(@"boundary: %@, state: %ld, paneState: %ld", NSStringFromCGRect(boundary), state, self.paneState);
    return [UIBezierPath bezierPathWithRect:boundary];
}

- (void)setPaneViewController:(UIViewController *)paneViewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    NSParameterAssert(paneViewController);
    if (!animated) {
        self.paneViewController = paneViewController;
        if (completion) completion();
        return;
    }
    if (self.paneViewController != paneViewController) {
        [self.paneViewController willMoveToParentViewController:nil];
        [self.paneViewController beginAppearanceTransition:NO animated:animated];
        void(^transitionToNewPaneViewController)() = ^{
            [paneViewController willMoveToParentViewController:self];
            self.prePaneViewController = self.paneViewController;
//            [self.paneViewController.view removeFromSuperview];
//            [self.paneViewController removeFromParentViewController];
//            [self.paneViewController didMoveToParentViewController:nil];
//            [self.paneViewController endAppearanceTransition];
            [self addChildViewController:paneViewController];
            paneViewController.view.frame = self.paneView.bounds;
            [paneViewController beginAppearanceTransition:YES animated:animated];
            [self.paneView addSubview:paneViewController.view];
            self.paneViewController = paneViewController;
            CGRect frame = self.paneViewController.view.frame;
            frame.origin.x = frame.size.width;
            self.paneViewController.view.frame = frame;
            // Force redraw of the new pane view (drastically smoothes animation)
            [self.paneView setNeedsDisplay];
            [CATransaction flush];
            [self setNeedsStatusBarAppearanceUpdate];
            
            [UIView animateWithDuration:0.3 delay:0.1 options:UIViewAnimationOptionCurveLinear animations:^{
                CGRect frame = self.paneViewController.view.frame;
                frame.origin.x = 0;
                self.paneViewController.view.frame = frame;
                
                UIView* view = self.prePaneViewController.view;
                view.alpha = 0.0;
            } completion:^(BOOL finished) {
                [self.prePaneViewController.view removeFromSuperview];
                [self.prePaneViewController removeFromParentViewController];
                [self.prePaneViewController didMoveToParentViewController:nil];
                [self.prePaneViewController endAppearanceTransition];
                self.prePaneViewController = nil;
            }];
            
            // After drawing has finished, set new pane view controller view and close
            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(self) weakSelf = self;
                self.paneViewController = paneViewController;
                [self setPaneState:MSDynamicsDrawerPaneStateClosed animated:animated allowUserInterruption:YES completion:^{
                    [paneViewController didMoveToParentViewController:weakSelf];
                    [paneViewController endAppearanceTransition];
                    if (completion) completion();
                }];
            });
        };
        if (self.paneViewSlideOffAnimationEnabled) {
            [self setPaneState:MSDynamicsDrawerPaneStateOpenWide animated:animated allowUserInterruption:NO completion:transitionToNewPaneViewController];
        } else {
            transitionToNewPaneViewController();
        }
    }
    // If trying to set to the currently visible pane view controller, just close
    else {
        [self setPaneState:MSDynamicsDrawerPaneStateClosed animated:animated allowUserInterruption:YES completion:^{
            if (completion) completion();
        }];
    }
}

- (void)replaceViewController:(UIViewController *)existingViewController withViewController:(UIViewController *)newViewController inContainerView:(UIView *)containerView completion:(void (^)(void))completion
{
    // Add initial view controller
	if (!existingViewController && newViewController) {
        [newViewController willMoveToParentViewController:self];
        [newViewController beginAppearanceTransition:YES animated:NO];
		[self addChildViewController:newViewController];
        newViewController.view.frame = containerView.bounds;
		[containerView addSubview:newViewController.view];
		[newViewController didMoveToParentViewController:self];
        [newViewController endAppearanceTransition];
        if (completion) completion();
	}
    // Remove existing view controller
    else if (existingViewController && !newViewController) {
        [existingViewController willMoveToParentViewController:nil];
        [existingViewController beginAppearanceTransition:NO animated:NO];
        [existingViewController.view removeFromSuperview];
        [existingViewController removeFromParentViewController];
        [existingViewController didMoveToParentViewController:nil];
        [existingViewController endAppearanceTransition];
        if (completion) completion();
    }
    // Replace existing view controller with new view controller
    else if ((existingViewController != newViewController) && newViewController) {
        [newViewController willMoveToParentViewController:self];
//        [existingViewController willMoveToParentViewController:nil];
//        [existingViewController beginAppearanceTransition:NO animated:NO];
//        [existingViewController.view removeFromSuperview];
//        [existingViewController removeFromParentViewController];
//        [existingViewController didMoveToParentViewController:nil];
//        [existingViewController endAppearanceTransition];
        [newViewController beginAppearanceTransition:YES animated:NO];
        newViewController.view.frame = containerView.bounds;
        [self addChildViewController:newViewController];
        [containerView addSubview:newViewController.view];
        [newViewController didMoveToParentViewController:self];
        [newViewController endAppearanceTransition];
        if (completion) completion();
    }
}

@end