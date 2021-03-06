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
#import "SDRecentChatsViewController.h"

#import "SDLoginViewController.h"

#import "SDUtils.h"

const CGFloat SDPaneViewVelocityThreshold = 5.0;
const CGFloat SDPaneViewVelocityMultiplier = 5.0;
const CGFloat SDPaneViewCornerRadius = 8.0;
const CGFloat SDPaneViewFilterViewTag = 7777;


@interface MSDynamicsDrawerViewController ()

-(void)initialize;

@property (nonatomic, assign) MSDynamicsDrawerDirection currentDrawerDirection;
@property (nonatomic, assign) MSDynamicsDrawerPaneState potentialPaneState;
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
- (void)updateStylers;

@property (nonatomic, readonly) NSInteger menuWidth;

@end

@interface SDDynamicsDrawerViewController ()

@property (nonatomic, strong) SDMenuViewController* menuViewController;
@property (nonatomic, strong) SDTopMenuViewController* topMenuViewController;
@property (nonatomic, strong) UINavigationController* chatNavigationViewController;

@property (nonatomic, strong) UIViewController* prePaneViewController;

@end

@implementation SDDynamicsDrawerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#if defined(LeftNavigationControl) && LeftNavigationControl
    [self.paneView setY:20];
    [self.paneView setHeight:self.paneView.height - 20];
#else
    self.shouldAlignStatusBarToPaneView = FALSE;
    [self addStylersFromArray:@[[MSDynamicsDrawerParallaxStyler styler], [MSDynamicsDrawerFadeStyler styler]] forDirection:MSDynamicsDrawerDirectionLeft];
    [self addStylersFromArray:@[[MSDynamicsDrawerParallaxStyler styler], [MSDynamicsDrawerFadeStyler styler]] forDirection:MSDynamicsDrawerDirectionRight];
#endif
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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
    self.delegate = self.menuViewController;
    self.customDelegate = self.menuViewController;
    
    [self.topMenuViewController.view removeFromSuperview];
    
    [self setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionLeft animated:TRUE allowUserInterruption:FALSE completion:nil];
    
    [self updatePeneViewCornerRadius:SDPaneViewCornerRadius];
}

-(void)showTopMenu{
    if( [self drawerViewControllerForDirection:MSDynamicsDrawerDirectionLeft] ){
        [self setDrawerViewController:nil forDirection:MSDynamicsDrawerDirectionLeft];
    }
    
    UIView* view = self.addBarButtonItem.customView;
    view = view.subviews.firstObject;
    [SDUtils rotateView:view];
    
    if( self.menuViewController.view.superview ){
        [self.menuViewController.view removeFromSuperview];
    }
    
    [self setDrawerViewController:self.topMenuViewController forDirection:MSDynamicsDrawerDirectionTop];
    self.delegate = self.topMenuViewController;
    self.customDelegate = self.topMenuViewController;
    
    [self setPaneState:MSDynamicsDrawerPaneStateOpen inDirection:MSDynamicsDrawerDirectionTop animated:TRUE allowUserInterruption:FALSE completion:nil];
    
    [self updatePeneViewCornerRadius:SDPaneViewCornerRadius];
}

-(void)topMenuWillClose{
    UIView* view = self.addBarButtonItem.customView;
    view = view.subviews.firstObject;
    [SDUtils rotateBackView:view];
//    [super topMenuWillClose];
    self.delegate = self.menuViewController;
    self.customDelegate = self.menuViewController;
    if( [self drawerViewControllerForDirection:MSDynamicsDrawerDirectionTop] ){
        [self setDrawerViewController:nil forDirection:MSDynamicsDrawerDirectionTop];
    }
    [self setDrawerViewController:self.menuViewController forDirection:MSDynamicsDrawerDirectionLeft];
}

