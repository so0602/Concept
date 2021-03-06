//
//  SDTopMenuViewController.m
//  Somday
//
//  Created by Freddy on 6/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDTopMenuViewController.h"

#import "SDUtils.h"

@interface SDTopMenuViewController ()

@property (nonatomic, strong) IBOutlet UIButton* closeButton;
@property (nonatomic, strong) IBOutletCollection(UIButton) NSArray* buttons;
@property (nonatomic, strong) IBOutlet UIImageView* backgroundImageView;

@property (nonatomic, strong) UITabBarController* tabBarController;

@property (nonatomic, strong) UIImage* backgroundImage;

-(void)initialize;
-(void)homeBackgroundImageDidChange:(NSNotification*)notification;

@end

@implementation SDTopMenuViewController

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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if( [segue.identifier isEqualToString:@"TopMenuTabBarEmbed"] ){
        self.tabBarController = segue.destinationViewController;
        self.tabBarController.tabBarHidden = TRUE;
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.backgroundImageView.image = self.backgroundImage;
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HomeBackgroundImageChangedNotification object:nil];
}

#pragma mark - UIViewController Additions

-(void)touchUpInside:(id)sender{
    if( [self.closeButton isEqual:sender] ){
        [SDUtils rotateBackView:self.closeButton];
        [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:TRUE allowUserInterruption:FALSE completion:^{
            
        }];
    }else{
        NSInteger index = [self.buttons indexOfObject:sender];
        if( index != NSNotFound ){
            self.tabBarController.selectedIndex = index;
            [SDUtils rotateView:self.closeButton];
            [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateOpenWide animated:TRUE allowUserInterruption:FALSE completion:^{
                
            }];
        }
    }
}

#pragma mark - Private Functions

-(void)initialize{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HomeBackgroundImageChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(homeBackgroundImageDidChange:) name:HomeBackgroundImageChangedNotification object:nil];
}

-(void)homeBackgroundImageDidChange:(NSNotification*)notification{
    self.backgroundImage = notification.object;
    self.backgroundImageView.image = self.backgroundImage;
}

#pragma mark - MSDynamicsDrawerViewControllerDelegate

-(void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController mayUpdateToPaneState:(MSDynamicsDrawerPaneState)paneState forDirection:(MSDynamicsDrawerDirection)direction{
    [[NSNotificationCenter defaultCenter] postNotificationName:DynamicsDrawerViewControllerMayUpdateNotification object:nil];
    if( paneState == MSDynamicsDrawerPaneStateClosed ){
        [[NSNotificationCenter defaultCenter] postNotificationName:TopMenuWillClose object:nil];
    }
}
-(void)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController didUpdateToPaneState:(MSDynamicsDrawerPaneState)paneState forDirection:(MSDynamicsDrawerDirection)direction{
    [[NSNotificationCenter defaultCenter] postNotificationName:DynamicsDrawerViewControllerDidUpdateNotification object:nil];
    if( paneState == MSDynamicsDrawerPaneStateClosed ){
        [[NSNotificationCenter defaultCenter] postNotificationName:TopMenuDidClosed object:nil];
    }
}
-(BOOL)dynamicsDrawerViewController:(MSDynamicsDrawerViewController *)drawerViewController shouldBeginPanePan:(UIPanGestureRecognizer *)panGestureRecognizer{
    [[NSNotificationCenter defaultCenter] postNotificationName:DynamicsDrawerViewControllerShouldBeginPanePanNotification object:nil];
    return TRUE;
}

@end
