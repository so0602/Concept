//
//  SDHomeViewController.m
//  Concept
//
//  Created by Tao, Steven on 3/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDHomeViewController.h"

#import "SDAppDelegate.h"
#import "SDHomeHeaderCollectionViewCell.h"
#import "SDHomeNavigationTitleView.h"
#import "SDBaseGridView.h"
#import "SDUtils.h"

#import "GPUImage.h"

#import "SDTextGridView.h"

#import "UINavigationItem+Addition.h"
#import "UILabel+Addition.h"
#import "UICollectionView+Addition.h"
#import "UIView+Addition.h"
#import "UIImage+ImageEffects.h"
#import "NSNotificationCenter+Name.h"
#import "SDStoryBookGridView.h"

#import "SDMainTranslucentImageView.h"

#import <objc/message.h>

#define WidthForGrid [UIScreen mainScreen].bounds.size.width - 16 // padding = 8
#define HeightForFullyDisplayNavigationBar 57.0f
#define HeightForTriggerNavigationBarAnimation 23.0f

#define Debug_count 30

@interface SDHomeViewController ()
@property (nonatomic) NSMutableArray *dataSource;
@property (nonatomic) IBOutletCollection(UIButton) NSArray *buttons;
@property (nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) SDHomeHeaderCollectionViewCell *headerCollectionViewCell;
//@property (nonatomic) IBOutlet GPUImageView *bgImageView1;
//@property (nonatomic) IBOutlet GPUImageView *bgImageView2;
//@property (nonatomic) GPUImageiOSBlurFilter *bgImageFilter1;
//@property (nonatomic) GPUImageiOSBlurFilter *bgImageFilter2;

@property (nonatomic, strong) UIImage* background;

@property (nonatomic, strong) IBOutlet SDMainTranslucentImageView* backgroundView;

-(void)updateVisibleCollectionViewCellsBackground;
-(void)updateCollectionViewCellBackground:(UICollectionViewCell*)cell;
-(void)mainBackgroundImageWillChange:(NSNotification*)notification;

@end

@implementation SDHomeViewController

static NSString *HeaderCellIdentifier = @"HeaderCollectionViewCell";

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
    
    // Add blur
//    _bgImageView1.clipsToBounds = _bgImageView2.clipsToBounds = YES;
//    _bgImageView1.layer.contentsGravity = _bgImageView2.layer.contentsGravity = kCAGravityTop;
//    _bgImageView1.fillMode = _bgImageView2.fillMode = kGPUImageFillModePreserveAspectRatioAndFill;
//    
//    self.bgImageFilter1 = [[GPUImageiOSBlurFilter alloc] init];
//    _bgImageFilter1.blurRadiusInPixels = 1.0f;
//    [_bgImageFilter1 addTarget:_bgImageView1];
//    
//    self.bgImageFilter2 = [[GPUImageiOSBlurFilter alloc] init];
//    _bgImageFilter2.blurRadiusInPixels = 1.0f;
//    [_bgImageFilter2 addTarget:_bgImageView2];
    
    // Show default place holder for the background
