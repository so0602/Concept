//
//  SDHomeViewController.m
//  Concept
//
//  Created by Tao, Steven on 3/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDHomeViewController.h"
#import "SDHomeHeaderCollectionViewCell.h"
#import "SDHomeNavigationTitleView.h"
#import "UINavigationItem+Addition.h"
#import "UILabel+Addition.h"

#define WidthForGrid [UIScreen mainScreen].bounds.size.width - 16 // padding = 8
#define HeightForFullyDisplayNavigationBar 57.0f
#define HeightForTriggerNavigationBarAnimation 23.0f

@interface SDHomeViewController ()
@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) IBOutlet UIImageView *bgImageView;
@property (nonatomic) SDHomeHeaderCollectionViewCell *headerCollectionViewCell;
@end

@implementation SDHomeViewController

static NSString *HeaderCellIdentifier = @"HeaderCollectionViewCell";
static NSString *CellIdentifier = @"CollectionViewCell";

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
    self.navigationController.navigationBarHidden = YES;
    self.navigationController.navigationBar.alpha = 0.0f;
    [self.navigationItem showSDTitleView];
    [_collectionView addMotionEffect:[SDUtils sharedMotionEffectGroup]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDataSource Methods

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 100;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isFirstRow = indexPath.row==0;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:isFirstRow?HeaderCellIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!isFirstRow) {
        cell.backgroundColor = [UIColor grayColor];
    } else {
        self.headerCollectionViewCell = (SDHomeHeaderCollectionViewCell*)cell;
    }
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return CGSizeMake(WidthForGrid, [SDHomeHeaderCollectionViewCell heightForCell]);
    else
        return CGSizeMake(WidthForGrid, WidthForGrid); // TODO: Hardcode for now. Should get the height from the collectionViewCell.
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    UILabel *navigationTitleDayLabel = ((SDHomeNavigationTitleView *)self.navigationItem.titleView).dayLabel;
    UILabel *navigationTitleDateLabel = ((SDHomeNavigationTitleView *)self.navigationItem.titleView).dateLabel;
    UILabel *headerDayLabel = self.headerCollectionViewCell.labels[0];
    UILabel *headerDateLabel = self.headerCollectionViewCell.labels[1];
    UILabel *headerWeekDayLabel = self.headerCollectionViewCell.labels[2];
    
    CGFloat alphaFactor = (1/(HeightForFullyDisplayNavigationBar-HeightForTriggerNavigationBarAnimation));
//    CGFloat dayFontFactor = ([SDHomeHeaderCollectionViewCell fontForDayLabel].pointSize -navigationTitleDayLabel.font.pointSize)/(HeightForFullyDisplayNavigationBar-HeightForTriggerNavigationBarAnimation);
//    CGFloat dateFontFactor = ([SDHomeHeaderCollectionViewCell fontForDateLabel].pointSize -navigationTitleDateLabel.font.pointSize)/(HeightForFullyDisplayNavigationBar-HeightForTriggerNavigationBarAnimation);
    CGFloat dayFontFactor = ([SDHomeHeaderCollectionViewCell fontForDayLabel].pointSize -navigationTitleDayLabel.font.pointSize)/(HeightForFullyDisplayNavigationBar);
    CGFloat dateFontFactor = ([SDHomeHeaderCollectionViewCell fontForDateLabel].pointSize -navigationTitleDateLabel.font.pointSize)/(HeightForFullyDisplayNavigationBar);
    CGFloat netOffset = scrollView.contentOffset.y-HeightForTriggerNavigationBarAnimation;
    
    NSLog(@"Offset: %.2f", scrollView.contentOffset.y);
    if (scrollView.contentOffset.y <= HeightForTriggerNavigationBarAnimation) {
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.navigationBar.alpha = 0.0f;
        headerDayLabel.alpha = headerDateLabel.alpha = headerWeekDayLabel.alpha = 0.9f;
        [headerDayLabel setFontSize:MIN([SDHomeHeaderCollectionViewCell fontForDayLabel].pointSize, [SDHomeHeaderCollectionViewCell fontForDayLabel].pointSize-(dayFontFactor*scrollView.contentOffset.y))];
        [headerDateLabel setFontSize:MIN([SDHomeHeaderCollectionViewCell fontForDateLabel].pointSize, [SDHomeHeaderCollectionViewCell fontForDateLabel].pointSize-(dateFontFactor*scrollView.contentOffset.y))];
    } else if (scrollView.contentOffset.y >= HeightForFullyDisplayNavigationBar) {
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.alpha = 1.0f;
        headerDayLabel.alpha = headerDateLabel.alpha = headerWeekDayLabel.alpha = 0.0f;
    } else {
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.alpha = alphaFactor*netOffset;
        headerDayLabel.alpha = headerDateLabel.alpha = 1.0f;
        headerWeekDayLabel.alpha = 1-(alphaFactor*netOffset);
        [headerDayLabel setFontSize:[SDHomeHeaderCollectionViewCell fontForDayLabel].pointSize-(dayFontFactor*scrollView.contentOffset.y)];
        [headerDateLabel setFontSize:[SDHomeHeaderCollectionViewCell fontForDateLabel].pointSize-(dateFontFactor*scrollView.contentOffset.y)];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        if (scrollView.contentOffset.y < HeightForFullyDisplayNavigationBar) {
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
    }
}

@end