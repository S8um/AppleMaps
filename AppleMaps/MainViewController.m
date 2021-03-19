//
//  ViewController.m
//  AppleMaps
//
//  Created by admin on 19.03.2021.
//

#import "MainViewController.h"
#import <MapKit/MapKit.h>
#import "LocationManager.h"

@interface MainViewController () <MKMapViewDelegate>

@property(nonatomic, weak) MKMapView *mapView;
@property(nonatomic, strong) LocationManager *locationManager;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Map from Apple";
    self.view.backgroundColor = [UIColor systemBlueColor];
    
    //Maps
    MKMapView *map = [[MKMapView alloc]initWithFrame:self.view.bounds];
    self.mapView = map;
    self.mapView.delegate = self;
    
    //Location and region
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(53.7373, 56.9722);
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(coordinate, 1000, 1000);
    [self.mapView setRegion:region animated:YES];
    
    //Marker
    MKPointAnnotation *annotation = [MKPointAnnotation new];
    annotation.title = @"заголовок";
    annotation.subtitle = @"подзаголовок";
    annotation.coordinate = coordinate;
    
    [self.mapView addAnnotation:annotation];
    [self.view addSubview:self.mapView];
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:52.36 longitude:56.93];
    [self addressFromLocation:location];
    
    [self locationFromAddress:@"Surgut"];
    [self locationFromAddress:@"Samara"];
    
    self.locationManager = [LocationManager new];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [self.locationManager start];
}

- (void)viewDidDisappear:(BOOL)animated {
    [self.locationManager stop];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    static NSString *identifier = @"AnnotationId";
    MKAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if (annotationView) {
        annotationView.annotation = annotation;
    } else {
        annotationView = [[MKMarkerAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = YES;
        annotationView.calloutOffset = CGPointMake(0.0, 20.0);
        annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    }
    
    return annotationView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
    NSLog(@"Click");
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    NSLog(@"Clack");
}

#pragma mark - Private

// Location -> Address
- (void)addressFromLocation:(CLLocation *)location {
    CLGeocoder *geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            for (MKPlacemark *placemark in placemarks) {
                NSLog(@"Placemark address - %@", placemark.name);
            }
        }
    }];
    
}

//Address -> Location
- (void)locationFromAddress:(NSString *)address {
    CLGeocoder *geocoder = [CLGeocoder new];
    
    [geocoder geocodeAddressString:address completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        if (placemarks.count > 0) {
            for (MKPlacemark *placemark in placemarks) {
                NSLog(@"Placemark location - %@ %f %f\n %@",
                      placemark.name,
                      placemark.location.coordinate.latitude,
                      placemark.location.coordinate.longitude,
                      placemark.location);
            }
        }
    }];
}

@end
