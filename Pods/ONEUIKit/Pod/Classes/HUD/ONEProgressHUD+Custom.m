//
//  ONEProgressHUD+Custom.m
//  CloudAlbum
//
//  Created by alex on 13-7-29.
//  Copyright (c) 2013年 com.baidu. All rights reserved.
//

#import "ONEProgressHUD+Custom.h"
#import "ONEUIKitTheme.h"
#import <ONEFoundation/ONELocalizedString.h>

#define kMsgtDisplayDuration 2.0f  //信息展示时长
@implementation ONEProgressHUD (Custom)

#pragma mark 进度展示
+ (ONEProgressHUD *)showOnView:(UIView *)view{
    UIEdgeInsets edgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    return [ONEProgressHUD showOnView:view
                                 mode:ONEProgressHUDModeIndeterminate
                           customView:nil
                               insets:edgeInsets
                            labelText:ONELocalizedStr(@"loading", @"ONEUIKit-HUD")
                            hideDelay:0
                         modalEnabled:YES];
}

+ (ONEProgressHUD *)showOnView:(UIView *)view labelText:(NSString*)labelText{
    UIEdgeInsets edgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    return [ONEProgressHUD showOnView:view
                                 mode:ONEProgressHUDModeIndeterminate
                           customView:nil
                               insets:edgeInsets
                            labelText:labelText
                            hideDelay:0 modalEnabled:YES];
}


#pragma mark 结果展示

+ (void)showOnViewFinishTxt:(UIView *)view labelText:(NSString *)labelText {
    [ONEProgressHUD showOnViewFinishTxt:view labelText:labelText modalEnabled:NO];
}

+ (void)showOnViewFinishTxt:(UIView *)view  labelText:(NSString*)labelText modalEnabled:(BOOL)modalEnabled{
    UIEdgeInsets edgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    if (view == nil) {
    }
    
    [ONEProgressHUD showOnView:view
                          mode:ONEProgressHUDModeText
                    customView:nil
                        insets:edgeInsets
                     labelText:labelText
                     hideDelay:kMsgtDisplayDuration modalEnabled:modalEnabled];
}

+ (void)showOnViewSucceedImg:(UIView *)view  labelText:(NSString*)labelText {
    [ONEProgressHUD showOnViewSucceedImg:view labelText:labelText modalEnabled:NO];
}

+ (void)showOnViewSucceedImg:(UIView *)view  labelText:(NSString*)labelText modalEnabled:(BOOL)modalEnabled{
    UIEdgeInsets edgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    UIImage *image = [ONEUIKitTheme imageNamed:@"toast_icon_right" inBundle:@"HUD"];
    UIImageView *customView=[[UIImageView alloc] initWithImage:image];
    customView.frame=CGRectMake(0, 0, 45, 45);
    
    if (view == nil) {
        view = [self windowForHUD];
    }
    
    [ONEProgressHUD showOnView:view
                         mode:ONEProgressHUDModeCustomView
                   customView:customView
                       insets:edgeInsets
                    labelText:labelText
                    hideDelay:kMsgtDisplayDuration modalEnabled:modalEnabled];
}

+ (void)showOnViewErrorImg:(UIView *)view  labelText:(NSString*)labelText{
    [ONEProgressHUD showOnViewErrorImg:view labelText:labelText modalEnabled:NO];
}

+ (void)showOnViewErrorImg:(UIView *)view labelText:(NSString *)labelText modalEnabled:(BOOL)modalEnabled {
    UIEdgeInsets edgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    UIImage *errorImage = [ONEUIKitTheme imageNamed:@"toast_icon_warning" inBundle:@"HUD"];
    UIImageView *customView=[[UIImageView alloc] initWithImage:errorImage];
    customView.frame=CGRectMake(0, 0, 45, 45);
    
    if (view == nil) {
        view = [self windowForHUD];
    }
    
    [ONEProgressHUD showOnView:view
                         mode:ONEProgressHUDModeCustomView
                   customView:customView
                       insets:edgeInsets
                    labelText:labelText
                     hideDelay:kMsgtDisplayDuration modalEnabled:modalEnabled];
    
}

/*
 * 展示警告icon及文本结果，2s后自动消失
 */
+ (void)showOnViewWarnImg:(UIView *)view  labelText:(NSString*)labelText {
    [ONEProgressHUD showOnViewWarnImg:view labelText:labelText modalEnabled:NO];
}

+ (void)showOnViewWarnImg:(UIView *)view  labelText:(NSString*)labelText modalEnabled:(BOOL)modalEnabled {
    UIEdgeInsets edgeInsets=UIEdgeInsetsMake(0, 0, 0, 0);
    UIImage *exclamationMarkImage = [ONEUIKitTheme imageNamed:@"toast_icon_warning" inBundle:@"HUD"];
    UIImageView *customView=[[UIImageView alloc] initWithImage:exclamationMarkImage];
    customView.frame=CGRectMake(0, 0, 45, 45);
    
    if (view == nil) {
        view = [self windowForHUD];
    }
    
    [ONEProgressHUD showOnView:view
                         mode:ONEProgressHUDModeCustomView
                   customView:customView
                       insets:edgeInsets
                    labelText:labelText
                    hideDelay:kMsgtDisplayDuration
                  modalEnabled:modalEnabled];
}

