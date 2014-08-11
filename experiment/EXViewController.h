#import <UIKit/UIKit.h>

@class ClipView;
@class CLLocationManager;
@class GMSMapView;
@class GClusterManager;

@interface EXViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate, CLLocationManagerDelegate> {
}
@property(weak, nonatomic) IBOutlet ClipView *clipView;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic, strong) NSMutableArray *cardViews;
@property(nonatomic) BOOL swiping;
@property(nonatomic) BOOL cardRevealed;
@property(nonatomic) BOOL scrolling;
@property(nonatomic, strong) CLLocationManager *locationManager;
@property(strong, nonatomic) IBOutlet GMSMapView *mapView;
@property(nonatomic) BOOL hasFoundInitialLocation;
@property(nonatomic, strong) GClusterManager *clusterManager;
@end