//
//  KZTimer.m
//  DidDriver
//
//  Created by Tony on 2/11/15.
//  Copyright (c) 2015 xiaojukeji. All rights reserved.
//

#import "ONETimer.h"
#import "ONELog.h"


// 用于被 NSTimer retain，并将 NSTimer 绑定的 SEL 消息转发给 realTarget
@interface ONEProxy : NSObject
@property (weak, nonatomic) id realTarget;
@end

@implementation ONEProxy

- (void)dealloc {
    LogDealloc();
}

// 1. 尝试快速消息转发
- (id)forwardingTargetForSelector:(SEL)aSelector {
    if ([self.realTarget respondsToSelector:aSelector]) {
        return self.realTarget;
    }
    return nil;
}

// 2. 快速消息转发失败，尝试标准消息转发
- (NSMethodSignature*) methodSignatureForSelector:(SEL)selector {
    NSMethodSignature* signature = [super methodSignatureForSelector:selector];
    if (!signature) {
        signature = [self.realTarget methodSignatureForSelector:selector];
    }
    
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    SEL invSEL = invocation.selector;
    if ([self.realTarget respondsToSelector:invSEL]) {
        [invocation invokeWithTarget:self.realTarget];
    } else {
        [self doesNotRecognizeSelector:invSEL];
    }
}

@end



@interface ONETimer ()

@property (nonatomic, strong) ONEProxy *proxy;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSTimeInterval ti;
@property (nonatomic, weak) id aTarget;
@property (nonatomic, assign) SEL aSelector;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, assign) BOOL repeats;

@property (nonatomic, copy) void (^tickBlock)(void);

@property (nonatomic, strong) NSDate *startDate;

@end

@implementation ONETimer

- (void)dealloc {
	[self.timer invalidate];
    LogDealloc();
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo {
	ONETimer *timer = [[ONETimer alloc] init];
	timer.ti = ti;
	timer.aTarget = aTarget;
	timer.aSelector = aSelector;
	timer.userInfo = userInfo;
	timer.repeats = yesOrNo;

	ONEProxy *proxy = [[ONEProxy alloc] init];
	proxy.realTarget = timer;
	timer.proxy = proxy;

	return timer;
}

+ (instancetype)scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo tickBlock:(void (^)(void))block {
    ONETimer *timer = [[ONETimer alloc] init];
    timer.ti = ti;
    timer.repeats = yesOrNo;
    timer.tickBlock = block;
    
    ONEProxy *proxy = [[ONEProxy alloc] init];
    proxy.realTarget = timer;
    timer.proxy = proxy;
    
    return timer;
}

- (void)timerFired:(NSTimer *)theTimer {
    
    NSString *info = @"none target!";
    if (self.aTarget && self.aSelector) {
        info = [NSString stringWithFormat:@"%@ %@", [self.aTarget class], NSStringFromSelector(self.aSelector)];
    }
    else if (self.tickBlock) {
        info = [NSString stringWithFormat:@"%@", self.tickBlock];
    }
    
    LogDebug(@"[%zd] Timer fired, [%@]", self.hash, info);
	
	if ([self.aTarget respondsToSelector:self.aSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		[self.aTarget performSelector:self.aSelector withObject:self];
#pragma clang diagnostic pop
	}
    
    if (self.tickBlock) {
        self.tickBlock();
    }
}

- (void)startAfter {
    [self stop];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.ti
                                                  target:self.proxy
                                                selector:@selector(timerFired:)
                                                userInfo:self.userInfo
                                                 repeats:self.repeats];
    self.startDate = self.timer.fireDate;
}

- (void)start {
    [self startAfter];
    self.startDate = [NSDate date];
	[self.timer fire];
}

- (void)stop {
	[self.timer invalidate];
	self.timer = nil;
}

- (void)reset {
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:self.timer.timeInterval];
    [self setFireDate:date];
}

#pragma mark - Extra

- (NSTimeInterval)duration {
    NSTimeInterval duration = -[self.startDate timeIntervalSinceNow];
    return duration;
}

- (BOOL)isValid {
    return self.timer.isValid;
}

- (void)setFireDate:(NSDate *)fireDate {
    @synchronized(self) {
        self.timer.fireDate = fireDate;
    }
}

- (NSDate*)fireDate {
    @synchronized(self) {
        return self.timer.fireDate;
    }
}

@end
