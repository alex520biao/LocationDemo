//
//  ONEBubbleGuideTipsView.m
//  Pods
//
//  Created by 张华威 on 2016/12/13.
//
//

#import "ONEBubbleGuideTipsView.h"

#import <ONEUIKit/ONEGuideLineView.h>

static const CGFloat kSmallDotSize = 4.f;

@interface ONEBubbleGuideTipsView ()

@property (nonatomic, strong) ONEGuideLineView *lineView;

@property (nonatomic, strong) UIView *dotView;

@end

@implementation ONEBubbleGuideTipsView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setFrame:(CGRect)frame {
    
    CGPoint oldPoint = self.frame.origin;
    [super setFrame:frame];
    CGPoint subPoint = CGPointMake(frame.origin.x - oldPoint.x, frame.origin.y - oldPoint.y);
    
    [self.lineView setFrame:CGRectMake(self.lineView.frame.origin.x + subPoint.x, self.lineView.frame.origin.y + subPoint.y, self.lineView.frame.size.width, self.lineView.frame.size.height)];
    [self.dotView setFrame:CGRectMake(self.dotView.frame.origin.x + subPoint.x, self.dotView.frame.origin.y + subPoint.y, self.dotView.frame.size.width, self.dotView.frame.size.height)];
    
}

- (ONEGuideLineView *)lineView {
    if (!_lineView) {
        _lineView = [[ONEGuideLineView alloc] init];
        [_lineView setLineLength:self.lineLength];
    }
    return _lineView;
}

- (void)setLineLength:(CGFloat)lineLength {
    [self.lineView setLineLength:lineLength];
    
    CGFloat subLineLength = lineLength - _lineLength;
    self.dotView.centerY += subLineLength;
    
    _lineLength = lineLength;
}

- (UIView *)dotView {
    if (!_dotView) {
        _dotView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kONEBubbleGuideTipsViewDotSize, kONEBubbleGuideTipsViewDotSize)];
        [_dotView.layer setCornerRadius:kONEBubbleGuideTipsViewDotSize / 2];
        [_dotView.layer setMasksToBounds:YES];
        [_dotView setBackgroundColor:kColorLightGray10];
        
        UIView *smallDot = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kSmallDotSize, kSmallDotSize)];
        [smallDot.layer setCornerRadius:kSmallDotSize / 2];
        [smallDot.layer setMasksToBounds:YES];
        [smallDot setBackgroundColor:kColorLightGray9];
        [_dotView addSubview:smallDot];
        smallDot.center = _dotView.center;
        
        [_dotView setHidden:YES];
    }
    return _dotView;
}

- (void)updateFrameWithDotPointCenter:(CGPoint)center {
    CGPoint oldCenter = self.dotView.center;
    
    CGPoint subCenter = CGPointMake(center.x - oldCenter.x, center.y - oldCenter.y);
    
    self.center = CGPointMake(self.center.x + subCenter.x, self.center.y + subCenter.y);
    self.lineView.center = CGPointMake(self.lineView.center.x + subCenter.x, self.lineView.center.y + subCenter.y);
    self.dotView.center = center;
//    CGPointMake(self.dotView.center.x + subCenter.x, self.dotView.center.y + subCenter.y);
    
}

- (CGFloat)arrowSize {
    return 0;
}

- (void)showAnimation {
    
    [self.superview insertSubview:self.lineView belowSubview:self];
    [self.superview insertSubview:self.dotView belowSubview:self];
    
    [self.lineView setFrame:CGRectMake(self.x + self.arrowPositionRatio * self.width, self.y + self.height, self.lineView.width, self.lineView.height)];
    [self.dotView setFrame:CGRectMake(0, self.lineView.frame.origin.y + self.lineView.height, self.dotView.width, self.dotView.height)];
    [self.dotView setCenterX:self.lineView.centerX];
    
    self.hidden = YES;
    [self.dotView setHidden:NO];
    [self.lineView showWithAnimation:YES completion:^{
        self.hidden = NO;
        [super showAnimation];
    }];
    
}

- (void)dismiss {
    [super dismiss];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.lineView dismissWithAnimation:YES completion:^{
            [self.dotView setHidden:YES];
            [self removeFromSuperview];
            [self.dotView removeFromSuperview];
            [self.lineView removeFromSuperview];
        }];
    });
}

@end
