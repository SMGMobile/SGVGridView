//
//  SGVUtil.h
//  Pods
//
//  Created by 季风 on 16/9/26.
//
//

#import <UIKit/UIKit.h>

@interface SGVUtil : NSObject
/**
 *  获取当前包与mainBundle的相对路径，若当前包是mainBundle则返回@“”；
 *
 *  @return 相对路径，若不为空，首字符不是/；
 */
+ (NSString *)relativePathForCurrentBundle;
/**
 *  获取九宫格的默认图片名称
 *
 *  @return 图片名称，包含相对路径
 */
+ (NSString *)cellDefaultImageName;
+ (BOOL)strNilOrEmpty:(NSString *)string;
+ (UIColor *)colorWithHexString:(NSString *)hexColor;
@end
