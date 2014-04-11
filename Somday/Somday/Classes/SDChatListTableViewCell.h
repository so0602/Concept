//
//  SDChatListTableViewCell.h
//  Somday
//
//  Created by Tao, Steven on 4/11/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SDChatListTableViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *lastUserLabel;
@property (nonatomic,strong) IBOutlet UILabel *lastMessageLabel;
@property (nonatomic,strong) IBOutlet UILabel *dateLabel;
@property (nonatomic,strong) IBOutlet UIImageView *profileImageView;
@property (nonatomic,strong) IBOutlet UIImageView *unreadImageView;

@end
