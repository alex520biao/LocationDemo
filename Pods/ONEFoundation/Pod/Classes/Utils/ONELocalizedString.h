//
//  ONELocalizedString.h
//  Pods
//
//  Created by 张华威 on 2016/12/14.
//
//

#import <ONEFoundation/ONEFoundation.h>
#import "ONEUserLanguageConst.h"

/**
 * 从bundle中获取本地化字符串
 * pod中多语言文字文件名称为Localizable.strings
 * 多语言文字创建方式参考wiki:http://wiki.intra.xiaojukeji.com/pages/viewpage.action?pageId=91695519
 * eg.
 *    NSString *str = ONELocalizedStr("首页","Pod.bundle");
 *    NSString *str = ONELocalizedStr("首页","Pod");
 * @param key        字符串key
 * @param bundleName 如果没有.bundle后缀的话会自动添加
 * @return string    本地化的字符串,不存在会默认返回key
 */
FOUNDATION_EXPORT NSString *ONELocalizedStr(NSString *key,NSString *bundleName);

/**
 * 从指定bundle中获取本地化图片,支持并按照后缀名为 png,jpg 的顺序查找图片。图片添加方式与多语言添加方式相同。
 * eg.
 *  UIImage *str = ONELocalizedImg("test","Pod.bundle");
 *  UIImage *str = ONELocalizedStr("test.png","Pod");
 *  UIImage *str = ONELocalizedStr("test@3x.png","Pod");
 * @param  key        图片名称
 * @param  bundleName 如果没有.bundle后缀的话会自动添加
 * @return image      本地化的图片,不存在会返回nil
 */
FOUNDATION_EXPORT UIImage *ONELocalizedImg(NSString *imageName,NSString *bundle);


@interface ONELocalizedString : NSObject

/**
 * bundleName如果没有.bundle后缀的话会自动添加
 * eg: NSString *string = [ONELocalizedString localizedString:@"string" inBundle:@"ONEUIKit.bundle"];
 * eg: NSString *string = [ONELocalizedString localizedString:@"string" inBundle:@"ONEUIKit"];
 */
+ (NSString *)localizedString:(NSString *)key inBundle:(NSString *)bundleName;

/**
 *  从bundle中读取国际化图片
 *  @param imageName 图片名称，支持支持并按照后缀名为 png,jpg 的顺序查找图片带后缀和不带后缀的查找
 *  @bundleName 图片所在bundle，如果没有.bundle后缀的话会自动添加
 */
+ (UIImage *)localizedImage:(NSString *)imageName inBundle:(NSString *)bundleName;

@end
