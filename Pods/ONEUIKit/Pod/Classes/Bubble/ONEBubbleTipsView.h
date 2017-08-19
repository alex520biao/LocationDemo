//
//  ONEBubbleTipsView.h
//  Pods
//
//  Created by guoyaoyuan on 16/5/30.
//
//

#import "ONEBubbleView.h"

/**
 Tips 视图（简单的，有图标和文字的气泡，文字支持多行）
 
 用法:
 
    ONEBubbleTipsView *tips = [ONEBubbleTipsView new];
    tips.text = @"点击这里修改出发时间";
    [tips updateSizeWithMaxWidth:CGFLOAT_MAX];
    tips.arrowPosition = tips.bounds.size.width - 30; // 箭头距右边位置
    tips.tapAction = ^(ONEBubbleTipsView *tips) {
        // [weakTips dismiss];
    };
 */


@class ONEBubbleTipsView;
typedef void (^ONEBubbleTipsViewCloseAction) (ONEBubbleTipsView *bubbleTipsView);

@interface ONEBubbleTipsView : ONEBubbleView

@property (nonatomic, strong) UIImage *icon;   ///< Tips 左侧的图标，默认 nil

/**
 Tips 文本,如需高亮,将高亮内容用{}包起来。
 */
@property (nonatomic, copy) NSString *text;
@property (nonatomic, assign) CGFloat maxWidth;  ///< 最大宽度
@property (nonatomic, assign) BOOL singleLine; ///< 只显示一行，超出部分显示...

/**
 设置点击关闭事件block
 @param closeAction 关闭事件block
 */
- (void)setCloseAction:(ONEBubbleTipsViewCloseAction)closeAction;

//- (void)updateSizeWithMaxWidth:(CGFloat)width; ///< 限定视图最大宽度，自动调整高度(默认为Bubble填满屏幕)

#pragma mark - 便捷方法

/**
 *  创建气泡View
 *
 *  @param text     显示的文本
 *
 */
+ (instancetype)viewWithText:(NSString *)text;

+ (instancetype)viewWithText:(NSString *)text canClose:(BOOL)canClose;

/**
 *   暂不开放
 @param text        文本
 @param maxWidth    最大视图宽度。如果文本容纳不下，则会自动换行。
 */
//+ (instancetype)viewWithText:(NSString *)text maxWidth:(CGFloat)maxWidth showDefaultIcon:(BOOL)showDefaultIcon;

/**
 *
 @param text     文本
 @param maxWidth 最大视图宽度。如果文本容纳不下，则会自动换行。
 */
+ (instancetype)viewWithText:(NSString *)text
                    maxWidth:(CGFloat)maxWidth
                        icon:(UIImage *)icon
                    canClose:(BOOL)canClose;
@end
