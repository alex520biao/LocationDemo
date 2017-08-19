//
//  NSDictionary+ONEExtends.m
//  Pods
//
//  Created by zhanghuawei on 16/8/31.
//
//

#import "NSDictionary+ONEExtends.h"

@implementation NSDictionary (ONEJSONString)

-(NSString *)one_JSONString{
    NSString *jsonString = [self one_JSONStringWithOptions:NSJSONWritingPrettyPrinted];
    return jsonString;
}

- (NSString *)one_JSONStringWithOptions:(NSJSONWritingOptions)opt {
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:opt
                                                         error:&error];
    if (jsonData == nil) {
#ifdef DEBUG
        NSLog(@"fail to get JSON from dictionary: %@, error: %@", self, error);
#endif
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end

@implementation NSDictionary (ONESafeAccess)

- (BOOL)one_hasKey:(NSString *)key
{
    return [self objectForKey:key] != nil;
}
- (NSString*)one_stringForKey:(id)key
{
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSString class]]) {
        return (NSString*)value;
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value stringValue];
    }
    
    return nil;
}

- (NSString*)one_stringForKey:(id)key defaultValue:(NSString *)defaultValue{
    if (key != nil && [key conformsToProtocol: @protocol(NSCopying)]) {
        id ret = [self objectForKey:key];
        if (ret != nil && ret != [NSNull null]) {
            if ([ret isKindOfClass:[NSString class]]) {
                    return ret;
            }
            else if ([ret isKindOfClass:[NSDecimalNumber class]]) {
                return [NSString stringWithFormat:@"%@", ret];
            }
            else if ([ret isKindOfClass:[NSNumber class]]) {
                return [NSString stringWithFormat:@"%@", ret];
            }
        }
    }

    return defaultValue;
}

- (NSNumber*)one_numberForKey:(id)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSNumber class]]) {
        return (NSNumber*)value;
    }
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        return [f numberFromString:(NSString*)value];
    }
    return nil;
}

- (NSDecimalNumber *)one_decimalNumberForKey:(id)key {
    id value = [self objectForKey:key];
    
    if ([value isKindOfClass:[NSDecimalNumber class]]) {
        return value;
    } else if ([value isKindOfClass:[NSNumber class]]) {
        NSNumber * number = (NSNumber*)value;
        return [NSDecimalNumber decimalNumberWithDecimal:[number decimalValue]];
    } else if ([value isKindOfClass:[NSString class]]) {
        NSString * str = (NSString*)value;
        return [str isEqualToString:@""] ? nil : [NSDecimalNumber decimalNumberWithString:str];
    }
    return nil;
}
- (NSArray*)one_arrayForKey:(id)key
{
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSArray class]])
    {
        return value;
    }
    return nil;
}

- (NSDictionary*)one_dictionaryForKey:(id)key
{
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    if ([value isKindOfClass:[NSDictionary class]])
    {
        return value;
    }
    return nil;
}

- (NSInteger)one_integerForKey:(id)key
{
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value integerValue];
    }
    return 0;
}

- (NSUInteger)one_unsignedIntegerForKey:(id)key{
    id value = [self objectForKey:key];
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]])
    {
        return [value unsignedIntegerValue];
    }
    return 0;
}

- (BOOL)one_boolForKey:(id)key
{
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return NO;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value boolValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value boolValue];
    }
    return NO;
}

// 从 NSDictionary 中获取 key 对应的 bool 型value; 若无，则返回 defaultValue
- (BOOL)one_boolForKey:(id)key defaultValue:(BOOL)defaultValue{
    if (key != nil && [key conformsToProtocol: @protocol(NSCopying)]) {
        id ret = [self objectForKey:key];
        if (ret != nil && ret != [NSNull null] && ([ret isKindOfClass:[NSDecimalNumber class]] || [ret isKindOfClass:[NSNumber class]] || [ret isKindOfClass:[NSString class]])) {
            return [ret boolValue];
        }
    }
    
    return defaultValue;
}

- (int16_t)one_int16ForKey:(id)key
{
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (int32_t)one_int32ForKey:(id)key
{
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}
- (int64_t)one_int64ForKey:(id)key
{
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value longLongValue];
    }
    return 0;
}
- (char)one_charForKey:(id)key{
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value charValue];
    }
    return 0;
}
- (short)one_shortForKey:(id)key
{
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]])
    {
        return [value shortValue];
    }
    if ([value isKindOfClass:[NSString class]])
    {
        return [value intValue];
    }
    return 0;
}

- (float)one_floatForKey:(id)key
{
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value floatValue];
    }
    return 0;
}

- (double)one_doubleForKey:(id)key
{
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return 0;
    }
    if ([value isKindOfClass:[NSNumber class]] || [value isKindOfClass:[NSString class]])
    {
        return [value doubleValue];
    }
    return 0;
}

