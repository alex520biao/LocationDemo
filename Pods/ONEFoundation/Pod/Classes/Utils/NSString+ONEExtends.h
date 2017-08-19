//
//  NSString+ONEExtends.h
//  Pods
//
//  Created by zhanghuawei on 16/8/31.
//
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <UIKit/UIKit.h>

@interface NSString (ONEExtends)

/**
 移除字符串里所有的空格，包括连续的空格

 @return 移除空格后的字符串，和原来的字符串移除结果的 copy
 */
- (NSString *)one_noneSpaceString;
@end

@interface NSString (ONEEncrypt)
- (NSString*)one_encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSString*)one_decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;

- (NSString*)one_encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSString*)one_decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;

// AES加密与解密
- (NSString *)one_AES256EncryptWithKey:(NSString *)key;
- (NSString *)one_AES256DecryptWithKey:(NSString *)key;

// DES加密与解密
+ (NSString *)one_encodeDES:(NSString *)plainString key:(NSString *)key;
+ (NSString *)one_decodeDES:(NSString *)decodedString key:(NSString*)key;

@end

@interface NSString (ONEUrlEncode)

- (NSString *)one_urlEncode;

- (NSString *)one_urlDecode;

@end

@interface NSString (ONETrims)

- (NSString *)one_trimmingWhitespace;
- (NSString *)one_trimmingWhitespaceAndNewlines;

@end

@interface NSString (ONEContains)

- (BOOL)one_containsString:(NSString *)string;

@end

@interface NSString (ONEDictionaryValue)

-(NSDictionary *) one_dictionaryValue;

@end

@interface NSString (ONEAutoSize)

- (CGSize)one_autoSize:(UIFont *)font;

/**
 *  计算string的大小
 *
 *  @param font  字体对象
 *  @param aSize 限制的大小
 *
 *  @return 计算结果的大小
 */
- (CGSize)one_autoSize:(UIFont *)font constrainedToSize:(CGSize)aSize;

- (CGFloat)one_heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
- (CGFloat)one_widthWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

- (CGSize)one_sizeWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
- (CGSize)one_sizeWithFont:(UIFont *)font constrainedToHeight:(CGFloat)height;

@end

@interface NSString (ONEMD5)

- (NSString *)one_MD5;

@end

#pragma mark - 字符串检查
@interface NSString (ONE_Checking)

- (BOOL)one_composedOfNumbers;
- (BOOL)one_uniformedBySingleCharacter;
- (BOOL)one_alphanumeric;

@end

#pragma mark - 字符串和JSON转换
@interface NSString (ONE_JSON)

- (NSDictionary *)one_jsonDict;

@end

#pragma mark - 字符串解析
@interface NSString (ONE_Parsing)

- (NSArray *)one_rangesOfSubstring:(NSString *)substring;

@end

#pragma mark - 字符串编码&解码
@interface NSString (ONE_Encoding_Decoding)

- (NSString *)one_urlEncodedString;
- (NSString *)one_urlDecodedString;

@end

@interface NSString (ONEBase64Addition)

+(NSString *)one_stringFromBase64String:(NSString *)base64String;

@end

@interface NSString (ONERegexCategory)

/**
 *  网址有效性
 */
- (BOOL)one_isValidUrl;

@end

@interface NSString (ONEBase64)
- (NSString *)one_base64EncodedString;
- (NSString *)one_base64DecodedString;
@end
