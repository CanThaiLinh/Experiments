#import <CoreText/CoreText.h>
#import "TextDrawer.h"

@implementation TextDrawer

+ (void)writeText:(NSString *)text fontSize:(float)fontSize inRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);

    CFStringRef font_name = CFStringCreateWithCString(NULL, [[[UIFont systemFontOfSize:12] fontName] UTF8String], kCFStringEncodingMacRoman);
    CTFontRef font = CTFontCreateWithName(font_name, fontSize, NULL);
    CFStringRef keys[] = {kCTFontAttributeName, kCTForegroundColorFromContextAttributeName};
    CFTypeRef values[] = {font, kCFBooleanTrue};
    CFDictionaryRef font_attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void **) &keys, (const void **) &values, sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFRelease(font_name);
    CFRelease(font);

    CFStringRef string = CFStringCreateWithCString(NULL, [text UTF8String], kCFStringEncodingMacRoman);
    CFAttributedStringRef attr_string = CFAttributedStringCreate(NULL, string, font_attributes);
    CTLineRef line = CTLineCreateWithAttributedString(attr_string);

    CGContextSetTextPosition(context, 5, rect.size.height / 2 - (fontSize - 4) / 2);

    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    [[UIColor whiteColor] setFill];
    CTLineDraw(line, context);
    CFRelease(line);
    CFRelease(string);
    CFRelease(attr_string);
    CGContextRestoreGState(context);
}

@end