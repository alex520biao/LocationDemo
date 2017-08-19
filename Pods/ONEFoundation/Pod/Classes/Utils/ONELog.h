//
//  ONENetLog.h
//  Pods
//
//  Created by Tony on 7/4/16.
//
//

#ifndef ONELog_h
#define ONELog_h

#if __has_include(<TheOne/DDCustomLogger.h>)
#import <TheOne/DDCustomLogger.h>
#else
#define LogInfo NSLog
#define LogWarn NSLog
#define LogBreakpoint NSLog
#define LogDebug NSLog
#define LogError NSLog
#define DDLogError NSLog
#define DDLogInfo NSLog
#define DDLogWarn NSLog
#define DDLogDebug NSLog
#define LogDealloc()            LogDebug(@">>>>> | %@ | dealloc", NSStringFromClass([self class]))
#endif

#endif /* ONENetLog_h */
