#import <CoreText/CoreText.h>
#import "TextDrawer.h"

@implementation TextDrawer

+ (CGSize)sizeOfText:(NSString *)text fontSize:(float)fontSize {
    CFAttributedStringRef attr_string = [self getAttrString:text fontSize:fontSize];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attr_string);
    CGSize suggestedSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0, 0), NULL, CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX), NULL);
    CFRelease(framesetter);
    return suggestedSize;
}

+ (void)writeText:(NSString *)text fontSize:(float)fontSize inRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    CFAttributedStringRef attr_string = [self getAttrString:text fontSize:fontSize];
    CTLineRef line = CTLineCreateWithAttributedString(attr_string);

    CGContextSetTextPosition(context, rect.origin.x + 5, rect.size.height / 2 - (fontSize - 4) / 2 - rect.origin.y );

    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    [[UIColor whiteColor] setFill];
    CTLineDraw(line, context);
    CFRelease(line);
    CFRelease(attr_string);

    CGContextRestoreGState(context);
}

+ (CFAttributedStringRef)getAttrString:(NSString *)text fontSize:(float)fontSize {
    CFStringRef font_name = CFStringCreateWithCString(NULL, [[[UIFont systemFontOfSize:12] fontName] UTF8String], kCFStringEncodingMacRoman);
    CTFontRef font = CTFontCreateWithName(font_name, fontSize, NULL);
    CFStringRef keys[] = {kCTFontAttributeName, kCTForegroundColorFromContextAttributeName};
    CFTypeRef values[] = {font, kCFBooleanTrue};
    CFDictionaryRef font_attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void **) &keys, (const void **) &values, sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFRelease(font_name);
    CFRelease(font);

    NSLog(@"%@", text);
    CFStringRef string = CFStringCreateWithCString(NULL, [text UTF8String], kCFStringEncodingMacRoman);
    CFAttributedStringRef attr_string = CFAttributedStringCreate(NULL, string, font_attributes);
    CFRelease(string);
    return attr_string;
}

@end