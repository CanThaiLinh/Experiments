#import <MapKit/MapKit.h>
#import "EXViewController.h"
#import "ClipView.h"
#import "DummyAnnotations.h"

@implementation EXViewController

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
    self.scrollView.canCancelContentTouches = NO;
    [self.scrollView setDelegate:self];

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cardPanned:)];
    [recognizer setDelegate:self];
    [self.scrollView addGestureRecognizer:recognizer];

    [self buildCards];
    [self adjustCardSizes];

    [self.mapView setDelegate:self];
//    [self.mapView setClusteringEnabled:NO];
    [self.mapView setClusterByGroupTag:YES];
    [self.mapView setClusterSize:0.001];

    CLLocationCoordinate2D startingLocation;
    startingLocation.latitude = 4;
    startingLocation.longitude = 5;
    [[DummyAnnotations new] addAnnotations:self.mapView around:startingLocation];

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;

    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
    if (!self.hasFoundInitialLocation) {
        self.hasFoundInitialLocation = YES;
        [[DummyAnnotations new] addAnnotations:self.mapView around:newLocation.coordinate];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {

}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    MKCoordinateRegion region;
    region.center = mapView.userLocation.coordinate;
    region.span = MKCoordinateSpanMake(0.001, 0.001);

    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:NO];
}


- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated {
    double MAX_DELTA = 0.02;
    if (mapView.region.span.latitudeDelta > MAX_DELTA || mapView.region.span.longitudeDelta > MAX_DELTA) {
        MKCoordinateRegion region;
        region.center = mapView.userLocation.coordinate;
        region.span = MKCoordinateSpanMake(MAX_DELTA - 0.001, MAX_DELTA - 0.001);

        region = [mapView regionThatFits:region];
        [self.mapView setRegion:region];
    }
    else {
        NSLog(@"%f", mapView.region.span.latitudeDelta);
        if (mapView.region.span.latitudeDelta > 0.003) {
            [self.mapView setClusterByGroupTag:NO];
            [self.mapView doClustering];
        }
        else {
            [self.mapView setClusterByGroupTag:YES];
            [self.mapView setClusterSize:mapView.region.span.latitudeDelta * 50];
            [self.mapView doClustering];
        }
    }
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    if (annotation == self.mapView.userLocation) {
        return nil;
    }
    else if ([annotation isKindOfClass:[OCAnnotation class]]) {
        NSString *identifier = @"GroupPin";
        MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!pin) {
            pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pin.animatesDrop = YES;
            pin.canShowCallout = NO;
            pin.pinColor = MKPinAnnotationColorRed;
        }
        pin.annotation = annotation;

        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return pin;
    }
    else {
        NSString *identifier = @"MyPin";
        MKPinAnnotationView *pin = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (!pin) {
            pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            pin.animatesDrop = YES;
            pin.canShowCallout = YES;
        }
        pin.pinColor = MKPinAnnotationColorPurple;
        pin.annotation = annotation;

        pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        return pin;
    }
}


- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideCard:NO];
}

- (void)cardPanned:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {self.swiping = NO;}
    CGPoint v = [gesture velocityInView:self.scrollView];
    const int THRESHOLD = 150;
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
    int yTranslation = direction == UP ? -100 : 100;
    UIView *card = self.cardViews[page];
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
    for (int i = 0; i < CARD_COUNT; i++) {
        UIStoryboard *cardBoard = [UIStoryboard storyboardWithName:@"StockCard" bundle:nil];
        UITableViewController *controller = [cardBoard instantiateViewControllerWithIdentifier:@"stockCards"];
        [self.cardViews addObject:controller.tableView];
        [self.scrollView addSubview:controller.tableView];
    }
}

- (void)adjustCardSizes {
    float rowHeight = [self cardRowHeight];
    UITableView *exampleView = (self.cardViews)[0];
    int rows = [[exampleView dataSource] tableView:exampleView numberOfRowsInSection:0];

    float scrollViewWidth = self.scrollView.frame.size.width;
    int spaceWidth = 5;
    float cardWidth = scrollViewWidth - 2 * spaceWidth;
    int subViewIndex = 0;
    for (UIView *view in self.cardViews) {
        view.frame = CGRectMake(scrollViewWidth * subViewIndex + spaceWidth,
                self.scrollView.frame.size.height - rowHeight, cardWidth, rowHeight * rows);
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