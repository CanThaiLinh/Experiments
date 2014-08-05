#import "EXViewController.h"

@interface EXViewController ()
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation EXViewController

- (void)viewDidLoad {
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;
    self.scrollView.frame = CGRectMake(0, 0, 320, self.scrollView.frame.size.height);

    float height = self.scrollView.frame.size.height;

    int spacerWidth = 30;
    float width = self.scrollView.frame.size.width -  2 * spacerWidth;

    UIView *red = [[UIView alloc] initWithFrame:CGRectMake(spacerWidth, 0, width, height)];
    [red setBackgroundColor:[UIColor redColor]];

    UIView *green = [[UIView alloc] initWithFrame:CGRectMake(320 + spacerWidth, 0, width, height)];
    [green setBackgroundColor:[UIColor greenColor]];

    [self.scrollView addSubview:red];
    [self.scrollView addSubview:green];
    self.scrollView.contentSize = CGSizeMake(320 * 2, self.scrollView.frame.size.height);
}

@end