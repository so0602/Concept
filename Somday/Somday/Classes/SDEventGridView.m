//
//  SDEventGridView.m
//  Somday
//
//  Created by Tao, Steven on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDEventGridView.h"
#import "JTListView.h"
#import "SDEventMapView.h"
#import "SDEventOverviewView.h"
#import "SDTranslucentImageView.h"

#define numberOfEventPage 4

typedef NS_ENUM(NSUInteger, SDEventPageType){
    SDEventPageType_Image,
    SDEventPageType_Overview,
    SDEventPageType_Calendar,
    SDEventPageType_Map,
};

@interface SDBaseGridView ()

@property (nonatomic, strong) IBOutlet UIImageView *backgroundImageView;

@end

@interface SDEventGridView()<JTListViewDelegate>
@property (nonatomic, strong) IBOutlet JTListView *scrollView;
@property (nonatomic, strong) IBOutlet SDTranslucentImageView* scrollBackgroundImageView;
@property (nonatomic, strong) IBOutlet SDTranslucentImageView* bottomImageView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIButton *addToCalendarButton;
@property (nonatomic, strong) IBOutlet UILabel *eventName;
@property (nonatomic, strong) IBOutlet UILabel *eventOwner;
@property (nonatomic, strong) IBOutlet UILabel *eventDay;
@property (nonatomic, strong) IBOutlet UILabel *eventMonth;
@property (nonatomic, strong) SDEventMapView * mapView;
@property (nonatomic, strong) NSMutableArray *pages;

@property (nonatomic, strong) IBOutlet UIImage *backgroundImageViewImage;

@end

@interface SDTranslucentImageView ()

@property (nonatomic) BOOL keepUpdate;

@end

@implementation SDEventGridView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.pages = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.scrollView.layout = JTListViewLayoutLeftToRight;
    
    [self.eventDay changeFont:SDFontFamily_JosefinSans style:SDFontStyle_Regular];
    [self.eventMonth changeFont:SDFontFamily_JosefinSans style:SDFontStyle_Regular];
    [self.eventName changeFont:SDFontFamily_Montserrat style:SDFontStyle_Bold];
    [self.eventOwner changeFont:SDFontFamily_Montserrat style:SDFontStyle_Regular];
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [_pages removeAllObjects];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [_pages addObject:view];
    _pageControl.currentPage = 0;
    [_mapView reset];
    [_scrollView scrollToItemAtIndex:0 atScrollPosition:JTListViewScrollPositionNone animated:NO];
    
    self.backgroundImageViewImage = nil;
    
    self.scrollBackgroundImageView.x = self.scrollView.width;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - JTListViewDataSource

- (NSUInteger)numberOfItemsInListView:(JTListView *)listView
{
    return numberOfEventPage;
}

- (UIView *)listView:(JTListView *)listView viewForItemAtIndex:(NSUInteger)index
{
    
    if ((_pages.count > index) && [_pages objectAtIndex:index])
        return [_pages objectAtIndex:index];
    
    UIView *view = nil;
    
    switch (index) {
        case SDEventPageType_Map:
        {
            SDEventMapView * mapView = [[NSBundle mainBundle] loadNibNamed:@"SDEventMapView" owner:nil options:nil].lastObject;
//            [mapView setLocation:@"ICC" latitude:22.303153 longitude:114.159900 zoom:13];
            self.mapView = mapView;
            view = mapView;
            break;
        }
        case SDEventPageType_Overview:
        {
            SDEventOverviewView* overviewView = [[NSBundle mainBundle] loadNibNamed:@"SDEventOverviewView" owner:nil options:nil].lastObject;
            overviewView.story = self.story;
            view = overviewView;
            break;
        }
        case SDEventPageType_Calendar:
        {
            view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            break;
        }
        case SDEventPageType_Image:
        default:
        {
            view = [[UIView alloc] init];
            view.backgroundColor = [UIColor clearColor];
            break;
        }
    }
    view.frame = CGRectMake(0, 0, listView.frame.size.width, listView.frame.size.height);
    [_pages addObject:view];
    return view;
}

#pragma mark - JTListViewDelegate
- (CGFloat)listView:(JTListView *)listView widthForItemAtIndex:(NSUInteger)index
{
    return CGRectGetWidth(listView.frame);
}

- (CGFloat)listView:(JTListView *)listView heightForItemAtIndex:(NSUInteger)index
{
    return CGRectGetHeight(listView.frame);
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
	NSInteger fPage = roundf(scrollView.contentOffset.x/pageWidth);
	self.pageControl.currentPage = fPage;
    
    if( scrollView.contentOffset.x > 0 && scrollView.contentOffset.x < scrollView.width ){
        self.scrollBackgroundImageView.x = scrollView.width - scrollView.contentOffset.x;
//        if( !self.scrollBackgroundImageView.targetImage ){
//            if( !self.backgroundImageViewImage ){
//                self.backgroundImageViewImage = self.backgroundImageView.convertViewToImage.defaultBlur;
//            }
//            self.scrollBackgroundImageView.targetView = self.backgroundImageView;
//            self.scrollBackgroundImageView.targetImage = self.backgroundImageViewImage;
//        }
//        self.scrollBackgroundImageView.keepUpdate = TRUE;
    }
    if (scrollView.contentOffset.x == scrollView.contentSize.width - CGRectGetWidth(scrollView.frame)) {
        if (!_mapView.waypoints.count)
            [_mapView setLocation:@"ICC" latitude:22.303153 longitude:114.159900 zoom:13];
    }
}

@end