//    GPUImagePicture* picture = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"Debug_Story_1"]];
//    [picture addTarget:_bgImageFilter1];
//    [picture processImage];
//    
//    GPUImagePicture* picture1 = [[GPUImagePicture alloc] initWithImage:[UIImage imageNamed:@"Debug_Story_1"]];
//    [picture1 addTarget:_bgImageFilter2];
//    [picture1 processImage];
    self.background = [UIImage imageNamed:@"Debug_Story_1"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:HomeBackgroundImageChangedNotification object:[UIImage imageNamed:@"Debug_Story_1"]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topMenuWillClose) name:TopMenuWillClose object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mainBackgroundImageWillChange:) name:MainBackgroundImageWillChangeNotification object:nil];
    
    
    {
        // Debug
        self.dataSource = [NSMutableArray new];
        BOOL toggle = TRUE;
        BOOL toggle2 = TRUE;
        int min = SDStoryType_Min;
        int max = SDStoryType_Max + 1;
        for( int i = 0; i <= Debug_count; i++ ){
            SDStory* story = [SDStory new];
            story.type = [NSNumber numberWithInt:min + arc4random() % (max-min)];
            switch( story.type.intValue ){
                case SDStoryType_Photo:
                case SDStoryType_Event:
                    story.imageName = toggle ? @"dump_03.jpg" : @"dump_02.jpg";
                    toggle = !toggle;
                    break;
                case SDStoryType_Voice:
                    story.audioName = toggle2 ? @"1kHz_44100Hz_16bit_05sec.mp3" : @"440Hz_44100Hz_16bit_05sec.mp3";
                    toggle2 = !toggle2;
                    break;
                case SDStoryType_Link:
                    story.websiteLink = @"http://us.playstation.com/ps4/games/metal-gear-solidv-ground-zeroes-ps4.html";
                    story.websiteImage = [UIImage imageNamed:@"dump_website"];
                    story.title = @"World-renowned Kojima Productions showcases the latest masterpiece in the Metal Gear Solid franchise with Metal Gear Solid V: Ground Zeroes.";
                    break;
            }
            story.userIconName = @"dump_user";
            story.userName = @"Thom.Y";
            story.date = [NSDate date];
            story.address = @"AsiaWorld Expo";
            story.likeCount = [NSNumber numberWithInt:arc4random() % 10000];
            story.commentCount = [NSNumber numberWithInt:arc4random() % 10000];
            [_dataSource addObject:story];
            NSLog(@"type: %@", story.type);
        }
    }
    [self mainBackgroundImageWillChange:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self updateVisibleCollectionViewCellsBackground];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updateBackgroundImageToCurrentIndex:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SDBaseGridView *cell = nil;
    
    if( indexPath.row == 0 ){
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:HeaderCellIdentifier forIndexPath:indexPath];
        self.headerCollectionViewCell = (id)cell;
        [self.headerCollectionViewCell addMotionEffect:[SDUtils sharedMotionEffectGroup]];
    }else{
        SDStory* story = [self.dataSource objectAtIndex:indexPath.row];
        cell = [SDBaseGridView gridViewWithStory:story collectionView:collectionView forIndexPath:indexPath];
        cell.story = story;
        [self updateCollectionViewCellBackground:cell];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
        return CGSizeMake(WidthForGrid, [SDHomeHeaderCollectionViewCell heightForCell]);
    else{
        SDStory* story = [self.dataSource objectAtIndex:indexPath.row];
        return CGSizeMake(WidthForGrid, [[SDBaseGridView classWithStory:story] heightForCell]);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{

    UILabel *navigationTitleDayLabel = ((SDHomeNavigationTitleView *)self.navigationItem.titleView).dayLabel;
//    UILabel *navigationTitleDateLabel = ((SDHomeNavigationTitleView *)self.navigationItem.titleView).dateLabel;
    UILabel *headerDayLabel = self.headerCollectionViewCell.labels[0];
    UILabel *headerDateLabel = self.headerCollectionViewCell.labels[1];
    UILabel *headerWeekDayLabel = self.headerCollectionViewCell.labels[2];
    
    CGFloat alphaFactor = (1/(HeightForFullyDisplayNavigationBar-HeightForTriggerNavigationBarAnimation));
//    CGFloat dayFontFactor = ([SDHomeHeaderCollectionViewCell fontForDayLabel].pointSize -navigationTitleDayLabel.font.pointSize)/(HeightForFullyDisplayNavigationBar-HeightForTriggerNavigationBarAnimation);
//    CGFloat dateFontFactor = ([SDHomeHeaderCollectionViewCell fontForDateLabel].pointSize -navigationTitleDateLabel.font.pointSize)/(HeightForFullyDisplayNavigationBar-HeightForTriggerNavigationBarAnimation);
    CGFloat dayFontFactor = ([SDHomeHeaderCollectionViewCell fontForDayLabel].pointSize -navigationTitleDayLabel.font.pointSize)/(HeightForFullyDisplayNavigationBar-HeightForTriggerNavigationBarAnimation);
//    CGFloat dateFontFactor = ([SDHomeHeaderCollectionViewCell fontForDateLabel].pointSize -navigationTitleDateLabel.font.pointSize)/(HeightForFullyDisplayNavigationBar-HeightForTriggerNavigationBarAnimation);
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
//        headerDayLabel.alpha = headerDateLabel.alpha = MAX(0.8f, 1-(alphaFactor*netOffset));
//        headerWeekDayLabel.alpha = ((UIButton*)_buttons[0]).alpha = ((UIButton*)_buttons[1]).alpha = 1-(alphaFactor*netOffset);
        headerDayLabel.alpha = MAX(0.8f, 1-(alphaFactor*netOffset));
        headerDateLabel.alpha = headerWeekDayLabel.alpha = ((UIButton*)_buttons[0]).alpha = ((UIButton*)_buttons[1]).alpha = 1-(alphaFactor*netOffset);
    }
    
    // Font Animation
    if (scrollView.contentOffset.y >= HeightForTriggerNavigationBarAnimation && scrollView.contentOffset.y <= HeightForFullyDisplayNavigationBar) {
        CGFloat netOffset = scrollView.contentOffset.y - HeightForTriggerNavigationBarAnimation;
        [headerDayLabel setFontSize:[SDHomeHeaderCollectionViewCell fontForDayLabel].pointSize-(dayFontFactor*netOffset)];
        //[headerDateLabel setFontSize:[SDHomeHeaderCollectionViewCell fontForDateLabel].pointSize-(dateFontFactor*netOffset)];
    } else {
        [headerDayLabel setFontSize:[SDHomeHeaderCollectionViewCell fontForDayLabel].pointSize];
        //[headerDateLabel setFontSize:[SDHomeHeaderCollectionViewCell fontForDateLabel].pointSize];
    }
    
    
    [self updateVisibleCollectionViewCellsBackground];
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

- (void)topMenuWillClose
{
    [SDUtils rotateBackView:_buttons[1]];
}

-(UIImage*)background{
    SDAppDelegate* delegate = (id)[UIApplication sharedApplication].delegate;
    return delegate.navigationController.backgroundImage;
}
-(void)setBackground:(UIImage *)background{
    SDAppDelegate* delegate = (id)[UIApplication sharedApplication].delegate;
    delegate.navigationController.backgroundImage = background;
}

-(void)updateVisibleCollectionViewCellsBackground{
    NSArray* cells = self.collectionView.visibleCells;
    for( UICollectionViewCell* cell in cells ){
        UIImageView* view = nil;
        SEL selector = @selector(blurBackgroundImageView);
        if( [cell respondsToSelector:selector] ){
            view = objc_msgSend(cell, selector);
        }
        if( view ){
            SDAppDelegate* delegate = (id)[UIApplication sharedApplication].delegate;
            SDMainNavigationController* viewController = delegate.navigationController;
            CGRect frame = [view convertRect:view.frame toView:self.view];
            view.image = [viewController processedBackgroundImageWithFrame:frame];
        }
    }
}

-(void)updateCollectionViewCellBackground:(UICollectionViewCell*)cell{
    UIImageView* view = nil;
    SEL selector = @selector(blurBackgroundImageView);
    if( [cell respondsToSelector:selector] ){
        view = objc_msgSend(cell, selector);
    }
    if( view ){
        SDAppDelegate* delegate = (id)[UIApplication sharedApplication].delegate;
        SDMainNavigationController* viewController = delegate.navigationController;
        CGRect frame = [view convertRect:view.frame toView:self.view];
        view.image = [viewController processedBackgroundImageWithFrame:frame];
    }
}

-(void)mainBackgroundImageWillChange:(NSNotification*)notification{
    SDMainNavigationController* viewController = notification.object;
    if( !viewController ){
        SDAppDelegate* delegate = (id)[UIApplication sharedApplication].delegate;
        viewController = delegate.navigationController;
    }
    self.backgroundView.targetImage = viewController.processedBackgroundImage;
    self.backgroundView.targetView = viewController.currentBackgroundView.superview;
//    [self.backgroundView setNeedsLayout];
    [self updateVisibleCollectionViewCellsBackground];
}

- (void)updateBackgroundImageToCurrentIndex:(BOOL)toCurrentIndex
{
    NSArray *visibleItems = [_collectionView indexPathsForSortedVisibleItems];
    
    if (visibleItems.count > 2 || !toCurrentIndex) {
        NSIndexPath *indexPath;
        
        if (!toCurrentIndex)
            indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        else
            indexPath = visibleItems[visibleItems.count-2];
        
        SDStory* story = [self.dataSource objectAtIndex:indexPath.row];
        UIImage* image = nil;
        if( story.imageName ){
            NSLog(@"name: %@", story.imageName);
            image = [UIImage imageNamed:story.imageName];
        } else {
            NSArray *storyImages = [_dataSource valueForKey:@"imageName"];
            
            NSInteger index = 0;
            NSString *imageName = nil;
            for (int i=(int)indexPath.row;i>=0;i--) {
                if (storyImages[i] != [NSNull null] && ((NSString*)storyImages[i]).length) {
                    imageName = storyImages[i];
                    index = i;
                    break;
                }
            }
            for (int i=(int)indexPath.row;i<storyImages.count;i++) {
                if (storyImages[i] != [NSNull null] && ((NSString*)storyImages[i]).length) {
                    if (!imageName || (imageName && indexPath.row-index>i-indexPath.row)) {
                        imageName = storyImages[i];
                        index = i;
                    }
                    break;
                }
            }
            
            image = imageName?[UIImage imageNamed:imageName]:nil;
        }
        self.background = image;
    }
}

@end
