#import <UIKit/UIKit.h>
#import <CoreLocation/CLLocationManagerDelegate.h>
@class ClipView;
@class GMSMapView;
@class GClusterManager;
@class ShadeScrollView;

@interface EXViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate, CLLocationManagerDelegate> {
}
@property(weak, nonatomic) IBOutlet ClipView *clipView;
@property(weak, nonatomic) IBOutlet ShadeScrollView *scrollView;

@property(nonatomic, strong) NSMutableArray *cardViews;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(strong, nonatomic) IBOutlet GMSMapView *mapView;
@property(nonatomic) BOOL hasFoundInitialLocation;
@property(nonatomic, strong) GClusterManager *clusterManager;

@property(nonatomic, strong) NSMutableArray *viewControllers;
@end