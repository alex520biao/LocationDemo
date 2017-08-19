//
//  NSURL+ONEExtends.m
//  Pods
//
//  Created by zhanghuawei on 16/10/9.
//
//

#import "NSURL+ONEExtends.h"

@implementation NSURL (ONEParam)
- (NSDictionary *)one_parameters
{
    NSMutableDictionary * parametersDictionary = [NSMutableDictionary dictionary];
    NSArray * queryComponents = [self.query componentsSeparatedByString:@"&"];
    for (NSString * queryComponent in queryComponents) {
        NSString * key = [queryComponent componentsSeparatedByString:@"="].firstObject;
        if (key.length+1 < queryComponent.length)
        {
            NSString * value = [queryComponent substringFromIndex:(key.length + 1)];
            [parametersDictionary setObject:value forKey:key];
        }
    }
    return parametersDictionary;
}
- (NSString *)one_valueForParameter:(NSString *)parameterKey
{
    return [[self one_parameters] objectForKey:parameterKey];
}
@end

static NSString *const uq_URLReservedChars  = @"￼=,!$&'()*+;@?\r\n\"<>#\t :/";
static NSString *const kQuerySeparator      = @"&";
static NSString *const kQueryDivider        = @"=";
static NSString *const kQueryBegin          = @"?";
static NSString *const kFragmentBegin       = @"#";

@implementation NSURL (ONEURLQuery)

- (NSDictionary*) one_queryDictionary {
    return self.query.one_URLQueryDictionary;
}

- (NSURL*) one_URLByAppendingQueryDictionary:(NSDictionary*) queryDictionary {
    return [self one_URLByAppendingQueryDictionary:queryDictionary withSortedKeys:NO];
}

- (NSURL *)one_URLByAppendingQueryDictionary:(NSDictionary *)queryDictionary
                             withSortedKeys:(BOOL)sortedKeys
{
    NSMutableArray *queries = [self.query length] > 0 ? @[self.query].mutableCopy : @[].mutableCopy;
    NSString *dictionaryQuery = [queryDictionary one_URLQueryStringWithSortedKeys:sortedKeys];
    if (dictionaryQuery) {
        [queries addObject:dictionaryQuery];
    }
    NSString *newQuery = [queries componentsJoinedByString:kQuerySeparator];
    
    if (newQuery.length) {
        NSArray *queryComponents = [self.absoluteString componentsSeparatedByString:kQueryBegin];
        if (queryComponents.count) {
            return [NSURL URLWithString:
                    [NSString stringWithFormat:@"%@%@%@%@%@",
                     queryComponents[0],                      // existing url
                     kQueryBegin,
                     newQuery,
                     self.fragment.length ? kFragmentBegin : @"",
                     self.fragment.length ? self.fragment : @""]];
        }
    }
    return self;
}

- (NSURL*) one_URLByRemovingQuery {
    NSArray *queryComponents = [self.absoluteString componentsSeparatedByString:kQueryBegin];
    if (queryComponents.count) {
        return [NSURL URLWithString:queryComponents.firstObject];
    }
    return self;
}

- (NSURL *)one_URLByReplacingQueryWithDictionary:(NSDictionary *)queryDictionary {
    return [self one_URLByReplacingQueryWithDictionary:queryDictionary withSortedKeys:NO];
}

- (NSURL*) one_URLByReplacingQueryWithDictionary:(NSDictionary*) queryDictionary
                                 withSortedKeys:(BOOL) sortedKeys
{
    NSURL *stripped = [self one_URLByRemovingQuery];
    return [stripped one_URLByAppendingQueryDictionary:queryDictionary withSortedKeys:sortedKeys];
}

@end

#pragma mark -

@implementation NSString (ONEURLQuery)

- (NSDictionary*) one_URLQueryDictionary {
    NSMutableDictionary *mute = @{}.mutableCopy;
    for (NSString *query in [self componentsSeparatedByString:kQuerySeparator]) {
        NSArray *components = [query componentsSeparatedByString:kQueryDivider];
        if (components.count == 0) {
            continue;
        }
        NSString *key = [components[0] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        id value = nil;
        if (components.count == 1) {
            // key with no value
            value = [NSNull null];
        }
        if (components.count == 2) {
            value = [components[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            // cover case where there is a separator, but no actual value
            value = [value length] ? value : [NSNull null];
        }
        if (components.count > 2) {
            // invalid - ignore this pair. is this best, though?
            continue;
        }
        mute[key] = value ?: [NSNull null];
    }
    return mute.count ? mute.copy : nil;
}

@end

#pragma mark -

@implementation NSDictionary (ONEURLQuery)

static inline NSString *uq_URLEscape(NSString *string);

- (NSString *)one_URLQueryString {
    return [self one_URLQueryStringWithSortedKeys:NO];
}

- (NSString*) one_URLQueryStringWithSortedKeys:(BOOL)sortedKeys {
    NSMutableString *queryString = @"".mutableCopy;
    NSArray *keys = sortedKeys ? [self.allKeys sortedArrayUsingSelector:@selector(compare:)] : self.allKeys;
    for (NSString *key in keys) {
        id rawValue = self[key];
        NSString *value = nil;
        // beware of empty or null
        if (!(rawValue == [NSNull null] || ![rawValue description].length)) {
            value = one_URLEscape([self[key] description]);
        }
        [queryString appendFormat:@"%@%@%@%@",
         queryString.length ? kQuerySeparator : @"",    // appending?
         one_URLEscape(key),
         value ? kQueryDivider : @"",
         value ? value : @""];
    }
    return queryString.length ? queryString.copy : nil;
}

static inline NSString *one_URLEscape(NSString *string) {
    return ((__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (__bridge CFStringRef)string,
                                                                                  NULL,
                                                                                  (__bridge CFStringRef)uq_URLReservedChars,
                                                                                  kCFStringEncodingUTF8));
}

@end

