#import "EXViewController.h"
#import "ClipView.h"
#import "Colors.h"

@implementation EXViewController

- (void)viewDidLoad {
    self.clipView.scrollView = self.scrollView;
    self.cardRevealed = NO;

    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.canCancelContentTouches = NO;

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cardPanned:)];
    [recognizer setDelegate:self];
    [self.scrollView addGestureRecognizer:recognizer];

    [self buildCards];
    [self adjustCardSizes];
}

- (void)cardPanned:(UIPanGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateBegan) {self.swiping = NO;}
    CGPoint v = [gesture velocityInView:self.scrollView];
    if (abs(v.y) >= 50 && !self.swiping && !self.cardRevealed) {
        NSLog(@"Revealing");
        self.swiping = YES;
        [gesture cancelsTouchesInView];
        [self revealCard];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)revealCard {
    self.cardRevealed = YES;
    int page = (int) (self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    UIView *card = self.cardViews[page];
    card.center = CGPointMake(card.center.x, card.center.y - 100);
}

- (void)buildCards {
    const int CARD_COUNT = 5;
    self.cardViews = [@[] mutableCopy];
    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    UITapGestureRecognizer *testTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [swipeGestureRecognizer setDelegate:self];
    for (int i = 0; i < CARD_COUNT; i++) {
        UIView *view = [UIView new];
        [view addGestureRecognizer:swipeGestureRecognizer];
        [view addGestureRecognizer:testTap];
        [view setBackgroundColor:[Colors randomColor]];
        [self.cardViews addObject:view];
        [self.scrollView addSubview:view];
    }
}

- (void)swiped:(UISwipeGestureRecognizer *)gesture {
    NSLog(@"SWIPE");
}

- (void)adjustCardSizes {
    float height = self.scrollView.frame.size.height;

    float scrollViewWidth = self.scrollView.frame.size.width;
    int spaceWidth = 5;
    float cardWidth = scrollViewWidth - 2 * spaceWidth;
    int subViewIndex = 0;
    for (UIView *view in self.cardViews) {
        view.frame = CGRectMake(scrollViewWidth * subViewIndex + spaceWidth, 0, cardWidth, height);
        subViewIndex++;
    }

    self.scrollView.contentSize = CGSizeMake([self getScreenWidth] * self.cardViews.count,
            self.scrollView.frame.size.height);
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