- (long long)one_longLongForKey:(id)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]] || [value isKindOfClass:[NSNumber class]]) {
        return [value longLongValue];
    }
    return 0;
}

- (unsigned long long)one_unsignedLongLongForKey:(id)key
{
    id value = [self objectForKey:key];
    if ([value isKindOfClass:[NSString class]]) {
        NSNumberFormatter *nf = [[NSNumberFormatter alloc] init];
        value = [nf numberFromString:value];
    }
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value unsignedLongLongValue];
    }
    return 0;
}

- (NSDate *)one_dateForKey:(id)key dateFormat:(NSString *)dateFormat{
    NSDateFormatter *formater = [[NSDateFormatter alloc]init];
    formater.dateFormat = dateFormat;
    id value = [self objectForKey:key];
    
    if (value == nil || value == [NSNull null])
    {
        return nil;
    }
    
    if ([value isKindOfClass:[NSString class]] && ![value isEqualToString:@""] &&dateFormat) {
        return [formater dateFromString:value];
    }
    return nil;
}


//CG
- (CGFloat)one_CGFloatForKey:(id)key
{
    CGFloat f = [self[key] doubleValue];
    return f;
}

- (CGPoint)one_pointForKey:(id)key
{
    CGPoint point = CGPointFromString(self[key]);
    return point;
}
- (CGSize)one_sizeForKey:(id)key
{
    CGSize size = CGSizeFromString(self[key]);
    return size;
}
- (CGRect)one_rectForKey:(id)key
{
    CGRect rect = CGRectFromString(self[key]);
    return rect;
}
@end

#pragma --mark NSMutableDictionary setter
@implementation NSMutableDictionary (ONESafeAccess)

- (void)one_setValue:(id)i forKey:(NSString*)key{
    if (i != nil) {
        [self setValue:i forKey:key];
    }
}

// 在aValue为nil时，删除原来的key
- (void)one_setValueEx:(id)aValue forKey:(NSString *)aKey{
    if (aValue != nil) {
        [self setValue:aValue forKey:aKey];
    }else{
        [self removeObjectForKey:aKey];
    }
}

-(void)one_setString:(NSString*)i forKey:(NSString*)key;
{
    [self setValue:i forKey:key];
}

-(void)one_setBool:(BOOL)i forKey:(NSString *)key
{
    self[key] = @(i);
}

-(void)one_setInt:(int)i forKey:(NSString *)key
{
    self[key] = @(i);
}

-(void)one_setInteger:(NSInteger)i forKey:(NSString *)key
{
    self[key] = @(i);
}

-(void)one_setUnsignedInteger:(NSUInteger)i forKey:(NSString *)key
{
    self[key] = @(i);
}

-(void)one_setCGFloat:(CGFloat)f forKey:(NSString *)key
{
    self[key] = @(f);
}

-(void)one_setChar:(char)c forKey:(NSString *)key
{
    self[key] = @(c);
}

-(void)one_setFloat:(float)i forKey:(NSString *)key
{
    self[key] = @(i);
}

-(void)one_setDouble:(double)i forKey:(NSString*)key{
    self[key] = @(i);
}

-(void)one_setLongLong:(long long)i forKey:(NSString*)key{
    self[key] = @(i);
}

-(void)one_setPoint:(CGPoint)o forKey:(NSString *)key
{
    self[key] = NSStringFromCGPoint(o);
}

-(void)one_setSize:(CGSize)o forKey:(NSString *)key
{
    self[key] = NSStringFromCGSize(o);
}

-(void)one_setRect:(CGRect)o forKey:(NSString *)key
{
    self[key] = NSStringFromCGRect(o);
}

@end

@implementation NSDictionary (ONEURI)
+ (NSDictionary *)one_dictionaryWithURLQuery:(NSString *)query
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    NSArray *parameters = [query componentsSeparatedByString:@"&"];
    for(NSString *parameter in parameters) {
        NSArray *contents = [parameter componentsSeparatedByString:@"="];
        //        if([contents count] == 2) {
        NSString *key = [contents firstObject];
        NSString *value = [contents count] == 2 ? [contents objectAtIndex:1] :@"";
        value = [value stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (key && value) {
            [dict setObject:value forKey:key];
        }
        //        }
    }
    return [NSDictionary dictionaryWithDictionary:dict];
}

- (NSString *)one_URLQueryString
{
    NSMutableString *string = [NSMutableString string];
    for (NSString *key in [self allKeys]) {
        if ([string length]) {
            [string appendString:@"&"];
        }
        CFStringRef escaped = CFURLCreateStringByAddingPercentEscapes(NULL,(CFStringRef)[[self objectForKey:key] description],
                                                                      NULL,(CFStringRef)@"!*'();:@&=+$,/?%#[]",
                                                                      kCFStringEncodingUTF8);
        [string appendFormat:@"%@=%@", key, escaped];
        CFRelease(escaped);
    }
    return string;
}
@end


