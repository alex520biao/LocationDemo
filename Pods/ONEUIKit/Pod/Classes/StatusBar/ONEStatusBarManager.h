//
//  ONEStatusBarManager.h
//  Pods
//
//  Created by 张华威 on 2017/3/17.
//
//

#import <UIKit/UIKit.h>
#import <ONEFoundation/ONEFoundation.h>

typedef NS_ENUM(NSInteger, ONEStatusBarPriority) {
    ONEStatusBarPriorityDebug = -1, // = -1
    ONEStatusBarPriorityDefault,    // = 0
    ONEStatusBarPriorityWarn,       // = 1
    ONEStatusBarPriorityError,      // = 2
    ONEStatusBarPriorityFatal,      // = 3
};

@interface ONEStatusBarManager : NSObject

ARC_SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(ONEStatusBarManager)

/**
 在 StatusBar 显示

 @param text 显示文案(NSString 或 NSAttributedString)
 @param didTouchedBlock 用户点击block
 @param secs 显示时间，单位秒 值为0时会一只显示
 @param priority  优先级，如果当前有高优先级 UI 存在时，直接忽略本次调用；如果当前没有 UI 展示或者当前展示的优先级较低，则展示本次调用的 UI
 @param identifier 唯一标识当前的 UI，例如：地图定位作为同一类 UI，当隐藏 UI 时，只有当前的 identifier 一致才隐藏
 @return YES 表示本地调用有效，真实展示了；NO 表示本次调用无效，没有真实展示
 */
- (BOOL)showText:(id)text didTouched:(void(^)())didTouchedBlock hideAfter:(NSUInteger)secs priority:(ONEStatusBarPriority)priority withIdentifier:(NSString *)identifier;

/**
 隐藏 StatusBar
 @param identifier 当隐藏 UI 时，只有当前的 identifier 一致才隐藏
 @return YES 表示本地调用有效，真实隐藏了；NO 表示本次调用无效，没有真实隐藏
 */
- (BOOL)hideWithIdentifier:(NSString *)identifier;

@property (nonatomic, assign, readonly) BOOL isShowing;

@end
