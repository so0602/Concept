//
//  SDMenuViewController.m
//  Concept
//
//  Created by Freddy So on 3/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDMenuViewController.h"

#import "SDAppDelegate.h"

#import "SDSearchViewController.h"

#import "SDMenuTableViewCell.h"

#import "SDUtils.h"

@interface SDMenuViewController ()<SDSearchViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView* backgroundImageView;
@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSDictionary* paneViewControllerTitles;
@property (nonatomic, strong) NSDictionary* paneViewControllerIdentifiers;
@property (nonatomic, strong) NSDictionary* paneViewControllerIcons;

@property (nonatomic, strong) SDSearchViewController* searchViewController;
@property (nonatomic, strong) NSTimer* animationTimer;

@property (nonatomic) BOOL changingTab;

@property (nonatomic, strong) UIImage* backgroundImage;

-(void)initialize;

-(void)showSearchView;
-(void)hideSearchView;
-(void)addSearchView:(BOOL)screenCapture;

-(void)homeBackgroundImageDidChange:(NSNotification*)notification;

@end

@implementation SDMenuViewController

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    if( self = [super initWithCoder:aDecoder] ){
        [self initialize];
    }
    return self;
}

#pragma mark - UIViewController

-(instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    if( self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil] ){
        [self initialize];
    }
    return self;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.backgroundImageView.image = self.backgroundImage;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HomeBackgroundImageChangedNotification object:nil];
}

#pragma mark - Private Functions

-(SDSearchViewController*)searchViewController{
    if( !_searchViewController ){
        _searchViewController = [SDSearchViewController viewControllerFromStoryboardWithIdentifier:self.paneViewControllerIdentifiers[@(SDPaneViewControllerType_Search)]];
        _searchViewController.delegate = self;
    }
    return _searchViewController;
}

-(void)initialize{
    self.paneViewControllerType = NSUIntegerMax;
    self.paneViewControllerTitles = @{
                                      @(SDPaneViewControllerType_Search) : @"Search",
                                      @(SDPaneViewControllerType_Home) : @"Home",
                                      @(SDPaneViewControllerType_User) : @"User",
                                      @(SDPaneViewControllerType_Friends) : @"Friends",
                                      @(SDPaneViewControllerType_Agenda) : @"Agenda",
                                      @(SDPaneViewControllerType_Chats) : @"Chats",
                                      @(SDPaneViewControllerType_Settings) : @"Settings"
                                      };
    self.paneViewControllerIdentifiers = @{
                                      @(SDPaneViewControllerType_Search) : @"Search",
                                      @(SDPaneViewControllerType_Home) : @"Home",
                                      @(SDPaneViewControllerType_User) : @"User",
                                      @(SDPaneViewControllerType_Friends) : @"Friends",
                                      @(SDPaneViewControllerType_Agenda) : @"Agenda",
                                      @(SDPaneViewControllerType_Chats) : @"Chats",
                                      @(SDPaneViewControllerType_Settings) : @"Settings"
                                      };
    self.paneViewControllerIcons = @{
                                     @(SDPaneViewControllerType_Search) : @"icons-shadow-24px_search",
                                     @(SDPaneViewControllerType_Home) : @"icons-shadow-24px_home",
                                     @(SDPaneViewControllerType_User) : @"icons-shadow-24px_myself",
                                     @(SDPaneViewControllerType_Friends) : @"icons-shadow-24px_closeFriends",
                                     @(SDPaneViewControllerType_Agenda) : @"icons-shadow-24px_calendar",
                                     @(SDPaneViewControllerType_Chats) : @"icons-shadow-24px_chats",
                                     @(SDPaneViewControllerType_Settings) : @"icons-shadow-24px_setting"
                                     };
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HomeBackgroundImageChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeBackgroundImageDidChange:) name:HomeBackgroundImageChangedNotification object:nil];
}

-(void)showSearchView{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen animated:TRUE allowUserInterruption:TRUE completion:nil];
    
    SDSearchViewController* viewController = self.searchViewController;
    [self addSearchView:TRUE];
    
    [self.dynamicsDrawerViewController updatePeneViewCornerRadius:0.0f];
    
    if( viewController.view.alpha == 1.0 ){
        viewController.view.alpha = 0.0;
    }
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        viewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {

    }];
}

-(void)hideSearchView{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:TRUE allowUserInterruption:TRUE completion:nil];
    
    [self.dynamicsDrawerViewController updatePeneViewCornerRadius:8.0f];
    
    SDSearchViewController* viewController = self.searchViewController;
    
    [UIView animateWithDuration:0.7 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        viewController.view.alpha = 0.0;
        self.tableView.alpha = 1.0;
    } completion:^(BOOL finished) {
        [viewController.view removeFromSuperview];
    }];
}

-(void)addSearchView:(BOOL)screenCapture{
    SDSearchViewController* viewController = self.searchViewController;
    
    if( screenCapture ){
        self.tableView.alpha = 0.0;
        viewController.backgroundImage = self.view.convertViewToImage;
        self.tableView.alpha = 1.0;
    }
    
    if( ![self.childViewControllers containsObject:viewController] ){
        [self addChildViewController:viewController];
    }
    
    if( !viewController.isViewLoaded ){
        [viewController viewDidLoad];
    }
    
    if( !viewController.view.superview ){
        [self.view addSubview:viewController.view];
    }
}

-(void)homeBackgroundImageDidChange:(NSNotification*)notification{
    self.backgroundImage = notification.object;
    self.backgroundImageView.image = self.backgroundImage;
}

