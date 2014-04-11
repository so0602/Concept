//
//  SDRecentChatsViewController.m
//  Somday
//
//  Created by Tao, Steven on 4/11/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDRecentChatsViewController.h"

#import "SDAppDelegate.h"
#import "SDChat.h"
#import "SDUser.h"
#import "SDMessage.h"
#import "ArrayDataSource.h"
#import "SDChatListTableViewCell.h"

@interface SDRecentChatsViewController ()

@property (nonatomic,strong) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *addButton;
@property (nonatomic,strong) IBOutlet UIButton *createGroupButton;
@property (nonatomic,strong) IBOutlet UIButton *hiddenMsgButton;
@property (nonatomic,strong) IBOutlet UITableView *tableView;
@property (nonatomic,strong) ArrayDataSource *arrayDataSource;
@property (nonatomic,strong) NSMutableArray *dataSource;

@end

@implementation SDRecentChatsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self update];
    [self setupTableView];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

#pragma mark - Private

- (void)update
{
    self.dataSource = [NSMutableArray new];
    for (int i = 0; i < 50; i++) {
        SDUser *user = [SDUser new];
        user.name = @"Freddy";
        SDMessage *lastMessage = [SDMessage new];
        lastMessage.message = @"HIIIIIIII";
        SDChat *chat = [[SDChat alloc] init];
        chat.users = @[user];
        chat.lastMessage = lastMessage;
        chat.date = [NSDate date];
        [_dataSource addObject:chat];
    }
}

- (IBAction)actionForItem:(id)sender
{
    if (sender==_backButton) {
        [((SDAppDelegate *)[UIApplication sharedApplication].delegate).mainViewController setPaneState:MSDynamicsDrawerPaneStateClosed animated:TRUE allowUserInterruption:TRUE completion:nil];
    } else if (sender==_addButton) {
        
    } else if (sender==_createGroupButton) {
        
    } else if (sender==_hiddenMsgButton) {
        
    }
}

- (void)setupTableView
{
    if (!self.arrayDataSource) {
        TableViewCellConfigureBlock configureCell = ^(SDChatListTableViewCell *cell, SDChat *chat) {
            cell.nameLabel.text = chat.isGroup?chat.groupName:((SDUser*)chat.users[0]).name;
            cell.lastMessageLabel.text = ((SDMessage*)chat.lastMessage).message;
//            cell.dateLabel.text = chat.date;
        };
        
        TableViewCellEditBlock editCell = ^(UITableViewCellEditingStyle editingStyle, NSDictionary *chat) {

        };
        
        self.arrayDataSource = [[ArrayDataSource alloc] initWithItems:self.dataSource
                                                       cellIdentifier:NSStringFromClass([SDChatListTableViewCell class])
                                                   configureCellBlock:configureCell
                                                        editCellBlock:editCell];
        
        self.tableView.dataSource = self.arrayDataSource;
    } else {
        self.arrayDataSource.items = self.dataSource;
    }
    [self.tableView reloadData];
}

#pragma mark UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end
