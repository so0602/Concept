//
//  SDEventMapView.m
//  Somday
//
//  Created by Tao, Steven on 4/4/14.
//  Copyright (c) 2014 Freddy So. All rights reserved.
//

#import "SDEventMapView.h"
#import "SDDirectionService.h"

@interface SDEventMapView ()
@property (nonatomic, strong) NSMutableArray *waypointStrings;
@property (nonatomic, strong) IBOutlet UIView *mapConentView;
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
        self.waypoints = [[NSMutableArray alloc]init];
        self.waypointStrings = [[NSMutableArray alloc]init];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - public

- (void)reset
{
    [_waypoints removeAllObjects];
    [_waypointStrings removeAllObjects];
}

- (void)setLocation:(NSString *)name latitude:(float)latitude longitude:(float)longitude zoom:(float)zoom
{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:zoom];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    //_mapView.delegate = self;
    _mapView.myLocationEnabled = YES;
    _mapView.userInteractionEnabled = NO;
    _mapView.frame = self.mapConentView.bounds;
    [self.mapConentView addSubview:_mapView];

    // Creates a marker in the center of the map.
    GMSMarker *marker = [[GMSMarker alloc] init];
    marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    marker.title = name;
    marker.snippet = name;
    marker.map = _mapView;
    
    [_waypoints addObject:marker];
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                latitude,longitude];
    [_waypointStrings addObject:positionString];
    
    NSLog(@"location: %@", _mapView.myLocation);
    GMSMarker *cLocationMarker = [[GMSMarker alloc] init];
    cLocationMarker.icon = [GMSMarker markerImageWithColor:[UIColor colorWithHexString:@"498ede"]];
    cLocationMarker.position = CLLocationCoordinate2DMake(22.305137229473541, 114.1782645508647);  //22.305137229473541, 114.1782645508647
    cLocationMarker.title = @"Your location";
    cLocationMarker.snippet = @"Your location";
    cLocationMarker.map = _mapView;
    positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                cLocationMarker.position.latitude,cLocationMarker.position.longitude];
    [_waypointStrings addObject:positionString];
    
    [_waypoints addObject:cLocationMarker];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self requestDirection];
    });

}

- (void)addDirections:(NSDictionary *)json
{
    NSDictionary *routes = [json objectForKey:@"routes"][0];
    
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.strokeWidth = 2;
    polyline.strokeColor = [UIColor colorWithHexString:@"1fb3f9"];
    polyline.map = _mapView;
}

#pragma mark - private
- (void)requestDirection
{
    NSString *sensor = @"false";
    NSArray *parameters = [NSArray arrayWithObjects:sensor, _waypointStrings,
                           nil];
    NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
    NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                      forKeys:keys];
    SDDirectionService *mds=[[SDDirectionService alloc] init];
    SEL selector = @selector(addDirections:);
    [mds setDirectionsQuery:query
               withSelector:selector
               withDelegate:self];
}

#pragma mark - GMSMapViewDelegate

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:
(CLLocationCoordinate2D)coordinate
{
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                                                 coordinate.latitude,
                                                                 coordinate.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.map = _mapView;
    [_waypoints addObject:marker];
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                coordinate.latitude,coordinate.longitude];
    [_waypointStrings addObject:positionString];
    if([_waypoints count]>1){
        NSString *sensor = @"false";
        NSArray *parameters = [NSArray arrayWithObjects:sensor, _waypointStrings,
                               nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                          forKeys:keys];
        SDDirectionService *mds=[[SDDirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
    }
}

@end
