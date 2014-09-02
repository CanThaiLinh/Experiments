#import "ShadeTableView.h"

@implementation ShadeTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    self = [super initWithFrame:frame style:style];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.showsVerticalScrollIndicator = NO;
        self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.tableFooterView setBackgroundColor:[UIColor whiteColor]];
    }

    return self;
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return point.y >= 0 && [super pointInside:point withEvent:event];
}

@end