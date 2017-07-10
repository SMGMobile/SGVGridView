//
//  SGVUtil.m
//  Pods
//
//  Created by 季风 on 16/9/26.
//
//

#import "SGVUtil.h"
#import "SGVConst.h"

@implementation SGVUtil

+ (NSString *)relativePathForCurrentBundle {
    NSString *mainBundlePath = [NSBundle mainBundle].bundlePath;
    NSBundle *currentBundle = [NSBundle bundleForClass:[self class]];
    NSString *path = currentBundle.bundlePath;
    NSString *relativePath;
    if ([path isEqualToString:mainBundlePath]) {
        relativePath = @"";
    } else {
        NSRange range = [path rangeOfString:mainBundlePath];
        if (range.location != NSNotFound) {
            relativePath = [path substringFromIndex:range.location+range.length+1];
        }
    }
    return relativePath;
}

+ (NSString *)cellDefaultImageName {
    return [[self relativePathForCurrentBundle]stringByAppendingPathComponent:kSGVDefaultImageName];
}

+ (BOOL)strNilOrEmpty:(NSString *)string
{
    
    if ([string isKindOfClass:[NSString class]]) {
        if ([string isEqualToString:@"<null>"]||[string isEqualToString:@"(null)"]||[string isEqualToString:@""]||[string isEqualToString:@"null"]) {
            return YES;
        }
        return NO;
    }
    return YES;
}

+ (UIColor *)colorWithHexString:(NSString *)hexColor {
    NSString *hex = [hexColor stringByReplacingOccurrencesOfString:@"#" withString:@""];
    UIColor *color = [self transformHexToColor:hex];
    return color;
}

+ (UIColor *)transformHexToColor:(NSString *)hex {
    CGFloat red, green, blue;
    if (hex.length == 6) {
        // Parse 2 chars per component
        red   = SVParseHex([hex substringWithRange:NSMakeRange(0, 2)], NO) / 255.0;
        green = SVParseHex([hex substringWithRange:NSMakeRange(2, 2)], NO) / 255.0;
        blue  = SVParseHex([hex substringWithRange:NSMakeRange(4, 2)], NO) / 255.0;
    } else if (hex.length >= 3) {
        // Parse 1 char per component, but repeat it to calculate hex value
        red   = SVParseHex([hex substringWithRange:NSMakeRange(0, 1)], YES) / 255.0;
        green = SVParseHex([hex substringWithRange:NSMakeRange(1, 1)], YES) / 255.0;
        blue  = SVParseHex([hex substringWithRange:NSMakeRange(2, 1)], YES) / 255.0;
    } else {
        return nil; // Fail
    }
    return [UIColor colorWithRed:red green:green blue:blue alpha:1.0];
}

// We know we've got hex already, so assume this works
static NSUInteger SVParseHex(NSString *str, BOOL repeated)
{
    NSUInteger ans = 0;
    if (repeated) {
        str = [NSString stringWithFormat:@"%@%@", str, str];
    }
    NSScanner *scanner = [NSScanner scannerWithString:str];
    [scanner scanHexInt:(unsigned*)&ans];
    return ans;
}

@end
