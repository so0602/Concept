//
//  SDMenuViewController.m
//  Concept
//
//  Created by Freddy So on 3/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDMenuViewController.h"

#import "SDSearchViewController.h"

#import "SDMenuTableViewCell.h"

#import "SDUtils.h"

#import "UIViewController+Addition.h"

@interface SDMenuViewController ()<SDSearchViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UIImageView* backgroundImageView;
@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSDictionary* paneViewControllerTitles;
@property (nonatomic, strong) NSDictionary* paneViewControllerIdentifiers;
@property (nonatomic, strong) NSDictionary* paneViewControllerIcons;

@property (nonatomic, strong) UIBarButtonItem* menuBarButtonItem;

@property (nonatomic, strong) SDSearchViewController* searchViewController;
@property (nonatomic, strong) NSTimer* animationTimer;

@property (nonatomic) BOOL changingTab;

-(void)initialize;

-(void)showSearchView;
-(void)hideSearchView;
-(void)addSearchView:(BOOL)screenCapture;

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
}

#pragma mark - SDMenuViewController

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
}

-(void)showSearchView{
    [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen animated:TRUE allowUserInterruption:TRUE completion:nil];
    
    SDSearchViewController* viewController = self.searchViewController;
    [self addSearchView:TRUE];
    
    if( viewController.view.alpha == 1.0 ){
        viewController.view.alpha = 0.0;
    }
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        viewController.view.alpha = 1.0;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)hideSearchView{
    [self.dynamicsDrawerViewController setPaneState:(MSDynamicsDrawerPaneState)SDDynamicsDrawerPaneStateClosed animated:TRUE allowUserInterruption:TRUE completion:nil];
    [self.dynamicsDrawerViewController setPaneState:(MSDynamicsDrawerPaneState)SDDynamicsDrawerPaneStateClosed animated:TRUE allowUserInterruption:TRUE completion:^{
        [self.dynamicsDrawerViewController setPaneState:(MSDynamicsDrawerPaneState)SDDynamicsDrawerPaneStateMenu animated:TRUE allowUserInterruption:TRUE completion:nil];
    }];
    
    SDSearchViewController* viewController = self.searchViewController;
    
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        viewController.view.alpha = 0.0;
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
                    paneViewController.view.backgroundColor = [UIColor redColor];
                }
            }
            
            paneViewController.navigationItem.title = self.paneViewControllerTitles[@(paneViewControllerType)];
            
            
            self.menuBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"icons-shadow-24px_menu"] style:UIBarButtonItemStylePlain target:self action:@selector(dynamicsDrawerMenuBarButtonItemTapped:)];
            paneViewController.navigationItem.leftBarButtonItem = self.menuBarButtonItem;
            
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

-(void)dynamicsDrawerMenuBarButtonItemTapped:(id)sender{
    [self.dynamicsDrawerViewController setPaneState:(MSDynamicsDrawerPaneState)SDDynamicsDrawerPaneStateMenu inDirection:MSDynamicsDrawerDirectionLeft animated:TRUE allowUserInterruption:TRUE completion:nil];
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
    SDLog(@"paneState: %ld", paneState);
}
-(void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController didUpdateToPaneState:(MSDynamicsDrawerPaneState)paneState forDirection:(MSDynamicsDrawerDirection)direction{
    if( !self.changingTab ){
        if( paneState == MSDynamicsDrawerPaneStateOpen || paneState == MSDynamicsDrawerPaneStateOpenWide ){
            self.searchViewController.view.alpha = 1.0;
            self.tableView.alpha = 0.0;
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
    SDLog(@"Gesture: %@", panGestureRecognizer);
    SDLog(@"-- translationInView: %@", NSStringFromCGPoint([panGestureRecognizer translationInView:panGestureRecognizer.view]));
    return TRUE;
}

#pragma mark - SDDynamicsDrawerViewControllerDelegate

-(void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController paneViewPositionDidChanged:(CGPoint)position{
//    if( position.x >= SDDynamicsDrawerViewController_MenuWidth ){
//        SDSearchViewController* viewController = self.searchViewController;
//        [self addSearchView:TRUE];
//        
//        CGFloat width = CGRectGetWidth(self.view.frame);
//        CGFloat alpha = (position.x - SDDynamicsDrawerViewController_MenuWidth) / (width - SDDynamicsDrawerViewController_MenuWidth);
//        viewController.view.alpha = alpha;
//        self.tableView.alpha = 1 - alpha;
//    }
    
    if( !self.animationTimer ){
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
