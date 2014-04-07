//
//  SDEventMapView.m
//  Somday
//
//  Created by Tao, Steven on 4/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDEventMapView.h"

#import <GoogleMaps/GoogleMaps.h>

@interface SDEventMapView ()
@property (nonatomic, strong) IBOutlet GMSMapView *mapView;
@end

@implementation SDEventMapView

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
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                                longitude:151.20
                                                                     zoom:6];
        self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        _mapView.myLocationEnabled = YES;
        
        // Creates a marker in the center of the map.
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
        marker.title = @"Sydney";
        marker.snippet = @"Australia";
        marker.map = _mapView;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
