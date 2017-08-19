//
//  ONEMacros.h
//  Pods
//
//  Created by Tony on 7/8/16.
//
//



#ifndef ONEMacros_h
#define ONEMacros_h

#import <UIKit/UIKit.h>

// @header
#define ARC_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(SS_CLASSNAME)	\
+ (SS_CLASSNAME *)sharedInstance;

// @implementation
#define ARC_SYNTHESIZE_SINGLETON_FOR_CLASS(SS_CLASSNAME) \
+ (SS_CLASSNAME *)sharedInstance { \
static SS_CLASSNAME *_##SS_CLASSNAME##_sharedInstance = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_##SS_CLASSNAME##_sharedInstance = [[self alloc] init]; \
}); \
return _##SS_CLASSNAME##_sharedInstance; \
}


#define SafeBlockRun(block, ...) block ? block(__VA_ARGS__) : nil

#define APP_VERSION      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

#endif /* ONENetworkingMacros_h */



