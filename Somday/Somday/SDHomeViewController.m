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

#define Debug_count 500

@interface SDHomeViewController ()
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) IBOutlet GPUImageView *bgImageView1;
@property (nonatomic) IBOutlet GPUImageView *bgImageView2;
@property (nonatomic) SDHomeHeaderCollectionViewCell *headerCollectionViewCell;
@property (nonatomic) GPUImageiOSBlurFilter *bgImageFilter1;
@property (nonatomic) GPUImageiOSBlurFilter *bgImageFilter2;
@property (nonatomic) BOOL isbgImageAnimating;
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
//    [_collectionView addMotionEffect:[SDUtils sharedMotionEffectGroup]];
    
    // Add blur
    _bgImageView1.clipsToBounds = _bgImageView2.clipsToBounds = YES;
    _bgImageView1.layer.contentsGravity = _bgImageView2.layer.contentsGravity = kCAGravityTop;
    
    self.bgImageFilter1 = [[GPUImageiOSBlurFilter alloc] init];
    _bgImageFilter1.blurRadiusInPixels = 1.0f;
    [_bgImageFilter1 addTarget:_bgImageView1];
    
    self.bgImageFilter2 = [[GPUImageiOSBlurFilter alloc] init];
    _bgImageFilter2.blurRadiusInPixels = 1.0f;
    [_bgImageFilter2 addTarget:_bgImageView2];
    
    // Show default place holder for the background
    GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"Debug_Story_1"]];
    [picture addTarget:_bgImageFilter1];
    [picture processImage];
    GPUImagePicture* picture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"Debug_Story_1"]];
    [picture1 addTarget:_bgImageFilter2];
    [picture1 processImage];
    
    
    
    // Debug
    BOOL toggle = YES;
    self.dataSource = [NSMutableArray new];
    for (int i = 0; i <= Debug_count; i++) {
        [_dataSource addObject:toggle?@"dump_bg":@"Debug_Story_2"];
        toggle = !toggle;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateBackgroundImageToCurrentIndex:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -


- (void)updateBackgroundImageToCurrentIndex:(BOOL)toCurrentIndex
{
    if (_isbgImageAnimating)
        return;
    
    NSArray *visibleItems = [_collectionView indexPathsForSortedVisibleItems];
    if (visibleItems.count > 2 || !toCurrentIndex) {
        _isbgImageAnimating = YES;
        NSIndexPath *index;

        if (!toCurrentIndex)
            index = [NSIndexPath indexPathForRow:0 inSection:0];
        else
            index = visibleItems[visibleItems.count-2];
        
        _bgImageView2.alpha = 0.0f;
        
        GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:[_dataSource objectAtIndex:index.row]]];
        [picture addTarget:_bgImageFilter2];
        [picture processImage];
        
        [UIView animateWithDuration:0.4 animations:^{
            _bgImageView2.alpha = 1.0f;
        } completion:^(BOOL finished) {
            _isbgImageAnimating = NO;
            GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:[_dataSource objectAtIndex:index.row]]];
            [picture addTarget:_bgImageFilter1];
            [picture processImage];
            
        }];
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
    return Debug_count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isFirstRow = indexPath.row==0;
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:isFirstRow?HeaderCellIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (!isFirstRow) {
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:[_dataSource objectAtIndex:indexPath.row]]];
    } else {
        self.headerCollectionViewCell = (SDHomeHeaderCollectionViewCell*)cell;
        [self.headerCollectionViewCell addMotionEffect:[SDUtils sharedMotionEffectGroup]];
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
        self.navigationController.navigationBar.alpha = MIN(0.8f,alphaFactor*netOffset);
        headerDayLabel.alpha = headerDateLabel.alpha = MAX(0.8f, 1-(alphaFactor*netOffset));
        headerWeekDayLabel.alpha = ((UIButton*)_buttons[0]).alpha = ((UIButton*)_buttons[1]).alpha = 1-(alphaFactor*netOffset);
    }
    
    // Font Animation
    if (scrollView.contentOffset.y > 0 && scrollView.contentOffset.y <= HeightForFullyDisplayNavigationBar) {
        [headerDayLabel setFontSize:[SDHomeHeaderCollectionViewCell fontForDayLabel].pointSize-(dayFontFactor*scrollView.contentOffset.y)];
        [headerDateLabel setFontSize:[SDHomeHeaderCollectionViewCell fontForDateLabel].pointSize-(dateFontFactor*scrollView.contentOffset.y)];
    } else {
        [headerDayLabel setFontSize:[SDHomeHeaderCollectionViewCell fontForDayLabel].pointSize];
        [headerDateLabel setFontSize:[SDHomeHeaderCollectionViewCell fontForDateLabel].pointSize];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        if (scrollView.contentOffset.y < HeightForFullyDisplayNavigationBar) {
            [scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        }
        
        [self updateBackgroundImageToCurrentIndex:YES];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateBackgroundImageToCurrentIndex:YES];
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView
{
    [self updateBackgroundImageToCurrentIndex:NO];

}

@end
