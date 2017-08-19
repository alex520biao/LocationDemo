//
//  ONECatchSelectorObject.m
//  Pods
//
//  Created by 张华威 on 2017/4/26.
//
//

#import "ONECatchSelectorObject.h"

@implementation ONECatchSelectorObject

- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self respondsToSelector:aSelector]) {
        return self;
    }
    return nil;
}

- (NSMethodSignature*)methodSignatureForSelector:(SEL)selector {
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        signature = [self methodSignatureForSelector:@selector(doNothing)];
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL invSEL = invocation.selector;
    if ([self respondsToSelector:invSEL]) {
        [invocation invokeWithTarget:self];
    } else {
        @try {
            NSCAssert(NO, @"警告：%@ 方法未找到", NSStringFromSelector(invSEL));
        } @catch (NSException *exception) {
            
        }
        //        [self doesNotRecognizeSelector:invSEL];
    }
}

- (void)doNothing {}

@end
