//
//  SDMenuViewController.m
//  Concept
//
//  Created by Freddy So on 3/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDMenuViewController.h"

@interface SDMenuViewController ()

@property (nonatomic, strong) NSDictionary* paneViewControllerTitles;
@property (nonatomic, strong) NSDictionary* paneViewControllerIdentifiers;
@property (nonatomic, strong) NSDictionary* paneViewControllerClasses;

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
    self.paneViewControllerClasses = @{
                                      @(SDPaneViewControllerType_Search) : [UIViewController class],
                                      @(SDPaneViewControllerType_Home) : [UIViewController class],
                                      @(SDPaneViewControllerType_User) : [UIViewController class],
                                      @(SDPaneViewControllerType_Friends) : [UIViewController class],
                                      @(SDPaneViewControllerType_Agenda) : [UIViewController class],
                                      @(SDPaneViewControllerType_Chats) : [UIViewController class],
                                      @(SDPaneViewControllerType_Settings) : [UIViewController class]
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

@end
