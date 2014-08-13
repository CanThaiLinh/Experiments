@interface TextDrawer : NSObject
+ (void)writeText:(NSString *)text fontSize: (float)fontSize inRect:(CGRect)rect;
@end