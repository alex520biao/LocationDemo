//
//  ONECustomGuideView.h
//  Pods
//
//  Created by Liushulong on 1/19/16.
//
//
#if 0
#import <UIKit/UIKit.h>

/**
 *  自定义的引导视图
 */
@interface ONECustomGuideView : UIView

/**
 弹出引导弹框
 
 @param topImage     顶部图片
 @param message      标题
 @param subMessage   次标题 (nullable)
 @param tipMessage   次次标题 (nullable)
 @param confirmTitle 确定按钮文案
 @param cancelTitle  取消按钮文案 (nullable)
 @param completion   按钮回调
 */
+ (ONECustomGuideView *)showCustomGuideViewWithTopImage:(UIImage *)topImage
                                                message:(NSString *)message
                                             subMessage:(NSString *)subMessage
                                             tipMessage:(NSString *)tipMessage
                                           confirmTitle:(NSString *)confirmTitle
                                            cancelTitle:(NSString *)cancelTitle
                                             completion:(void (^)(BOOL confirm))completion;
/**
 隐藏并移除。
 */
- (void)dismiss;


#pragma mark 便捷方法 (compatible)
+ (void)showNotificationAlertWithConfirmBlock:(void(^)())confirmBlock;

+ (void)showLocationAlertWithConfirmBlock:(void(^)())confirmBlock;

@end
#endif