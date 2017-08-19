//
//  ONEUIKitTheme.h
//  Pods
//
//  Created by ranwenjie on 16/4/14.
//
//

#import <UIKit/UIKit.h>

#pragma mark version

#define ONEUIKitTag @"ONEUIKit-0.0.24"

#pragma mark 颜色值
#define kColorMiddleGrayHexValue    @"616161"
#define kColorOringeHexValue        @"FF7F01"
#define kColorDarkGrayHexValue      @"888888"
#define kColorMiddleGrayHexValue    @"616161"

#pragma mark 颜色
#ifndef kColorWhite
#define kColorHighlight         ONEHighlightColor()
#define kColorHighlight1        ONEHighlightColor1()
#define kColorWhite             [ONEUIKitTheme colorWithHexString:@"ffffff"]
#define kColorBlack             [ONEUIKitTheme colorWithHexString:@"000000"]
#define kColorClear             [ONEUIKitTheme colorWithHexString:@"ffffff" alpha:0]
#define kColorWhiteAlpha        [ONEUIKitTheme colorWithHexString:@"ffffff" alpha:1]
#define kColorGray              [ONEUIKitTheme colorWithHexString:@"666666"]
#define kColorLightGray         [ONEUIKitTheme colorWithHexString:@"999999"]
#define kColorLightGray1        [ONEUIKitTheme colorWithHexString:@"cccccc" alpha:0.8]
#define kColorLightGray2        [ONEUIKitTheme colorWithHexString:@"f0f0f0"]
#define kColorLightGray3        [ONEUIKitTheme colorWithHexString:@"e5e5e5"]
#define kColorLightGray4        [ONEUIKitTheme colorWithHexString:@"fafafa"]
#define kColorLightGray5        [ONEUIKitTheme colorWithHexString:@"e0e0e0"]
#define kColorLightGray6        [ONEUIKitTheme colorWithHexString:@"ebebeb"]
#define kColorLightGray7        [ONEUIKitTheme colorWithHexString:@"adadad"]
#define kColorLightGray8        [ONEUIKitTheme colorWithHexString:@"cccccc"]
#define kColorLightGray9        [ONEUIKitTheme colorWithHexString:@"4a4c5b" alpha:0.8f]
#define kColorLightGray10       [ONEUIKitTheme colorWithHexString:@"4a4c5b" alpha:0.25f]
#define kColorLightGray_EstimatePage [ONEUIKitTheme colorWithHexString:@"fafafa" alpha:0.95]
#define kColorLinkGray          [ONEUIKitTheme colorWithHexString:@"878787"]
#define kColorDeepGray          [ONEUIKitTheme colorWithHexString:@"333333"]
#define kColorDarkGray          [ONEUIKitTheme colorWithHexString:@"666666" alpha:0.4]
#define kColorOrange            [ONEUIKitTheme colorWithHexString:@"ff8903"]
#define kColorOrange1           [ONEUIKitTheme colorWithHexString:@"fc9153"]
#define kColorLightOrange       [ONEUIKitTheme colorWithHexString:@"ffbd66"]
#define kColorLightOrange1      [ONEUIKitTheme colorWithHexString:@"fcf0e3"]
#define kColorNormalOrange      [ONEUIKitTheme colorWithHexString:@"fa8919"]
#define kColorDarkOrange        [ONEUIKitTheme colorWithHexString:@"e37e2a"]
#define kColorRed               [ONEUIKitTheme colorWithHexString:@"dd170c"]
#define kColorRed1              [ONEUIKitTheme colorWithHexString:@"fa2419"]
#define kColorRed2              [ONEUIKitTheme colorWithHexString:@"f93030"]
#define kColorRed_light         [ONEUIKitTheme colorWithHexString:@"fa3c32"]
#define kColorBlue              [ONEUIKitTheme colorWithHexString:@"21b3ff"]
#define kColorNavgationView     [ONEUIKitTheme colorWithHexString:@"f5f5f5" alpha:0.98]
#define kColorHomeBar           [kColorLightGray4 colorWithAlphaComponent:0.98]
#define kBackgroundColor     [ONEUIKitTheme colorWithHexString:@"25262d" alpha:.4f]
#define kAlertViewIconBackgroundColor [ONEUIKitTheme colorWithHexString:@"f3f4f5"]
#endif

