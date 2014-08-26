#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
#import <MapKit/MapKit.h>
#import "SpotSelectionDelegate.h"

@class ShadeView;
@class ShadeScrollView;
@class MKClusterManager;

@interface EXViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate, CLLocationManagerDelegate, SpotSelectionDelegate> {
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shadeHeightConstraint;
@property(weak, nonatomic) IBOutlet ShadeView *clipView;
@property(weak, nonatomic) IBOutlet ShadeScrollView *scrollView;

@property(nonatomic, strong) NSMutableArray *cardViews;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(strong, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic) BOOL hasFoundInitialLocation;
@property(nonatomic, strong) MKClusterManager *clusterManager;

@property(nonatomic, strong) NSMutableArray *viewControllers;
@end