#import "ShadeScrollView.h"
#import "ShadeTableViewController.h"
#import "ShadeView.h"

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

        UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(cardPanned:)];
        [recognizer setDelegate:self];
        [self addGestureRecognizer:recognizer];
    }

    return self;
}

- (void)cardPanned:(UIPanGestureRecognizer *)gesture {
    CGPoint v = [gesture velocityInView:self];
    if(fabs(v.x) > 40){
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
    ShadeView *clipView = (ShadeView *) self.superview;
    int heightToMove = (int) ([self cardRowHeight] * [card numberOfRowsInSection:0] - [self cardRowHeight]);
    int maxHeight = (int) (self.superview.superview.frame.size.height - [self cardRowHeight] - 25);
    int boundHeightToMove = MIN(maxHeight, heightToMove);

    int yTranslation = direction == UP ? boundHeightToMove : -1 * boundHeightToMove;
    if (animate) {
        [UIView animateWithDuration:0.15 delay:0.1 options:UIViewAnimationOptionCurveEaseIn animations:^{
            clipView.heightConstraint.constant = clipView.heightConstraint.constant + yTranslation;
            [clipView.superview layoutIfNeeded];
        }                completion:^(BOOL finished) {
            self.cardRevealed = !self.cardRevealed;

            if (!self.cardRevealed) {
                [self showOtherCards];
            }
            self.swiping = NO;
        }];
    }
    else {
        clipView.heightConstraint.constant = clipView.heightConstraint.constant + yTranslation;
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
        tableView.scrollEnabled = NO;
        [tableView setDataSource:individualController];
        [tableView setDelegate:individualController];
        [self.cardViews addObject:tableView];
        [self addSubview:tableView];
    }

    [self adjustCardSizes];
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