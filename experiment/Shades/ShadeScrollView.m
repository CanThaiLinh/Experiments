#import "ShadeScrollView.h"
#import "ShadeTableViewController.h"

@implementation ShadeScrollView

typedef enum {
    UP, DOWN
} direction;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.clipsToBounds = NO;
        [self setDelegate:self];
    }

    return self;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint touchLocation = [touch locationInView:self];
    for (UIView *view in self.cardViews) {
        if (CGRectContainsPoint(view.frame, touchLocation)) {
            return YES;
        }
    }
    return NO;
}

- (int)currentPage {
    int page = (int) (self.contentOffset.x / self.frame.size.width);
    return page;
}

- (CGFloat)cardRowHeight {
    UITableView *exampleView = (self.cardViews)[0];
    return [[exampleView delegate] tableView:exampleView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self resizeContent];
}

- (void)resizeContent {
    UITableView *view = self.cardViews[(NSUInteger) [self currentPage]];
    int rows = [[view dataSource] tableView:view numberOfRowsInSection:0];
    CGFloat height = [self cardRowHeight] * rows;
    CGFloat heightDiff = self.frame.size.height - height;
    self.contentSize = CGSizeMake([self getScreenWidth] * self.cardViews.count, height);
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


        UITableView *tableView = [UITableView new];
        int count = 3 + i * 5;
        [individualController setItems:[self textArrayOfSize:count]];
        [tableView setDataSource:individualController];
        [tableView setDelegate:individualController];

        int rows = [individualController tableView:tableView numberOfRowsInSection:0];
        CGFloat height = [individualController tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        tableView.frame = CGRectMake(0, 0, self.frame.size.width, height * rows);

        [self.cardViews addObject:tableView];
        [self addSubview:tableView];
    }

    [self adjustCardSizes];
    [self resizeContent];
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
    float scrollViewWidth = self.frame.size.width;
    int spaceWidth = 5;
    float cardWidth = scrollViewWidth - 2 * spaceWidth;
    int subViewIndex = 0;
    for (UITableView *view in self.cardViews) {
        int rows = [[view dataSource] tableView:view numberOfRowsInSection:0];
        view.frame = CGRectMake(scrollViewWidth * subViewIndex + spaceWidth,
                0, cardWidth, rowHeight * rows);
        subViewIndex++;
    }

    self.contentSize = CGSizeMake([self getScreenWidth] * self.cardViews.count, rowHeight);
}

- (CGFloat)getScreenWidth {
    UIInterfaceOrientation interfaceOrientation = [[UIApplication sharedApplication] statusBarOrientation];
    CGRect bounds = [UIScreen mainScreen].bounds;
    return UIInterfaceOrientationIsPortrait(interfaceOrientation) ? CGRectGetWidth(bounds) : CGRectGetHeight(bounds);
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

@end