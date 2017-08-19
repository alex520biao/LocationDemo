//
//  NSDictionary+ONEExtends.h
//  Pods
//
//  Created by zhanghuawei on 16/8/31.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (ONEJSONString)

- (NSString *)one_JSONString;

- (NSString *)one_JSONStringWithOptions:(NSJSONWritingOptions)opt;

@end

@interface NSDictionary (ONESafeAccess)

- (BOOL)one_hasKey:(NSString *)key;

- (NSString*)one_stringForKey:(id)key;
- (NSString*)one_stringForKey:(id)key defaultValue:(NSString *)defaultValue;

- (NSNumber*)one_numberForKey:(id)key;

- (NSDecimalNumber *)one_decimalNumberForKey:(id)key;

- (NSArray*)one_arrayForKey:(id)key;

- (NSDictionary*)one_dictionaryForKey:(id)key;

- (NSInteger)one_integerForKey:(id)key;

- (NSUInteger)one_unsignedIntegerForKey:(id)key;

- (BOOL)one_boolForKey:(id)key;
// 从 NSDictionary 中获取 key 对应的 bool 型value; 若无，则返回 defaultValue
- (BOOL)one_boolForKey:(id)aKey defaultValue:(BOOL)defaultValue;

- (int16_t)one_int16ForKey:(id)key;

- (int32_t)one_int32ForKey:(id)key;

- (int64_t)one_int64ForKey:(id)key;

- (char)one_charForKey:(id)key;

- (short)one_shortForKey:(id)key;

- (float)one_floatForKey:(id)key;

- (double)one_doubleForKey:(id)key;

- (long long)one_longLongForKey:(id)key;

- (unsigned long long)one_unsignedLongLongForKey:(id)key;

- (NSDate *)one_dateForKey:(id)key dateFormat:(NSString *)dateFormat;

//CG
- (CGFloat)one_CGFloatForKey:(id)key;

- (CGPoint)one_pointForKey:(id)key;

- (CGSize)one_sizeForKey:(id)key;

- (CGRect)one_rectForKey:(id)key;
@end

#pragma --mark NSMutableDictionary setter

@interface NSMutableDictionary(ONESafeAccess)

- (void)one_setValue:(id)i forKey:(NSString*)key;
- (void)one_setValueEx:(id)aValue forKey:(NSString *)aKey;

-(void)one_setString:(NSString*)i forKey:(NSString*)key;

-(void)one_setBool:(BOOL)i forKey:(NSString*)key;

-(void)one_setInt:(int)i forKey:(NSString*)key;

-(void)one_setInteger:(NSInteger)i forKey:(NSString*)key;

-(void)one_setUnsignedInteger:(NSUInteger)i forKey:(NSString*)key;

-(void)one_setCGFloat:(CGFloat)f forKey:(NSString*)key;

-(void)one_setChar:(char)c forKey:(NSString*)key;

-(void)one_setFloat:(float)i forKey:(NSString*)key;

-(void)one_setDouble:(double)i forKey:(NSString*)key;

-(void)one_setLongLong:(long long)i forKey:(NSString*)key;

-(void)one_setPoint:(CGPoint)o forKey:(NSString*)key;

-(void)one_setSize:(CGSize)o forKey:(NSString*)key;

-(void)one_setRect:(CGRect)o forKey:(NSString*)key;

@end

@interface NSDictionary (ONEURL)
+ (NSDictionary *)one_dictionaryWithURLQuery:(NSString *)query;
- (NSString *)one_URLQueryString;
@end
