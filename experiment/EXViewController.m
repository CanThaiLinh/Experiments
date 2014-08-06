#import "EXViewController.h"
#import "ClipView.h"

@implementation EXViewController

- (void)viewDidLoad {
    self.clipView.scrollView = self.scrollView;

    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;

    float height = self.scrollView.frame.size.height;

    float scrollViewWidth = self.scrollView.frame.size.width;
    int spaceWidth = 5;
    float cardWidth = scrollViewWidth - 2 * spaceWidth;

    const int CARD_COUNT = 5;
    for (int i = 0; i < CARD_COUNT; i++) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(scrollViewWidth * i + spaceWidth, 0, cardWidth, height)];
        [view setBackgroundColor:[self randomColor]];
        [self.scrollView addSubview:view];
    }

    self.scrollView.contentSize = CGSizeMake(320 * CARD_COUNT, self.scrollView.frame.size.height);
}

- (UIColor *)randomColor {
    CGFloat hue = (CGFloat) (arc4random() % 256 / 256.0);
    CGFloat saturation = (CGFloat) ((arc4random() % 128 / 256.0) + 0.5);
    CGFloat brightness = (CGFloat) ((arc4random() % 128 / 256.0) + 0.5);
    UIColor *color = [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
    return color;
}

@end