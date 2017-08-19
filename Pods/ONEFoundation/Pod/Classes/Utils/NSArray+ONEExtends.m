//
//  NSArray+ONTExtends.m
//  Pods
//
//  Created by zhanghuawei on 7/4/16.
//
//

#import "NSArray+ONEExtends.h"

@implementation NSArray (ONEExtends)

- (id)one_objectAtIndex:(NSUInteger)index{
    if (index < self.count) {
        return self[index];
    }else{
        return nil;
    }
}

- (NSString*)one_stringWithIndex:(NSUInteger)index{
    id value = [self one_objectAtIndex:index];
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


- (NSDictionary*)one_dictionaryWithIndex:(NSUInteger)index
{
    id value = [self one_objectAtIndex:index];
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

@end


@implementation NSMutableArray(ONESafeAccess)

-(void)one_addObject:(id)object{
    if (object != nil) {
        [self addObject:object];
    }
}

@end

@implementation NSArray(ONEJSONString)

-(NSString *)one_JSONString{
    NSString *jsonString = [self one_JSONStringWithOptions:NSJSONWritingPrettyPrinted];
    return jsonString;
}

- (NSString *)one_JSONStringWithOptions:(NSJSONWritingOptions)opt {
    NSError *error = nil;
    NSData *jsonData;
    @try {
        jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                   options:opt
                                                     error:&error];
    } @catch (NSException *exception) {
        
    }
    if (jsonData == nil) {
#ifdef DEBUG
        NSLog(@"fail to get JSON from array: %@, error: %@", self, error);
#endif
        return nil;
    }
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

@end
