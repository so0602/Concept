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

#import "GPUImage.h"
#import "UINavigationItem+Addition.h"
#import "UILabel+Addition.h"
#import "UICollectionView+Addition.h"
#import <objc/message.h>

#define WidthForGrid [UIScreen mainScreen].bounds.size.width - 16 // padding = 8
#define HeightForFullyDisplayNavigationBar 57.0f
#define HeightForTriggerNavigationBarAnimation 23.0f

@interface SDHomeViewController ()
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) IBOutlet GPUImageView *bgImageView;
@property (nonatomic) SDHomeHeaderCollectionViewCell *headerCollectionViewCell;
@property (nonatomic) GPUImageiOSBlurFilter* blurFilter;
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
    
    // Add blur
    self.bgImageView.clipsToBounds = TRUE;
    self.bgImageView.layer.contentsGravity = kCAGravityTop;
    self.blurFilter = [[GPUImageiOSBlurFilter alloc] init];
    self.blurFilter.blurRadiusInPixels = 1.0f;
    [self.blurFilter addTarget:self.bgImageView];
    
    // Debug
    BOOL toggle = NO;
    self.dataSource = [NSMutableArray new];
    for (int i = 0; i <= 10; i++) {
        [_dataSource addObject:toggle?@"dump_bg":@"Debug_Story_2"];
        toggle = !toggle;
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"Debug_Story_1"]];
    [picture addTarget:self.blurFilter];
    [picture processImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -

- (void)updateBackgroundImage
{
    NSArray *visibleItems = [_collectionView indexPathsForSortedVisibleItems];
    if (visibleItems.count > 2) {
        NSIndexPath *index = visibleItems[visibleItems.count-2];
        NSLog(@"row: %li", (long)index.row);

        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:[_dataSource objectAtIndex:index.row]]];
        [picture addTarget:self.blurFilter];
        [picture processImage];        
    }
    

}

#pragma mark - IBAction

- (IBAction)actionForItem:(id)sender
{
    switch ([_buttons indexOfObject:sender]) {
        case 0:{
            // menu button
            SEL selector = self.navigationItem.leftBarButtonItem.action;
            UIViewController *_target = self.navigationItem.leftBarButtonItem.target;
            objc_msgSend(_target, selector, self.navigationItem.leftBarButtonItem);
        }
            break;
        case 1:{
            // add button
            SEL selector = self.navigationItem.rightBarButtonItem.action;
            UIViewController *_target = self.navigationItem.rightBarButtonItem.target;
            objc_msgSend(_target, selector, self.navigationItem.rightBarButtonItem);
            
            [SDUtils rotateView:sender];
        }
            break;
        default:
            break;
    }
}

#pragma mark - UICollectionViewDataSource Methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 10;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isFirstRow = indexPath.row==0;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:isFirstRow?HeaderCellIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!isFirstRow) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[_dataSource objectAtIndex:indexPath.row]]];
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
    
    // Alpha Animation
    if (scrollView.contentOffset.y <= HeightForTriggerNavigationBarAnimation) {
        self.navigationController.navigationBarHidden = YES;
        self.navigationController.navigationBar.alpha = 0.0f;
        headerDayLabel.alpha = headerDateLabel.alpha = headerWeekDayLabel.alpha = ((UIButton*)_buttons[0]).alpha = ((UIButton*)_buttons[1]).alpha = 1.0f;
    } else if (scrollView.contentOffset.y >= HeightForFullyDisplayNavigationBar) {
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.alpha = 1.0f;
        headerDayLabel.alpha = headerDateLabel.alpha = headerWeekDayLabel.alpha = ((UIButton*)_buttons[0]).alpha = ((UIButton*)_buttons[1]).alpha = 0.0f;
    } else {
        self.navigationController.navigationBarHidden = NO;
        self.navigationController.navigationBar.alpha = alphaFactor*netOffset;
        headerDayLabel.alpha = headerDateLabel.alpha = 1.0f;
        headerWeekDayLabel.alpha = ((UIButton*)_buttons[0]).alpha = ((UIButton*)_buttons[1]).alpha = 1-(alphaFactor*netOffset);
    }
    
    // Font Animation
    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y <= HeightForFullyDisplayNavigationBar) {
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
        
        [self updateBackgroundImage];
        
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateBackgroundImage];
}

@end