#pragma mark 字体
#ifndef kFontSizeLarge
#define kFontSizeLarge5_HT      [UIFont fontWithName:@"HelveticaNeue-Thin" size:55]
#define kFontSizeLarge4_HT      [UIFont fontWithName:@"HelveticaNeue-Thin" size:34]
#define kFontSizeLarge3_HT      [UIFont fontWithName:@"HelveticaNeue-Thin" size:26]
#define kFontSizeMedium_HT      [UIFont fontWithName:@"HelveticaNeue-Thin" size:14]
#define kFontSizeLarge5         [UIFont systemFontOfSize:55]
#define kFontSizeLarge4         [UIFont systemFontOfSize:34]
#define kFontSizeLarge3         [UIFont systemFontOfSize:26]
#define kFontSizeLarge2x        [UIFont systemFontOfSize:23]
#define kFontSizeLarge2         [UIFont systemFontOfSize:21]
#define kFontSizeLarge1_        [UIFont systemFontOfSize:20]
#define kFontSizeLarge1         [UIFont systemFontOfSize:19]
#define kFontSizeLarge          [UIFont systemFontOfSize:16]
#define kBoldFontSizeLarge2     [UIFont boldSystemFontOfSize:20]
#define kBoldFontSizeLarge1     [UIFont boldSystemFontOfSize:19]
#define kBoldFontSizeLarge      [UIFont boldSystemFontOfSize:16]
#define kBoldFontSizeSmall      [UIFont boldSystemFontOfSize:12]
#define kFontSizeMedium1        [UIFont systemFontOfSize:15]
#define kFontSizeMedium         [UIFont systemFontOfSize:14]
#define kBoldFontSizeMedium     [UIFont boldSystemFontOfSize:14]
#define kFontSizeSmall          [UIFont systemFontOfSize:12]
#define kFontSizeSmall1         [UIFont systemFontOfSize:10]
#define kFontSize_18            [UIFont systemFontOfSize:18]
#endif

#pragma mark 长度
#ifndef kScreenWidth
#define kScreenWidth            [[UIScreen mainScreen]bounds].size.width
#endif
#ifndef kScreenHeight
#define kScreenHeight           [[UIScreen mainScreen]bounds].size.height
#endif
#ifndef kApplicationWidth
#define kApplicationWidth       kScreenWidth
#endif
#ifndef kApplicationHeight
#define kApplicationHeight      kScreenHeight
#endif
#ifndef kBackButtonSize
#define kBackButtonSize         CGSizeMake(48, 44) //按钮大小?
#endif


#pragma mark 类型

/// 按钮预定义高度
typedef NS_ENUM(NSUInteger, ONEButtonSize) {
    ONEButtonSizeLarge1 = 44,
    ONEButtonSizeLarge2 = 40,
    ONEButtonSizeLarge3 = 36,
    ONEButtonSizeSmall  = 24,
};

/// 按钮与定义样式
typedef NS_ENUM(NSUInteger, ONEButtonStyle) {
    ONEButtonStyleColorFlat,   ///< 纯色 (橙色)
    ONEButtonStyleColorBorder, ///< 线框 (橙色)
    ONEButtonStyleGrayBorder,  ///< 线框 (灰色)
};

FOUNDATION_EXPORT UIColor *ONEHighlightColor();
FOUNDATION_EXPORT UIColor *ONEHighlightColor1();

#pragma mark -
/**
 App 主题、颜色、样式相关工具类
 */
@interface ONEUIKitTheme : NSObject


#pragma mark 颜色
/**
 从 hex 字符串创建颜色，错误时返回 nil。
 @param string 支持格式 "#rrggbb" 或 "rrggbb" 不区分大小写。
 */
+ (UIColor *)colorWithHexString:(NSString *)string;

/**
 从 hex 字符串创建颜色，错误时返回 nil。
 @param string 支持格式 "#rrggbb" 或 "rrggbb" 不区分大小写。
 @param alpha 透明度，0～1
 */
+ (UIColor *)colorWithHexString:(NSString *)string alpha:(CGFloat)alpha;


#pragma mark 图片

/**
 从 ONEUIKit 的 bundle 中取图片，失败返回 nil。
 @param name 图片名
 @param bundle ONEUIKit 中子控件的 bundle 名。传入 nil 则优先搜索 ONEUIKit.bundle
 */
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSString *)bundle;


#pragma mark 按钮

/**
 创建一个预定义样式的按钮
 */
+ (UIButton *)buttonWithStyle:(ONEButtonStyle)style size:(ONEButtonSize)size;

/**
 设置按钮样式 (包括背景图片和文本颜色)
 */
+ (void)setButton:(UIButton *)button withStyle:(ONEButtonStyle)style;

/**
 设置按钮的大小 (包括高度和文本字体大小)
 */
+ (void)setButton:(UIButton *)button withSize:(ONEButtonSize)size;

/**
 预定义按钮文字颜色
 */
+ (UIColor *)buttonTextColorWithStyle:(ONEButtonStyle)style state:(UIControlState)state;

/**
 预定义按钮背景图片
 */
+ (UIImage *)buttomImageWithStyle:(ONEButtonStyle)style state:(UIControlState)state;

@end

