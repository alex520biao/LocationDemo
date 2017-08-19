//
//  ONEUserLanguageConst.h
//  Pods
//
//  Created by Liushulong on 13/01/2017.
//
//  由于滴滴 App 包含 iOS 和 Android ，以及 Webapp，在获取语言时，和服务端交互需要一套统一的标识，所以滴滴内部定义了一套语言
//  滴滴内部定义了一套语言：http://wiki.intra.xiaojukeji.com/pages/viewpage.action?pageId=91319775
//  iso639 编码：http://baike.baidu.com/link?url=WJatBsP7H7dw--OETdXDv5AN_mXarnqjFXTg7HT0d9AbeqxZwXiLaRkbJyhXCwUHKmHenQ8GO73qy-L5VPMsye5S_qru8st_FF5vGfI1BhW
//  

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// 滴滴的语言编码定义
UIKIT_EXTERN NSString *const ONEUserlanguageZHCN;/**< 中文(大陆) @"zh-CN"*/
UIKIT_EXTERN NSString *const ONEUserlanguageENUS;/**< 英语(美国) @"en-US"*/
UIKIT_EXTERN NSString *const ONEUserlanguageZHHK;/**< 中文(香港) @"zh-HK"*/
UIKIT_EXTERN NSString *const ONEUserlanguagePTBR;/**< 葡萄牙语(巴西) @"pt-BR"*/

/**
 滴滴编码映射为苹果的 iso639 编码

 @param languageCode 滴滴编码的语言，如 @"zh-CN"，@"en-US"
 @return return iso639 code if language is @"zh-CN" or @"en-US", return nil if others
 */
NSString *DILanguageCodeToISO639(NSString *languageCode);

/**
 苹果编码映射为滴滴的编码
 
 @param languageCode 苹果的编码，如 @"zh-Hans"，@"en"
 @return return 苹果编码，如果app内部未定义则返回nil
 */
NSString *ISO639ToDILanguageCode(NSString *languageCode);

/**
 国际化使用的语言
 */
@interface ONEUserLanguageConst : NSObject

/**
 是滴滴国际化语言范围内支持的滴滴编码的语言（区别于苹果的定义）

 @param language 滴滴编码的语言，如 @"zh-CN"，@"en-US"
 @return return YES if language is @"zh-CN" or @"en-US"
 */
+ (BOOL)isValidLanguage:(NSString *)language;

@end
