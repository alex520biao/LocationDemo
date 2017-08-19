//
//  UIView+ONEExtends.h
//  Pods
//
//  Created by didi on 16/10/10.
//
//

#import <UIKit/UIKit.h>
#import <UIView+Positioning/UIView+Positioning.h>

@interface UIView (TTCategory)

/**
 * Removes all subviews.
 */
- (void)one_removeAllSubviews;

/**
 * The view controller whose view contains this view.
 */
- (UIViewController*)one_viewController;

@end

@interface UIView (Screenshot)

- (UIImage *)one_screenshot DEPRECATED_MSG_ATTRIBUTE("use captureScreenshot");

//原有截屏方法
- (UIImage *)one_captureScreenshot;

// 截屏(结局iPhone6界面闪动问题)
- (UIImage *)one_captureScreenshotNew;

@end

typedef void (^GestureActionBlock)(UIGestureRecognizer *gestureRecoginzer);

@interface UIView (BlockGesture)

- (void)one_addTapActionWithBlock:(GestureActionBlock)block;

@end
