//
//  ONEGuideLineView.h
//  Pods
//
//  Created by 张华威 on 2016/12/13.
//
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    ONEGuideLineViewStyleToTop, ///< 向上
    ONEGuideLineViewStyleToBottom,
    ONEGuideLineViewStyleToLeft,
    ONEGuideLineViewStyleToRight,
} ONEGuideLineViewStyle;

@interface ONEGuideLineView : UIView

@property (nonatomic, assign) CGFloat lineLength; ///< 线条长度

@property (nonatomic, assign) ONEGuideLineViewStyle style; ///< 线条朝向，默认向上

@property (nonatomic, strong) UIColor *lineColor; ///< 线条颜色， 默认kColorLightGray9

@property (nonatomic, assign) CGFloat lineWidth; ///< 线宽，默认0.5

@property (nonatomic, assign) CGFloat subLineLength; ///< 一截线的长度，默认

@property (nonatomic, assign) CGFloat subSpacelength; ///< 一截空白的长度，默认

- (void)showWithAnimation:(BOOL)animation completion:(void (^)(void))completion ;

- (void)dismissWithAnimation:(BOOL)animation completion:(void (^)(void))completion ;

@end
