//
//  ONEProgressHUD+Custom.h
//  CloudAlbum
//
//  Created by alex on 13-7-29.
//  Copyright (c) 2013年 com.baidu. All rights reserved.
//

#import "ONEProgressHUD.h"

@interface ONEProgressHUD (Custom)

#pragma mark 进度展示
/*
 * 展示进度，默认使用ONEProgressHUDModeIndeterminate及pending...文本,默认屏蔽背景用户操作
 */
+ (ONEProgressHUD *)showOnView:(UIView *)view;

/*
 * 展示进度，默认使用ONEProgressHUDModeIndeterminate，指定labelText文本,默认屏蔽背景用户操作
 */
+ (ONEProgressHUD *)showOnView:(UIView *)view labelText:(NSString*)labelText;

#pragma mark 结果展示
/*
 * 展示纯文本，不建议使用
 */
+ (void)showOnViewFinishTxt:(UIView *)view  labelText:(NSString*)labelText;

/*
 * 展示纯文本，不建议使用
 */
+ (void)showOnViewFinishTxt:(UIView *)view  labelText:(NSString*)labelText modalEnabled:(BOOL)modalEnabled;

/*
 * 展示成功icon及文本结果，2s后自动消失
 * view：当view==nil时，使用window作为view
 * 屏蔽背景用户操作
 */
+ (void)showOnViewSucceedImg:(UIView *)view  labelText:(NSString*)labelText;

/*
 * 展示成功icon及文本结果，2s后自动消失
 * view：当view==nil时，使用window作为view
 * 屏蔽背景用户操作
 */
+ (void)showOnViewSucceedImg:(UIView *)view  labelText:(NSString*)labelText modalEnabled:(BOOL)modalEnabled;

/*
 * 展示失败icon及文本结果，2s后自动消失
 * view：当view==nil时，使用window作为view
 * 屏蔽背景用户操作
 */
+ (void)showOnViewErrorImg:(UIView *)view  labelText:(NSString*)labelText;

/*
 * 展示失败icon及文本结果，2s后自动消失
 * view：当view==nil时，使用window作为view
 * 屏蔽背景用户操作
 */
+ (void)showOnViewErrorImg:(UIView *)view  labelText:(NSString*)labelText modalEnabled:(BOOL)modalEnabled;

/*
 * 展示警告icon及文本结果，2s后自动消失
 * view：当view==nil时，使用window作为view
 * 屏蔽背景用户操作
 */
+ (void)showOnViewWarnImg:(UIView *)view  labelText:(NSString*)labelText modalEnabled:(BOOL)modalEnabled;

/*
 * 展示警告icon及文本结果，2s后自动消失
 * view：当view==nil时，使用window作为view
 * 屏蔽背景用户操作
 */
+ (void)showOnViewWarnImg:(UIView *)view  labelText:(NSString*)labelText;

#pragma mark normal

+ (ONEProgressHUD *)showOnView:(UIView *)view
                          mode:(ONEProgressHUDMode)mode
                    customView:(UIView*)customView
                        insets:(UIEdgeInsets)edgeInsets
                     labelText:(NSString*)labelText
                     hideDelay:(NSTimeInterval)hideDelay
                  modalEnabled:(BOOL)modalEnabled;

+ (ONEProgressHUD *)showOnView:(UIView *)view
                          mode:(ONEProgressHUDMode)mode
                    customView:(UIView*)customView
                        insets:(UIEdgeInsets)edgeInsets
                     labelText:(NSString*)labelText
                     hideDelay:(NSTimeInterval)hideDelay;

+ (void)dismissForView:(UIView *)view;

+ (void)dismissForView:(UIView *)view animated:(BOOL)animated;

// windowForHUD
+ (UIWindow *)windowForHUD;

/**
 取最上层Window的便捷方法

 @return 最上层window
 */
+ (UIWindow *)TopWindow;

#pragma mark switch
+ (void)switchToWarningHud:(ONEProgressHUD *)hud withText:(NSString *)text;

+ (void)switchToSuccessHud:(ONEProgressHUD *)hud withText:(NSString *)text;

+ (void)switchToErrorHud:(ONEProgressHUD *)hud withText:(NSString *)text;

@end
