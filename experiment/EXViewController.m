#import <MapKit/MapKit.h>
#import <Google-Maps-iOS-SDK/GoogleMaps/GMSMapView.h>
#import <Google-Maps-iOS-Utils-QuadTree/GClusterManager.h>
#import "EXViewController.h"
#import "ClipView.h"
#import "DummyAnnotations.h"
#import "NonHierarchicalDistanceBasedAlgorithm.h"
#import "MyClusterRenderer.h"
#import "MyClusterManager.h"
#import "ShadeTableViewController.h"

@implementation EXViewController

const int MAX_ZOOM_LEVEL = 19;
const int MIN_ZOOM_LEVEL = 17;

typedef enum {
    UP, DOWN
} direction;

- (void)viewDidLoad {
    self.clipView.scrollView = self.scrollView;
    self.cardRevealed = NO;

    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.userInteractionEnabled = NO;
    self.scrollView.canCancelContentTouches = NO;
    [self.scrollView setDelegate:self];

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cardPanned:)];
    [recognizer setDelegate:self];
    [self.scrollView addGestureRecognizer:recognizer];

    [self buildCards];
    [self adjustCardSizes];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;

    [self.locationManager startUpdatingLocation];

    self.clusterManager = [[MyClusterManager alloc] init];
    [self.clusterManager setMapView:self.mapView];
    [self.clusterManager setClusterAlgorithm:[[NonHierarchicalDistanceBasedAlgorithm alloc] init]];
    [self.clusterManager setClusterRenderer:[[MyClusterRenderer alloc] initWithMapView:self.mapView]];

    [self.mapView setMinZoom:MIN_ZOOM_LEVEL maxZoom:MAX_ZOOM_LEVEL];
    [self.mapView setMyLocationEnabled:YES];
    [self.mapView setBuildingsEnabled:NO];
    [self.mapView setIndoorEnabled:NO];
    [self.mapView setDelegate:self.clusterManager];
    [self.mapView bringSubviewToFront:self.clipView];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (!self.hasFoundInitialLocation) {
        self.hasFoundInitialLocation = YES;
        [self.mapView setCamera:[GMSCameraPosition cameraWithLatitude:newLocation.coordinate.latitude
                                                            longitude:newLocation.coordinate.longitude
                                                                 zoom:MIN_ZOOM_LEVEL]];
        [[DummyAnnotations new] addAnnotations:self.clusterManager around:newLocation.coordinate];
        [[self clusterManager] cluster];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
    region.center = mapView.userLocation.coordinate;
    region.span = MKCoordinateSpanMake(0.001, 0.001);

    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:NO];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideCard:NO];
}

- (void)cardPanned:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {self.swiping = NO;}

    CGPoint v = [gesture velocityInView:self.scrollView];
    const int THRESHOLD = 100;
    if (v.y <= -THRESHOLD && !self.swiping && !self.cardRevealed) {
        self.swiping = YES;
        [gesture cancelsTouchesInView];
        [self revealCard];
    }
    else if (v.y >= THRESHOLD && !self.swiping && self.cardRevealed) {
        self.swiping = YES;
        [gesture cancelsTouchesInView];
        [self hideCard:YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchLocation = [touch locationInView:self.scrollView];
    for (UIView *view in self.cardViews) {
        if (CGRectContainsPoint(view.frame, touchLocation)) {
            return YES;
        }
    }
    return NO;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)revealCard {
    self.cardRevealed = YES;
    [self moveCard:UP animate:YES];
}

- (void)hideCard:(BOOL)animate {
    if (self.cardRevealed) {
        self.cardRevealed = NO;
        [self moveCard:DOWN animate:animate];
    }
}

- (void)moveCard:(direction)direction animate:(BOOL)animate {
    int page = (int) (self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    UITableView *card = self.cardViews[page];
    int heightToMove = (int) ([self cardRowHeight] * [card numberOfRowsInSection:0] - [self cardRowHeight]);
    int maxHeight = (int) (self.view.frame.size.height - [self cardRowHeight]);
    int boundHeightToMove = MIN(maxHeight, heightToMove);

    int yTranslation = direction == UP ? -1 * boundHeightToMove : boundHeightToMove ;
    if (animate) {
        [UIView animateWithDuration:0.15 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            card.center = CGPointMake(card.center.x, card.center.y + yTranslation);
        }                completion:^(BOOL finished) {
        }];
    }
    else {
        card.center = CGPointMake(card.center.x, card.center.y + yTranslation);
    }
}

- (void)buildCards {
    const int CARD_COUNT = 5;
    self.cardViews = [@[] mutableCopy];
    UIStoryboard *cardBoard = [UIStoryboard storyboardWithName:@"StockCard" bundle:nil];
    ShadeTableViewController *controller = [cardBoard instantiateViewControllerWithIdentifier:@"stockCards"];
    self.viewControllers = [@[] mutableCopy];
    for (int i = 0; i < CARD_COUNT; i++) {
        ShadeTableViewController *individualController = [[ShadeTableViewController alloc] init];
        [self.viewControllers addObject:individualController];

        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0, 0) style:UITableViewStylePlain];
        int count = 3 + i * 5;
        [individualController setItems:[self textArrayOfSize:count]];
        [tableView setDataSource:individualController];
        [tableView setDelegate:individualController];
        [self.cardViews addObject:tableView];
        [self.scrollView addSubview:tableView];
    }
}

- (NSArray *)textArrayOfSize:(int)size {
    NSMutableArray *array = [@[] mutableCopy];
    for (int i = 0; i < size; i++) {
        [array addObject:[@"data" stringByAppendingString:[NSString stringWithFormat:@"%i", i]]];
    }
    return array;
}

- (void)adjustCardSizes {
    float rowHeight = [self cardRowHeight];
    float scrollViewWidth = self.scrollView.frame.size.width;
    int spaceWidth = 5;
    float cardWidth = scrollViewWidth - 2 * spaceWidth;
    int subViewIndex = 0;
    for (UITableView *view in self.cardViews) {
        int rows = [[view dataSource] tableView:view numberOfRowsInSection:0];
        view.frame = CGRectMake(scrollViewWidth * subViewIndex + spaceWidth,
                self.view.frame.size.height - rowHeight, cardWidth, rowHeight * rows);
        subViewIndex++;
    }

    self.scrollView.contentSize = CGSizeMake([self getScreenWidth] * self.cardViews.count, rowHeight);
}

- (CGFloat)cardRowHeight {
    UITableView *exampleView = (self.cardViews)[0];
    return [[exampleView delegate] tableView:exampleView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    [self adjustCardSizes];
}

- (CGFloat)getScreenWidth {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect bounds = [UIScreen mainScreen].bounds;
    return UIInterfaceOrientationIsPortrait(interfaceOrientation) ? CGRectGetWidth(bounds) : CGRectGetHeight(bounds);
}

@end