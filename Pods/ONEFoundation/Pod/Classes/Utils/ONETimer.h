//
//  KZTimer.h
//  DidDriver
//
//  Created by Tony on 2/11/15.
//  Copyright (c) 2015 xiaojukeji. All rights reserved.
//
//  为了解决 Timer retain self 问题，以及启动和关闭 timer 的繁琐过程简化

#import <Foundation/Foundation.h>

@interface ONETimer : NSObject

+ (ONETimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(id)userInfo repeats:(BOOL)yesOrNo;

+ (ONETimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti repeats:(BOOL)yesOrNo tickBlock:(void (^)(void))block;

- (void)start;
- (void)startAfter;
- (void)stop;
- (void)reset;

- (NSTimeInterval)duration;
- (BOOL)isValid;

@property (copy) NSDate *fireDate;

@end
