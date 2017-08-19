//
//  ONELocalizeManager.h
//  Pods
//
//  Created by Liushulong on 12/01/2017.
//
//  语言编码参考：http://wiki.intra.xiaojukeji.com/pages/viewpage.action?pageId=91319775

#import <Foundation/Foundation.h>
#import "ONEUserLanguageConst.h"

/**
 * 用户语言设置改变通知,通知中的 object 为用户当前选中语言，类型为 NSString *，
 */
FOUNDATION_EXPORT NSString* const ONEUserLanguageDidChangeNotification;

NS_ASSUME_NONNULL_BEGIN

/**
 用户语言管理类，如用户选中的语言等
 */
@interface ONEUserLanguageManager : NSObject

/**< 多语言是否生效,默认NO不生效，由外部设置 */
@property (nonatomic,assign)   BOOL isMultiLanguageEnabled;
@property (nonatomic,assign)   BOOL useSysLanguage;/**< 用户未设置过语言时是否使用系统默认语言,默认为YES;NO则返回第一个支持的语言 */
@property (nonatomic,readonly) NSArray<NSString *>  *supportLanguages;/**< 当前支持的语言列表 */

+ (instancetype)sharedInstance;

/**
 * 用户当前语言设置,编码参考一下wiki.
 * 根据wiki要求,如果用户没有设置默认使用中文
 * http://wiki.intra.xiaojukeji.com/pages/viewpage.action?pageId=91319775
 *
 * return 当前语言设置的滴滴编码，如果是中文系列的语言，则返回 @"zh-CN"，其它情况返回 @"en-US"
 */
+ (NSString *)currentLanguage;

/**
 * 设置用户当前语言,参数编码请参考wikihttp://wiki.intra.xiaojukeji.com/pages/viewpage.action?pageId=91319775
 * eg. 设置中文大陆 [ONEUserLanguageManager setLanguage:@"zh-CN"]
 *
 * param language 滴滴编码的语言，如 @"zh-CN"，@"en-US"
 * return YES if language is effective; return NO if language is not effective
 */
+ (BOOL)setLanguage:(NSString *)language;

/**
 * 当前语言是否是简体中文
 * @return bool 简体中文返回yes,否则为no
 */
+ (BOOL)isSimpleChinese;

/**
 * 端上支持的语言类型和判断顺序。
 * 支持的语言目前不支持设置为nil
 * 数组个数大于0并且如果用户未设置,如数组为中文，葡萄牙语，英文，系统语言是中文则 currentLanguage 返回中文，如果系统语言是葡萄牙语则返回葡萄牙语，其他返回英文。
 * 默认是中文和英文。
 * eg. @[ONEUserlanguageZHCN,ONEUserlanguageENUS]
 * @params supportedLanguages 支持的语言类型，按照index升序判断
 * @return YES - 设置成功，NO - 设置失败
 */
+ (BOOL)setSupportedLanguages:(NSArray<NSString *> *)supportedLanguages;

/**
 * 当前userDefaults的第一个语言,转成滴滴编码返回
 */
+ (NSString *)sysFirstLanguage;

@end

NS_ASSUME_NONNULL_END
