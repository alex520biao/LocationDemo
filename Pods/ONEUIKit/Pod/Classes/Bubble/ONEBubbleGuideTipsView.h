//
//  ONEBubbleGuideTipsView.h
//  Pods
//
//  Created by 张华威 on 2016/12/13.
//
//

#import <ONEUIKit/ONEUIKit.h>

static const CGFloat kONEBubbleGuideTipsViewDotSize = 9.f;

@interface ONEBubbleGuideTipsView : ONEBubbleTipsView

@property (nonatomic, assign) CGFloat lineLength; ///< 虚线长度

- (void)updateFrameWithDotPointCenter:(CGPoint)center; ///< 通过设置圆点中心更新Frame

@end