-(void)topMenuDidClosed{
    self.delegate = self.menuViewController;
    self.customDelegate = self.menuViewController;
    [self updatePeneViewCornerRadius:0.0];
    if( [self drawerViewControllerForDirection:MSDynamicsDrawerDirectionTop] ){
        [self setDrawerViewController:nil forDirection:MSDynamicsDrawerDirectionTop];
    }
    [self.topMenuViewController.view removeFromSuperview];
    [self setDrawerViewController:self.menuViewController forDirection:MSDynamicsDrawerDirectionLeft];
}

-(UIBarButtonItem*)menuBarButtonItem{
    if( !_menuBarButtonItem ){
        SEL action = @selector(showLeftMenu);
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:action forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"icons-shadow-24px_menu"] forState:UIControlStateNormal];
        [button sizeToFit];
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
        
        UIView* view = [[UIView alloc] initWithFrame:button.bounds];
        [view addSubview:button];
        _addBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
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
    self.topMenuViewController.dynamicsDrawerViewController = self;
    
    self.chatNavigationViewController = [UINavigationController viewControllerFromStoryboardWithIdentifier:@"ChatNavigation"];
//    UIViewController* viewController = [SDRecentChatsViewController viewControllerFromStoryboardWithIdentifier:@"RecentChats"];
//    NSMutableArray* viewControllers = [NSMutableArray array];
//    [viewControllers addObject:[[UIViewController alloc] init]];
//    [viewControllers addObject:viewController];
//    self.chatNavigationViewController.viewControllers = viewControllers;
    
    
    [self setDrawerViewController:self.menuViewController forDirection:MSDynamicsDrawerDirectionLeft];
    [self setDrawerViewController:self.chatNavigationViewController forDirection:MSDynamicsDrawerDirectionRight];
    
    [self.menuViewController transitionToViewController:SDPaneViewControllerType_Home];
    
    double delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self setRevealWidth:CGRectGetWidth(self.view.frame) forDirection:MSDynamicsDrawerDirectionLeft];
        [self setRevealWidth:CGRectGetWidth(self.view.frame) forDirection:MSDynamicsDrawerDirectionRight];
        [self setRevealWidth:CGRectGetHeight(self.view.frame) forDirection:MSDynamicsDrawerDirectionTop];
    });
    
    self.paneViewSlideOffAnimationEnabled = FALSE;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topMenuWillClose) name:TopMenuWillClose object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topMenuDidClosed) name:TopMenuDidClosed object:nil];
}

-(void)updatePeneViewCornerRadius:(CGFloat)radius
{
    UIView *filterView = [self.paneView viewWithTag:SDPaneViewFilterViewTag];
    if (!filterView) {
        filterView = [[UIView alloc] initWithFrame:self.paneView.bounds];
        //filterView.backgroundColor = [UIColor whiteColor];
        filterView.backgroundColor = [UIColor clearColor];
        filterView.alpha = 0.0f;
        filterView.userInteractionEnabled = NO;
        filterView.layer.masksToBounds = YES;
        filterView.layer.cornerRadius = radius;
        filterView.tag = SDPaneViewFilterViewTag;
    }
    if (radius>0) {
        [self.paneView addSubview:filterView];
        [UIView animateWithDuration:0.2 animations:^{
            filterView.alpha = 0.2f;
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            filterView.alpha = 0.0f;
        }];
    }
    
    //    self.paneView.layer.masksToBounds = NO;
    //    self.paneView.layer.cornerRadius = radius;
    self.paneView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.paneView.layer.shadowOffset = CGSizeMake(-3.0, 5.0);
    self.paneView.layer.shadowOpacity = 0.7f;
    self.paneView.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:radius==0?CGRectZero:self.paneView.bounds cornerRadius:self.paneView.layer.cornerRadius].CGPath;
    
    UIView *contentView = ((UIView *)self.paneView.subviews[0]);
    contentView.layer.masksToBounds = YES;
    contentView.layer.cornerRadius = radius;
    
}

#if defined(LeftNavigationControl) && LeftNavigationControl
#pragma mark - MSDynamicsDrawerViewController Override

