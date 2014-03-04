//
//  SDDynamicsDrawerViewController.m
//  Concept
//
//  Created by Freddy So on 2/26/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDDynamicsDrawerViewController.h"

#import "SDMenuViewController.h"

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

#pragma mark - Private Functions

-(void)initialize{
    [super initialize];
    
    SDMenuViewController* menuViewController = [SDMenuViewController viewControllerFromStoryboardWithIdentifier:@"MainMenu"];
    menuViewController.dynamicsDrawerViewController = self;
    self.delegate = menuViewController;
    self.customDelegate = menuViewController;
    
    [self setDrawerViewController:menuViewController forDirection:MSDynamicsDrawerDirectionLeft];
    
    [menuViewController transitionToViewController:SDPaneViewControllerType_Home];
    [self setRevealWidth:320 forDirection:MSDynamicsDrawerDirectionLeft];
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
    for (SDDynamicsDrawerPaneState currentPaneState = SDDynamicsDrawerPaneStateClosed; currentPaneState <= SDDynamicsDrawerPaneStateHalfOpen; currentPaneState++) {
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
        case SDDynamicsDrawerPaneStateHalfOpen:
            switch (self.currentDrawerDirection) {
                case MSDynamicsDrawerDirectionTop:
                    paneViewOrigin.y = 60;
                    break;
                case MSDynamicsDrawerDirectionLeft:
                    paneViewOrigin.x = 60;
                    break;
                case MSDynamicsDrawerDirectionBottom:
                    paneViewOrigin.y = -60;
                    break;
                case MSDynamicsDrawerDirectionRight:
                    paneViewOrigin.x = -60;
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
            case SDDynamicsDrawerPaneStateHalfOpen:
                boundary.size.width = ((CGRectGetWidth(self.paneView.frame) + 60) + 2.0);
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
            case SDDynamicsDrawerPaneStateHalfOpen:
                boundary.size.height = ((CGRectGetHeight(self.paneView.frame) + 60) + 2.0);
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
    return [UIBezierPath bezierPathWithRect:boundary];
}

@end