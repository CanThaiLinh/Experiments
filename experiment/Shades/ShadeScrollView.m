#import "ShadeScrollView.h"
#import "ShadeTableViewController.h"
#import "Spot.h"
#import "EXViewController.h"
#import "ScrollableTableView.h"
#import "SpotData.h"

@implementation ShadeScrollView

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.clipsToBounds = NO;
        self.delaysContentTouches = NO;
        [self setDelegate:self];

        self.cardViews = [@[] mutableCopy];
        self.viewControllers = [@[] mutableCopy];
    }

    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *hitView = [super hitTest:point withEvent:event];
    return hitView == self ? nil : hitView;
}

- (int)currentPage {
    int page = (int) (self.contentOffset.x / self.frame.size.width);
    return page;
}

- (CGFloat)cardRowHeight {
    UITableView *exampleView = (self.cardViews)[0];
    return exampleView ? [[exampleView delegate] tableView:exampleView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]] : 44;
}

- (void)buildCards:(NSArray *)data {
    for (int i = 0; i < [data count]; i++) {
        Spot *spot = data[(NSUInteger) i];
        ShadeTableViewController *individualController = [[ShadeTableViewController alloc] initWithSpot:spot];
        [self.viewControllers addObject:individualController];
        [self.cardViews addObject:individualController.tableView];
        [self addSubview:individualController.tableView];
    }

    [self adjustCardSizes];
}

- (void)adjustCardSizes {
    float rowHeight = [self cardRowHeight];
    float scrollViewWidth = self.frame.size.width;
    int spaceWidth = 5;
    float cardWidth = scrollViewWidth - 2 * spaceWidth;
    int subViewIndex = 0;
    for (UITableView *view in self.cardViews) {
        view.frame = (CGRect) {
                .origin.x = scrollViewWidth * subViewIndex,
                .origin.y = 0,
                .size.width = cardWidth,
                .size.height = self.frame.size.height
        };
        BOOL stacked = [view numberOfRowsInSection:0] > 1;
        CGFloat offsetPosition = self.frame.size.height - rowHeight;
        CGFloat offset = (CGFloat) (stacked ? offsetPosition - rowHeight/4 : offsetPosition);
        view.contentInset = (UIEdgeInsets) {
                .top = offset
        };
        view.contentOffset = CGPointMake(0, -offset);
        subViewIndex++;
    }

    self.contentSize = CGSizeMake((CGFloat) ([self getScreenWidth] * self.cardViews.count - 0.0625 * self.cardViews.count * [self getScreenWidth]), rowHeight);
}

- (CGFloat)getScreenWidth {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect bounds = [UIScreen mainScreen].bounds;
    return UIInterfaceOrientationIsPortrait(interfaceOrientation) ? CGRectGetWidth(bounds) : CGRectGetHeight(bounds);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)selectSpot:(Spot *)spot {
    int position = [self positionForSpot:spot];
    CGRect rect = CGRectMake(self.frame.size.width * position, 0, self.frame.size.width, self.frame.size.height);
    [self scrollRectToVisible:rect animated:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    ShadeTableViewController *controller = self.viewControllers[(NSUInteger) [self currentPage]];
    [self.spotDelegate didSwipeToSpot:controller.spot];
}

- (int)positionForSpot:(Spot *)spot {
    for (int i = 0; i < [self.viewControllers count]; i++) {
        ShadeTableViewController *controller = (self.viewControllers)[(NSUInteger) i];
        if (controller.spot == spot) {
            return i;
        }
    }
    return -1;
}

@end