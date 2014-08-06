#import "EXViewController.h"
#import "ClipView.h"
#import "Colors.h"

@implementation EXViewController

- (void)viewDidLoad {
    self.clipView.scrollView = self.scrollView;

    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;

    [self buildCards];
    [self adjustCardSizes];
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
    UIView *rootView = [[[UIApplication sharedApplication] keyWindow] rootViewController].view;
    CGRect originalFrame = [[UIScreen mainScreen] bounds];
    CGRect adjustedFrame = [rootView convertRect:originalFrame fromView:nil];
    return adjustedFrame.size.width;
}

@end