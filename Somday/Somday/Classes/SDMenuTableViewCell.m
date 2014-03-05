//
//  SDMenuTableViewCell.m
//  Concept
//
//  Created by Freddy on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDMenuTableViewCell.h"

@interface SDMenuTableViewCell ()

@property (nonatomic, strong) IBOutlet UIButton* menuButton;

@property (nonatomic, strong, readonly) UITableView* tableView;

@end

@implementation SDMenuTableViewCell

-(UITableView*)tableView{
    UITableView* tableView = (id)self;
    while( tableView.superview != nil ){
        if( [tableView isKindOfClass:[UITableView class]] ){
            break;
        }
        tableView = (id)tableView.superview;
    }
    return tableView;
}

#pragma mark - UITableViewCell Additions

-(void)populateData:(id)data{
    if( [data isKindOfClass:[NSString class]] ){
//        NSString* string = (id)data;
//        [self.menuButton setTitle:string forState:UIControlStateNormal];
        NSString* imageName = (id)data;
        [self.menuButton setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    }
}

#pragma mark - UIView Additions

-(void)touchUpInside:(id)sender{
    UITableView* tableView = self.tableView;
    id<UITableViewDelegate> delegate = tableView.delegate;
    if( delegate && [delegate respondsToSelector:@selector(tableView:didSelectRowAtIndexPath:)] ){
        [delegate tableView:tableView didSelectRowAtIndexPath:[tableView indexPathForCell:self]];
    }
}

@end
