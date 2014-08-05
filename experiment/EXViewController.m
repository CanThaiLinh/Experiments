#import "EXViewController.h"

@interface EXViewController ()
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation EXViewController

- (void)viewDidLoad {
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.clipsToBounds = NO;

    float height = self.scrollView.frame.size.height;

    UIView *red = [[UIView alloc] initWithFrame:CGRectMake(10, 0, 260, height)];
    [red setBackgroundColor:[UIColor redColor]];

    UIView *green = [[UIView alloc] initWithFrame:CGRectMake(290, 0, 260, height)];
    [green setBackgroundColor:[UIColor greenColor]];

    UIView *blue= [[UIView alloc] initWithFrame:CGRectMake(570, 0, 260, height)];
    [blue setBackgroundColor:[UIColor blueColor]];

    [self.scrollView addSubview:red];
    [self.scrollView addSubview:green];
    [self.scrollView addSubview:blue];
    self.scrollView.contentSize = CGSizeMake(320 * 3, self.scrollView.frame.size.height);
}

@end