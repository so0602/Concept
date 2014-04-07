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

#define numberOfEventPage 4

typedef NS_ENUM(NSUInteger, SDEventPageType){
    SDEventPageType_Image,
    SDEventPageType_Overview,
    SDEventPageType_Calendar,
    SDEventPageType_Map,
};

@interface SDEventGridView()
@property (nonatomic, strong) IBOutlet JTListView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIButton *addToCalendarButton;
@property (nonatomic, strong) IBOutlet UILabel *eventName;
@property (nonatomic, strong) IBOutlet UILabel *eventOwner;
@property (nonatomic, strong) IBOutlet UILabel *eventDay;
@property (nonatomic, strong) IBOutlet UILabel *eventMonth;
@property (nonatomic, strong) NSMutableArray *pages;
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
    self.eventDay.font = [UIFont josefinSansFontOfSize:18];
    self.eventMonth.font = [UIFont josefinSansFontOfSize:14];
    self.eventName.font = [UIFont boldSystemFontOfSize:12];
    self.eventOwner.font = [UIFont systemFontOfSize:9];
    
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [_pages removeAllObjects];
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [_pages addObject:view];
    _pageControl.currentPage = 0;
    [_scrollView scrollToItemAtIndex:0 atScrollPosition:JTListViewScrollPositionNone animated:NO];
    
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
            SDEventMapView *mapView = [[NSBundle mainBundle] loadNibNamed:@"SDEventMapView" owner:nil options:nil].lastObject;
            view = mapView;
            break;
        }
        case SDEventPageType_Overview:
        {
            view = [[UIView alloc] init];
            view.backgroundColor = [UIColor redColor];
            break;
        }
        case SDEventPageType_Calendar:
        {
            view = [[UIView alloc] init];
            view.backgroundColor = [UIColor blueColor];
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
    NSLog(@"_pages: %@ | index %lu", _pages, (unsigned long)index);
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
}

@end