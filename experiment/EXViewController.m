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
    [self.scrollView setDelegate:self];

    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cardPanned:)];
    [recognizer setDelegate:self];
    [self.scrollView addGestureRecognizer:recognizer];

    [self buildCards];
    [self adjustCardSizes];


    UISwipeGestureRecognizer *swipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swiped:)];
    [swipeGestureRecognizer setDirection:UISwipeGestureRecognizerDirectionDown];
    [swipeGestureRecognizer setDelegate:self];
    [self.testView addGestureRecognizer:swipeGestureRecognizer];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self hideCard: NO];
    self.scrolling = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.scrolling = NO;
}

- (void)cardPanned:(UIPanGestureRecognizer *)gesture {
    if (self.scrolling) {
        return;
    }

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
        [self hideCard: YES];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void)revealCard {
    self.cardRevealed = YES;
    [self moveCard:-100 animate:YES];
}

- (void)hideCard:(BOOL) animate {
    if (self.cardRevealed) {
        self.cardRevealed = NO;
        [self moveCard:100 animate:animate];
    }
}

- (void)moveCard:(int)pixels animate:(BOOL)animate {
    int page = (int) (self.scrollView.contentOffset.x / self.scrollView.frame.size.width);
    UIView *card = self.cardViews[page];
    if (animate) {
        [UIView animateWithDuration:0.15 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            card.center = CGPointMake(card.center.x, card.center.y + pixels);
        }                completion:^(BOOL finished) {
        }];
    }
    else {
        card.center = CGPointMake(card.center.x, card.center.y + pixels);
    }
}

- (void)buildCards {
    const int CARD_COUNT = 5;
    self.cardViews = [@[] mutableCopy];
    for (int i = 0; i < CARD_COUNT; i++) {
        UIView *view = [UIView new];
        [view setBackgroundColor:[Colors randomColor]];
        [self.cardViews addObject:view];
        [self.scrollView addSubview:view];
    }
}

- (void)adjustCardSizes {
    float height = 70;

    float scrollViewWidth = self.scrollView.frame.size.width;
    int spaceWidth = 5;
    float cardWidth = scrollViewWidth - 2 * spaceWidth;
    int subViewIndex = 0;
    for (UIView *view in self.cardViews) {
        view.frame = CGRectMake(scrollViewWidth * subViewIndex + spaceWidth,
                self.scrollView.frame.size.height - height, cardWidth, height);
        subViewIndex++;
    }

    self.scrollView.contentSize = CGSizeMake([self getScreenWidth] * self.cardViews.count, height);
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