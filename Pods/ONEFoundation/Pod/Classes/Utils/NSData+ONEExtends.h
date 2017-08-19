//
//  NSData+ONEExtends.h
//  Pods
//
//  Created by zhanghuawei on 16/10/9.
//
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCryptor.h>

typedef NS_ENUM(NSUInteger, ONEAESKeySizeType) {
    ONEAESKeySizeType_128     = kCCKeySizeAES128,
    ONEAESKeySizeType_192     = kCCKeySizeAES192,
    ONEAESKeySizeType_256     = kCCKeySizeAES256,
};

@interface NSData (ONEAESCrypt)

- (NSData *)one_AES256EncryptWithKey:(NSString *)key;
- (NSData *)one_AES256DecryptWithKey:(NSString *)key;

- (NSData *)one_AESEncryptWithType:(ONEAESKeySizeType)keySizeType
                        encryptKey:(NSString *)key
                                iv:(NSData *)iv;
- (NSData *)one_AESDecryptWithType:(ONEAESKeySizeType)keySizeType
                        encryptKey:(NSString *)key
                                iv:(NSData *)iv;

+ (NSData *)one_dataWithBase64EncodedString:(NSString *)string;
- (id)initWithBase64EncodedString:(NSString *)string;

- (NSString *)one_base64Encoding;
- (NSString *)one_base64EncodingWithLineLength:(NSUInteger)lineLength;

@end

@interface NSData (ONEBase64)

+ (NSData *)one_dataWithBase64EncodedString:(NSString *)string;

- (NSString *)one_base64EncodedStringWithWrapWidth:(NSUInteger)wrapWidth;

- (NSString *)one_base64EncodedString;

@end

@interface NSData (ONEEncrypt)

/**
 *  利用AES加密数据
 *
 *  @param key key
 *  @param iv  iv description
 *
 *  @return data
 */
- (NSData *)one_encryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSData *)one_decryptedWithAESUsingKey:(NSString*)key andIV:(NSData*)iv;

/**
 *  利用3DES加密数据
 *
 *  @param key key
 *  @param iv  iv description
 *
 *  @return data
 */
- (NSData *)one_encryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;
- (NSData *)one_decryptedWith3DESUsingKey:(NSString*)key andIV:(NSData*)iv;

- (NSString *)one_UTF8String;
@end

@interface NSData (ONEMD5)

- (NSString *)one_MD5;

@end

