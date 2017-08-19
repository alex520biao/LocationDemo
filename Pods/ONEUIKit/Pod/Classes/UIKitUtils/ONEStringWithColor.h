//
//  ONEStringWithColor.h
//  Pods
//
//  Created by 张华威 on 2017/3/27.
//
//

#import <Foundation/Foundation.h>

@interface ONEStringWithColor : NSObject

/**
 *  处理带有{}的字符串
 *
 *  @param  输入 str带有成对的大括号
 *
 *  @return 输出 str成对去掉大括号
 */
+ (NSString *)getNewString:(NSString *)str;
/**
 *  支持n对大括号，大括号必须成对出现，且不能有嵌套关系
 *
 *  @param str    带大括号的string
 *  @param lColor 高亮颜色
 *  @param nColor 普通颜色
 *  @param afont  字体
 *
 *  @return  NSMutableAttributedString
 */
+ (NSMutableAttributedString *)getAttibutedString:(NSString *)str lightColor:(UIColor *)lColor normalColor:(UIColor *)nColor font:(UIFont *)afont;


/**
 支持n对大括号，大括号必须成对出现，且不能有嵌套关系

 @param str 输入str
 @param lColor 高亮颜色
 @param nColor 普通颜色
 @param lfont 高亮字体
 @param nfont 普通字体
 @return NSMutableAttributedString
 */
+ (NSMutableAttributedString *)getAttibutedString:(NSString *)str lightColor:(UIColor *)lColor normalColor:(UIColor *)nColor lightFont:(UIFont *)lfont normalFont:(UIFont *)nfont;

@end
