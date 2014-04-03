//
//  SDEventGridView.m
//  Somday
//
//  Created by Tao, Steven on 4/3/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDEventGridView.h"
#import "JTListView.h"

#define numberOfEventPage 4

@interface SDEventGridView()
@property (nonatomic, strong) IBOutlet JTListView *scrollView;
@property (nonatomic, strong) IBOutlet UIPageControl *pageControl;
@property (nonatomic, strong) IBOutlet UIButton *addToCalendarButton;
@property (nonatomic, strong) IBOutlet UILabel *eventName;
@property (nonatomic, strong) IBOutlet UILabel *eventOwner;
@property (nonatomic, strong) IBOutlet UILabel *eventDay;
@property (nonatomic, strong) IBOutlet UILabel *eventMonth;
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

- (void)awakeFromNib{
    [super awakeFromNib];
    self.scrollView.layout = JTListViewLayoutLeftToRight;
    self.eventDay.font = [UIFont josefinSansFontOfSize:18];
    self.eventMonth.font = [UIFont josefinSansFontOfSize:14];
    self.eventName.font = [UIFont boldSystemFontOfSize:12];
    self.eventOwner.font = [UIFont systemFontOfSize:9];
    
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
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, listView.frame.size.width, listView.frame.size.height)];
    view.backgroundColor = !index?[UIColor clearColor]:[UIColor redColor];
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
