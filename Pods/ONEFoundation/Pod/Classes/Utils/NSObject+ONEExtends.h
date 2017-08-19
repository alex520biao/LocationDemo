//
//  NSObject+ONEExtends.h
//  Pods
//
//  Created by zhanghuawei on 16/10/8.
//
//

#import <Foundation/Foundation.h>

@interface NSObject (ONEBlocks)

+ (id)one_performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
- (id)one_performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;

- (void)one_performOnMainThread:(void(^)(void))block wait:(BOOL)wait;

- (void)one_performAfter:(NSTimeInterval)seconds block:(void(^)(void))block;

- (void)one_performBlockOnMainThread:(void(^)(void))block afterDelay:(NSTimeInterval)delay;

@end

@interface NSObject (ONEAssociatedObject)

- (void)one_associateValue:(id)value withKey:(void *)key; // Strong reference

- (void)one_weaklyAssociateValue:(id)value withKey:(void *)key;

- (id)one_associatedValueForKey:(void *)key;

- (id)one_associatedValueForKey:(void *)key class:(Class)cls;

@end