- (void)paneTapped:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([self paneTapToCloseEnabledForDirection:self.currentDrawerDirection]) {
        [self updatePeneViewCornerRadius:0.0f];
        
        SDDynamicsDrawerViewController* weakSelf = self;
        [self setPaneState:MSDynamicsDrawerPaneStateClosed animated:TRUE allowUserInterruption:FALSE completion:^{
            [[NSNotificationCenter defaultCenter] postNotificationName:DynamicsDrawerViewControllerDidUpdateNotification object:nil];
            
            if( weakSelf.topMenuViewController.view.superview ){
                [weakSelf topMenuDidClosed];
            }else if( weakSelf.menuViewController.view.superview ){
            }
        }];
//        [self addDynamicsBehaviorsToCreatePaneState:MSDynamicsDrawerPaneStateClosed];
    }
}

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
            [self updatePeneViewCornerRadius:SDPaneViewCornerRadius];
            
            if( self.customDelegate && [(NSObject*)self.customDelegate respondsToSelector:@selector(dynamicsDrawerViewController:paneViewPositionDidChanged:)]){
                [self.customDelegate dynamicsDrawerViewController:self paneViewPositionDidChanged:self.paneView.frame.origin];
            }
            // If the drawer is being swiped into the closed state, set the direciton to none and the state to closed since the user is manually doing so
            NSLog(@"chk7");
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
                if (fabsf(paneVelocity) > SDPaneViewVelocityThreshold) {
                    MSDynamicsDrawerPaneState state = [self paneStateForPanVelocity:paneVelocity];
                    [self addDynamicsBehaviorsToCreatePaneState:state pushMagnitude:(fabsf(paneVelocity) * SDPaneViewVelocityMultiplier) pushAngle:[self gravityAngleForState:state direction:self.currentDrawerDirection] pushElasticity:self.elasticity];
                }
                // If not released with a velocity over the threhold, update to nearest `paneState`
                else {
                    [self addDynamicsBehaviorsToCreatePaneState:[self nearestPaneState]];
                    if ([self nearestPaneState] == MSDynamicsDrawerPaneStateClosed)
                        [self updatePeneViewCornerRadius:0.0f];
                }
            } else {
                [self updatePeneViewCornerRadius:0.0f];
            }
            break;
        }
        default:
            break;
    }
    
}

- (void)setPaneViewController:(UIViewController *)paneViewController animated:(BOOL)animated completion:(void (^)(void))completion
{
    NSLog(@"setPaneViewController frame!!!: %@", NSStringFromCGRect(self.paneView.frame));
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
                [self setPaneState:MSDynamicsDrawerPaneStateClosed animated:animated allowUserInterruption:FALSE completion:^{
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
        [self setPaneState:MSDynamicsDrawerPaneStateClosed animated:animated allowUserInterruption:FALSE completion:^{
            if (completion) completion();
        }];
    }
    NSLog(@"setPaneViewController2 frame!!!: %@", NSStringFromCGRect(self.paneView.frame));
}

- (void)replaceViewController:(UIViewController *)existingViewController withViewController:(UIViewController *)newViewController inContainerView:(UIView *)containerView completion:(void (^)(void))completion
{
    NSLog(@"replaceViewController frame!!!: %@", NSStringFromCGRect(self.paneView.frame));
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
        [newViewController beginAppearanceTransition:YES animated:NO];
        newViewController.view.frame = containerView.bounds;
        [self addChildViewController:newViewController];
        [containerView addSubview:newViewController.view];
        [newViewController didMoveToParentViewController:self];
        [newViewController endAppearanceTransition];
        if (completion) completion();
    }
    else if( existingViewController == newViewController ){
        [containerView addSubview:newViewController.view];
        if (completion) completion();
    }
    NSLog(@"replaceViewController2 frame!!!: %@", NSStringFromCGRect(self.paneView.frame));
}
#endif

@end