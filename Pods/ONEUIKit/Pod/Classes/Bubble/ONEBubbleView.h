//
//  ONEBubbleView.h
//  ONEUIKit
//
//  Created by Su Ziming on 16/5/16.
//  Copyright © 2016年 Su Ziming. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 泡泡箭头指向
typedef NS_ENUM(NSUInteger, ONEBubbleArrowDirection) {
    ONEBubbleArrowDirectionUp,     ///< 向上
    ONEBubbleArrowDirectionDown,   ///< 向下 (默认)
    ONEBubbleArrowDirectionLeft,   ///< 向左
    ONEBubbleArrowDirectionRight,  ///< 向右
};


/**
 泡泡视图
 
 用法：
     // 创建并配置内容视图
     UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
     
     // 把内容视图放到 bubble 内
     ONEBubbleView *bubble = [ONEBubbleView new];
     bubble.contentView = contentView;
     bubble.left = 10;
     bubble.top = 100;
     [self.view addSubview:bubble];
 */
@interface ONEBubbleView : UIView

#pragma mark 内容

@property (nonatomic, strong) UIView *contentView; ///< 内容视图，填充在泡泡内部，默认nil。设置后，泡泡大小会进行调整。
- (void)updateWithContentView; ///< 当 contentView 宽高发生变化后，需要调用这个方法来更新泡泡视图。

#pragma mark 样式
@property (nonatomic, assign) ONEBubbleArrowDirection arrowDirection; ///< 箭头方向, 默认向下
@property (nonatomic, assign) CGFloat arrowPositionRatio;   ///< 相对箭头位置，以 view 左上角为原点, 取值 [0,1], 默认0.5
@property (nonatomic, assign) CGFloat arrowPosition;        ///< 箭头位置(对相对箭头位置的封装)，以 view 左上角为原点
@property (nonatomic, assign) CGFloat arrowSize;            ///< 箭头突出高度, 默认5
@property (nonatomic, assign) CGFloat arrowRadius;          ///< 箭头的尖角弧度半径, 默认1
@property (nonatomic, assign) CGFloat bubblePadding;        ///< 泡泡边缘留白 (从泡泡边缘到 view 边缘), 默认0
@property (nonatomic, assign) CGFloat bubbleCornerRadius;   ///< 泡泡四个圆角半径, 默认2
@property (nonatomic, strong) UIColor *bubbleFillColor;     ///< 泡泡填充颜色，默认#4a4c5b
@property (nonatomic, strong) UIColor *bubbleStrokeColor;   ///< 泡泡描边颜色，默认clear
//@property (nonatomic, assign) BOOL showLayer;               ///< 显示阴影，默认不显示

#pragma mark 事件
@property (nonatomic, copy) void(^tapAction)(__kindof ONEBubbleView* bubble); ///< 点击回调
- (void)dismiss; ///< 渐隐并移除
- (void)dismissAfterDelay:(NSTimeInterval)delay; ///< 延迟消失
- (void)showAnimation; ///< 展示动画

// todo
//- (void)setPointWithArrowPoint:(CGPoint) arrowPoint;

@end
