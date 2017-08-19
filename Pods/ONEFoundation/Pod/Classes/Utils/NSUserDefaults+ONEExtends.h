//
//  NSUserDefaults+ONEExtends.h
//  Pods
//
//  Created by zhanghuawei on 16/10/9.
//
//

#import <Foundation/Foundation.h>

@interface NSUserDefaults (ONESafeAccess)
+ (NSString *)one_stringForKey:(NSString *)defaultName;

+ (NSArray *)one_arrayForKey:(NSString *)defaultName;

+ (NSDictionary *)one_dictionaryForKey:(NSString *)defaultName;

+ (NSData *)one_dataForKey:(NSString *)defaultName;

+ (NSArray *)one_stringArrayForKey:(NSString *)defaultName;

+ (NSInteger)one_integerForKey:(NSString *)defaultName;

+ (float)one_floatForKey:(NSString *)defaultName;

+ (double)one_doubleForKey:(NSString *)defaultName;

+ (BOOL)one_boolForKey:(NSString *)defaultName;

+ (NSURL *)one_URLForKey:(NSString *)defaultName;

#pragma mark - WRITE FOR STANDARD

+ (void)one_setObject:(id)value forKey:(NSString *)defaultName;

#pragma mark - READ ARCHIVE FOR STANDARD

+ (id)one_arcObjectForKey:(NSString *)defaultName;

#pragma mark - WRITE ARCHIVE FOR STANDARD

+ (void)one_setArcObject:(id)value forKey:(NSString *)defaultName;
@end