-(SDPaneViewControllerType)paneViewControllerTypeForIndexPath:(NSIndexPath*)indexPath{
    SDPaneViewControllerType paneViewControllerType = indexPath.row;
    return paneViewControllerType;
}

-(void)transitionToViewController:(SDPaneViewControllerType)paneViewControllerType{
    if( paneViewControllerType == self.paneViewControllerType ){
        [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:TRUE allowUserInterruption:TRUE completion:nil];
        return;
    }
    
    switch( paneViewControllerType ){
        case SDPaneViewControllerType_Search:
        {
            [self showSearchView];
        }
            break;
        case SDPaneViewControllerType_User:
        {
            [SDUtils logout];
            SDAppDelegate* delegate = [UIApplication sharedApplication].delegate;
            [delegate.mainViewController presentViewController:delegate.loginViewController animated:TRUE completion:^{
                SDDynamicsDrawerViewController* viewController = delegate.mainViewController;
                [viewController setPaneState:MSDynamicsDrawerPaneStateClosed];
            }];
        }
            break;
        default:
        {
            BOOL animationTransition = self.dynamicsDrawerViewController.paneViewController != nil;
            
            UIViewController* paneViewController = nil;
            @try {
                paneViewController = [UIViewController viewControllerFromStoryboardWithIdentifier:self.paneViewControllerIdentifiers[@(paneViewControllerType)]];
            }
            @catch (NSException *exception) {
                SDLog(@"Exception: %@", exception);
            }
            @finally {
                if( !paneViewController ){
                    paneViewController = [[UIViewController alloc] init];
                    paneViewController.view.backgroundColor = [UIColor clearColor];
//                    paneViewController.view.backgroundColor = [UIColor redColor];
                }
            }
            
            paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
            
            paneViewController.navigationItem.leftBarButtonItem = self.dynamicsDrawerViewController.menuBarButtonItem;
            
            if( paneViewControllerType == SDPaneViewControllerType_Home ){
                paneViewController.navigationItem.rightBarButtonItem = self.dynamicsDrawerViewController.addBarButtonItem;
            }
            
            self.changingTab = TRUE;
            UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
            [self.dynamicsDrawerViewController setPaneViewController:navigationController animated:animationTransition completion:^{
                self.changingTab = FALSE;
            }];
            self.paneViewControllerType = paneViewControllerType;
        }
            break;
    }
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.paneViewControllerTitles.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDMenuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SDMenuTableViewCell"];
    [cell populateData:self.paneViewControllerIcons[@(indexPath.row)]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self transitionToViewController:indexPath.row];
}

#pragma mark - MSDynamicsDrawerViewControllerDelegate

-(void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController mayUpdateToPaneState:(MSDynamicsDrawerPaneState)paneState forDirection:(MSDynamicsDrawerDirection)direction{
    [[NSNotificationCenter defaultCenter] postNotificationName:DynamicsDrawerViewControllerMayUpdateNotification object:nil];
    SDLog(@"paneState: %ld", paneState);
}
-(void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController didUpdateToPaneState:(MSDynamicsDrawerPaneState)paneState forDirection:(MSDynamicsDrawerDirection)direction{
    [[NSNotificationCenter defaultCenter] postNotificationName:DynamicsDrawerViewControllerDidUpdateNotification object:nil];
    if( !self.changingTab ){
        if( paneState == MSDynamicsDrawerPaneStateOpen || paneState == MSDynamicsDrawerPaneStateOpenWide ){
            self.searchViewController.view.alpha = 1.0;
            self.tableView.alpha = 0.0;
            [self.dynamicsDrawerViewController updatePeneViewCornerRadius:0.0f];
        }else{
            self.searchViewController.view.alpha = 0.0;
            self.tableView.alpha = 1.0;
            [self.searchViewController.view removeFromSuperview];
        }
        
        [self.animationTimer invalidate];
        self.animationTimer = nil;
    }
}
-(BOOL)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController shouldBeginPanePan:(UIPanGestureRecognizer *)panGestureRecognizer{
    [[NSNotificationCenter defaultCenter] postNotificationName:DynamicsDrawerViewControllerShouldBeginPanePanNotification object:nil];
    return TRUE;
}

#pragma mark - SDDynamicsDrawerViewControllerDelegate

-(void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController paneViewPositionDidChanged:(CGPoint)position{
    // To Freddy: what's that??
    if( !self.animationTimer && [drawerViewController drawerViewControllerForDirection:MSDynamicsDrawerDirectionLeft] ){
        self.animationTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(searchViewAnimationUpdate) userInfo:nil repeats:TRUE];
    }
}

-(void)searchViewAnimationUpdate{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            CGPoint position = self.dynamicsDrawerViewController.paneView.frame.origin;
            if( position.x >= SDDynamicsDrawerViewController_MenuWidth ){
                [self addSearchView:self.searchViewController.backgroundImage ? FALSE : TRUE];
                SDSearchViewController* viewController = self.searchViewController;
                CGFloat width = CGRectGetWidth(self.view.frame);
                CGFloat alpha = (position.x - SDDynamicsDrawerViewController_MenuWidth) / (width - SDDynamicsDrawerViewController_MenuWidth);
                viewController.view.alpha = alpha;
                self.tableView.alpha = 1 - alpha;
                SDLog(@"x,y: %@, alpha: %f", NSStringFromCGPoint(position), alpha);
            }
        });
    });

}

#pragma mark - SDSearchViewControllerDelegate

-(void)backButtonDidClick:(SDSearchViewController*)searchViewController{
    [self hideSearchView];
}

@end