#pragma mark switch

+ (void)switchToSuccessHud:(ONEProgressHUD *)hud withText:(NSString *)text {
    UIImage *image = [ONEUIKitTheme imageNamed:@"toast_icon_right" inBundle:@"HUD"];
    [self.class switchToImage:image hud:hud withText:text];
}

+ (void)switchToWarningHud:(ONEProgressHUD *)hud withText:(NSString *)text {
    UIImage *image = [ONEUIKitTheme imageNamed:@"toast_icon_warning" inBundle:@"HUD"];
    [self.class switchToImage:image hud:hud withText:text];
}

+ (void)switchToErrorHud:(ONEProgressHUD *)hud withText:(NSString *)text {
    UIImage *image = [ONEUIKitTheme imageNamed:@"toast_icon_warning" inBundle:@"HUD"];
    [self.class switchToImage:image hud:hud withText:text];
}

+ (void)switchToImage:(UIImage *)image hud:(ONEProgressHUD *)hud withText:(NSString *)text {
    UIImageView *customView = [[UIImageView alloc] initWithImage:image];
    
    hud.mode = ONEProgressHUDModeCustomView;
    hud.customView = customView;
    hud.labelText = text;
    [hud hide:YES afterDelay:2];
}

#pragma mark normal

+ (ONEProgressHUD *)showOnView:(UIView *)view mode:(ONEProgressHUDMode)mode customView:(UIView *)customView insets:(UIEdgeInsets)edgeInsets labelText:(NSString *)labelText hideDelay:(NSTimeInterval)hideDelay {
    return [ONEProgressHUD showOnView:view mode:mode customView:customView insets:edgeInsets labelText:labelText hideDelay:hideDelay modalEnabled:NO];
}

+ (ONEProgressHUD *)showOnView:(UIView *)view
              mode:(ONEProgressHUDMode)mode
        customView:(UIView*)customView
            insets:(UIEdgeInsets)edgeInsets
         labelText:(NSString*)labelText
         hideDelay:(NSTimeInterval)hideDelay
      modalEnabled:(BOOL)modalEnabled{
    
    if (view == nil) {
        view = [self windowForHUD];
    }
    
    ONEProgressHUD* HUD = [ONEProgressHUD HUDForView:view];
    if (HUD==nil) {
        HUD=[ONEProgressHUD showHUDAddedTo:view animated:YES];
        HUD.removeFromSuperViewOnHide=YES;
        HUD.dimBackground = NO;//背景是否黑色半透明效果
    }else{
    }
    
    //mode和labelText
    HUD.mode       = mode;
    
    HUD.labelText  = labelText;
    
    HUD.margin     = 15;                    //MB内边距
    HUD.labelFont  = kFontSizeMedium;       //label字体
    HUD.labelColor = kColorLightGray8;           //label颜色

    //取消当前延迟调用及所有动画
    [ONEProgressHUD cancelPreviousPerformRequestsWithTarget:HUD];
    [HUD.layer removeAllAnimations];
    
    //如果HUD已经存在则显示时不使用动画
    [HUD show:NO];
    
    
    //customView不为nil则优先使用customView
    if (mode==ONEProgressHUDModeCustomView&&customView) {
        HUD.customView=customView;
    }else{
        HUD.customView=nil;
    }
    
    //根据edgeInsets重新设置HUD的frame以及调整子视图布局及重绘
    //    CGRect newFrame=UIEdgeInsetsInsetRect(view.bounds, edgeInsets);
    //    HUD.frame=newFrame;
    HUD.xOffset = edgeInsets.left - edgeInsets.right;
    HUD.yOffset = edgeInsets.top - edgeInsets.bottom;
    
    [HUD setNeedsLayout];
    [HUD setNeedsDisplay];
    
    //hideDelay>0时表示提示信息自动隐藏
    if (hideDelay>0) {
        //隐藏时不能使用动画
        [HUD hide:NO afterDelay:hideDelay];
    }
    HUD.userInteractionEnabled = modalEnabled;//HUD接收用户事件,屏蔽后面视图的用户操作
    
    UIAccessibilityPostNotification(UIAccessibilityAnnouncementNotification, HUD.labelText);
    
    return HUD;
}

+ (void)dismissForView:(UIView *)view{
    if (view == nil) {
        view = [self windowForHUD];
    }
    
    [ONEProgressHUD hideAllHUDsForView:view animated:YES];
}

// 隐藏loading框
+ (void)dismissForView:(UIView *)view animated:(BOOL)animated{
    if (view == nil) {
        view = [self windowForHUD];
    }
    
    [ONEProgressHUD hideAllHUDsForView:view animated:animated];
}

+ (UIWindow *)windowForHUD{
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    return window;
}

+ (UIWindow *)TopWindow {
    UIWindow * window = [[UIApplication sharedApplication].delegate window];
    if ([[UIApplication sharedApplication] windows].count > 1) {
        NSArray *windowsArray = [[UIApplication sharedApplication] windows];
        window = [windowsArray lastObject];
    }
    
    return window;
}

@end
