//
//  SDLoginMainViewController.m
//  Somday
//
//  Created by Freddy on 11/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDLoginMainViewController.h"

#import "UIFont+Addition.h"

@interface SDLoginMainViewController ()

@property (nonatomic, strong) IBOutlet UILabel* titleLabel;
@property (nonatomic, strong) IBOutlet UILabel* subtitleLabel;

@end

@implementation SDLoginMainViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    
    self.titleLabel.font = [UIFont josefinSansFontOfSize:self.titleLabel.font.pointSize];
    self.subtitleLabel.font = [UIFont josefinSansSemiBoldFontOfSize:self.subtitleLabel.font.pointSize];
}

@end
