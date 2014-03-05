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

@interface SDMenuViewController ()

@property (nonatomic, strong) IBOutlet UITableView* tableView;

@property (nonatomic, strong) NSDictionary* paneViewControllerTitles;
@property (nonatomic, strong) NSDictionary* paneViewControllerIdentifiers;

@property (nonatomic, strong) UIBarButtonItem* menuBarButtonItem;

-(void)initialize;

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

#pragma mark - SDMenuViewController

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
    
    if( paneViewControllerType == SDPaneViewControllerType_Search ){
        [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpen animated:TRUE allowUserInterruption:TRUE completion:nil];
        SDSearchViewController* viewController = [self.storyboard instantiateViewControllerWithIdentifier:self.paneViewControllerIdentifiers[@(SDPaneViewControllerType_Search)]];
//        viewController.backgroundImage = [UIApplication sharedApplication].keyWindow.convertViewToImage;
        viewController.backgroundImage = self.view.convertViewToImage;
        [self addChildViewController:viewController];
        [viewController viewDidLoad];
        [self.view addSubview:viewController.view];
        viewController.view.alpha = 0.0;
        [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            viewController.view.alpha = 1.0;
            self.tableView.alpha = 0.0;
        } completion:^(BOOL finished) {
            
        }];
        return;
    }
    
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
    
    self.menuBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStylePlain target:self action:@selector(dynamicsDrawerMenuBarButtonItemTapped:)];
    paneViewController.navigationItem.leftBarButtonItem = self.menuBarButtonItem;
    
    UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:paneViewController];
    [self.dynamicsDrawerViewController setPaneViewController:navigationController animated:animationTransition completion:nil];
    
    self.paneViewControllerType = paneViewControllerType;
}

-(void)dynamicsDrawerMenuBarButtonItemTapped:(id)sender{
    [self.dynamicsDrawerViewController setPaneState:SDDynamicsDrawerPaneStateHalfOpen inDirection:MSDynamicsDrawerDirectionLeft animated:TRUE allowUserInterruption:TRUE completion:nil];
}

#pragma mark - UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.paneViewControllerTitles.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SDMenuTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SDMenuTableViewCell"];
    cell.backgroundColor = [UIColor clearColor];
    [cell populateData:self.paneViewControllerTitles[@(indexPath.row)]];
    
    return cell;
}

#pragma mark - UITableViewDelegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self transitionToViewController:indexPath.row];
}

#pragma mark - MSDynamicsDrawerViewControllerDelegate

-(void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController mayUpdateToPaneState:(MSDynamicsDrawerPaneState)paneState forDirection:(MSDynamicsDrawerDirection)direction{
    
}
-(void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController didUpdateToPaneState:(MSDynamicsDrawerPaneState)paneState forDirection:(MSDynamicsDrawerDirection)direction{
    
}
-(BOOL)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController shouldBeginPanePan:(UIPanGestureRecognizer *)panGestureRecognizer{
    SDLog(@"Gesture: %@", panGestureRecognizer);
    SDLog(@"-- translationInView: %@", NSStringFromCGPoint([panGestureRecognizer translationInView:panGestureRecognizer.view]));
    return TRUE;
}

#pragma mark - SDDynamicsDrawerViewControllerDelegate

-(void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController paneViewPositionDidChanged:(CGPoint)position{
    SDLog(@"position: %@", NSStringFromCGPoint(position));
}

@end
