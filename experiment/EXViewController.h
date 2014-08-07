#import <UIKit/UIKit.h>

@class ClipView;
@class MKMapView;

@interface EXViewController : UIViewController <UIGestureRecognizerDelegate, UIScrollViewDelegate, MKMapViewDelegate> {
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property(weak, nonatomic) IBOutlet ClipView *clipView;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property(nonatomic, strong) NSMutableArray *cardViews;
@property(nonatomic) BOOL swiping;
@property(nonatomic) BOOL cardRevealed;
@property(nonatomic) BOOL scrolling;
@end