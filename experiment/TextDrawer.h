@interface TextDrawer : NSObject
+ (CGSize)sizeOfText:(NSString *)text fontSize:(float)fontSize;

+ (void)writeText:(NSString *)text fontSize: (float)fontSize inRect:(CGRect)rect;
@end