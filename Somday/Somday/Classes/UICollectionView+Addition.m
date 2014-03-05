//
//  UICollectionView+Addition.m
//  Somday
//
//  Created by Tao, Steven on 3/5/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "UICollectionView+Addition.h"

@implementation UICollectionView (Addition)

- (NSArray *)indexPathsForSortedVisibleItems
{
    NSArray *indexPathsOfVisibleStories = [self indexPathsForVisibleItems];
    NSArray *sortedIndexPaths = [indexPathsOfVisibleStories sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSIndexPath *path1 = (NSIndexPath *)obj1;
        NSIndexPath *path2 = (NSIndexPath *)obj2;
        return [path1 compare:path2];
    }];
    return sortedIndexPaths;
}

@end
