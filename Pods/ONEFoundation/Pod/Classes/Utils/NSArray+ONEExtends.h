//
//  NSArray+ONTExtends.h
//  Pods
//
//  Created by zhanghuawei on 7/4/16.
//
//

#import <Foundation/Foundation.h>

/****************	Immutable Array		****************/

@interface NSArray (ONEExtends)

/**
 return value if index is valid, return nil if others.
 */
- (id)one_objectAtIndex:(NSUInteger)index;

/**
 return @"" if value is nil or NSNull; return value if NSString or NSNumber class; return nil if others
 */
- (NSString*)one_stringWithIndex:(NSUInteger)index;

/**
 return nil if value is nil or NSNull; return NSDictionary if value is NSDictionary; return nil if others.
 */
- (NSDictionary*)one_dictionaryWithIndex:(NSUInteger)index;

@end


/****************	Mutable Array		****************/

@interface NSMutableArray(ONESafeAccess)

/**
 add object if object is not nil; add object if object is [NSNull null]; do nothing if object is nil.
 */
- (void)one_addObject:(id)object;

@end

@interface NSArray(ONEJSONString)

- (NSString *)one_JSONString;

- (NSString *)one_JSONStringWithOptions:(NSJSONWritingOptions)opt;

@end
