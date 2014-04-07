//
//  SDEventMapView.h
//  Somday
//
//  Created by Tao, Steven on 4/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface SDEventMapView : UIView <GMSMapViewDelegate>
@property (nonatomic, strong) NSMutableArray *waypoints;
@property (nonatomic, strong) GMSMapView *mapView;
- (void)reset;
- (void)setLocation:(NSString *)name latitude:(float)latitude longitude:(float)longitude zoom:(float)zoom;
@end
