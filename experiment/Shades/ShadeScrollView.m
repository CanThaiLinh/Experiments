#import "ShadeScrollView.h"
#import "ShadeTableViewController.h"
#import "ShadeView.h"
#import "Spot.h"

@implementation ShadeScrollView

typedef enum {
    UP, DOWN
} direction;

const double EXPOSED_SHADE_MULTIPLIER = 1.3;

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.clipsToBounds = NO;
        [self setDelegate:self];

        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cardPanned:)];
        [recognizer setDelegate:self];
        [self addGestureRecognizer:recognizer];
    }

    return self;
}

- (void)cardPanned:(UIPanGestureRecognizer *)gesture {
    UITableView *view = self.cardViews[(NSUInteger) [self currentPage]];
    if ([view numberOfRowsInSection:0] <= 1) {
        return;
    }

    CGPoint v = [gesture velocityInView:self];
    if (fabs(v.x) > 40) {
        return;
    }

    const int THRESHOLD = 100;
    if (v.y <= -THRESHOLD && !self.swiping && !self.cardRevealed) {
        self.swiping = YES;
        [self revealCard];
    }
    else if (v.y >= THRESHOLD && !self.swiping && self.cardRevealed) {
        self.swiping = YES;
        [self hideCard:YES];
    }
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

- (void)revealCard {
    if (!self.cardRevealed) {
        [self hideOtherCards];
        [self moveCard:UP animate:YES];
    }
}

- (void)hideOtherCards {
    int page = [self currentPage];
    if (page > 0) {
        [self.cardViews[page - 1] setHidden:YES];
    }
    if (page < [self.cardViews count] - 1) {
        [self.cardViews[page + 1] setHidden:YES];
    }
}

- (void)hideCard:(BOOL)animate {
    if (self.cardRevealed) {
        [self moveCard:DOWN animate:animate];
    }
}

- (void)showOtherCards {
    int page = [self currentPage];
    if (page > 0) {
        [self.cardViews[page - 1] setHidden:NO];
    }
    if (page < [self.cardViews count] - 1) {
        [self.cardViews[page + 1] setHidden:NO];
    }
}

- (void)moveCard:(direction)direction animate:(BOOL)animate {
    int page = [self currentPage];
    UITableView *card = self.cardViews[page];
    ShadeView *shadeView = (ShadeView *) self.superview;
    int heightToMove = (int) ([self cardRowHeight] * [card numberOfRowsInSection:0] - [self cardRowHeight] - [self rowOffsetForHeight:[self cardRowHeight]]);
    int maxHeight = (int) (self.superview.superview.frame.size.height - [self cardRowHeight] - 25);
    int boundHeightToMove = MIN(maxHeight, heightToMove);

    int yTranslation = direction == UP ? boundHeightToMove : -1 * boundHeightToMove;
    if (animate) {
        [UIView animateWithDuration:0.15 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            shadeView.heightConstraint.constant = shadeView.heightConstraint.constant + yTranslation;
            [shadeView.superview layoutIfNeeded];
        }                completion:^(BOOL finished) {
            self.cardRevealed = !self.cardRevealed;

            if (!self.cardRevealed) {
                [self showOtherCards];
            }
            self.swiping = NO;
        }];
    }
    else {
        shadeView.heightConstraint.constant = shadeView.heightConstraint.constant + yTranslation;
    }
}

- (int)currentPage {
    int page = (int) (self.contentOffset.x / self.frame.size.width);
    return page;
}

- (CGFloat)cardRowHeight {
    UITableView *exampleView = (self.cardViews)[0];
    return [[exampleView delegate] tableView:exampleView heightForRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
}

- (void)buildCards:(NSArray *)data {
    self.cardViews = [@[] mutableCopy];
    self.viewControllers = [@[] mutableCopy];

    for (int i = 0; i < [data count]; i++) {
        Spot *spot = data[(NSUInteger) i];
        ShadeTableViewController *individualController = [[ShadeTableViewController alloc] initWithSpot:spot];
        [self.viewControllers addObject:individualController];
        [self.cardViews addObject:individualController.tableView];
        [self addSubview:individualController.tableView];
    }

    ShadeView *shadeView = (ShadeView *) self.superview;
    shadeView.heightConstraint.constant = (CGFloat) ([self cardRowHeight] * EXPOSED_SHADE_MULTIPLIER);

    [self adjustCardSizes];
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
                (CGFloat) (rows == 1 ? [self rowOffsetForHeight:rowHeight] : 0), cardWidth, rowHeight * rows);
        subViewIndex++;
    }

    self.contentSize = CGSizeMake([self getScreenWidth] * self.cardViews.count, rowHeight);
}

- (CGFloat)rowOffsetForHeight:(float)height {
    return (CGFloat) (height / (1 / (EXPOSED_SHADE_MULTIPLIER - 1)));
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
    [self hideCard:NO];
    int position = [self positionForSpot:spot];
    CGRect rect = CGRectMake(self.frame.size.width * position, 0, self.frame.size.width, self.frame.size.height);
    [self scrollRectToVisible:rect animated:YES];

}

- (int)positionForSpot:(Spot *)spot {
    for (int i = 0; i < [self.viewControllers count]; i++) {
        ShadeTableViewController *controller = (self.viewControllers)[i];
        if (controller.spot == spot) {
            return i;
        }
    }
    return -1;
}

@end