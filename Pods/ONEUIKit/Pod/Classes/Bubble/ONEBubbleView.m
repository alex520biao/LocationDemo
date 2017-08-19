//
//  ONEBubbleView.m
//  ONEUIKit
//
//  Created by Su Ziming on 16/5/16.
//  Copyright © 2016年 Su Ziming. All rights reserved.
//

#import "ONEBubbleView.h"
#import "ONEUIKitTheme.h"

static const CGFloat kAnimationDuration = .2f;
static const CGFloat kAnimationBounceDuration = .2f;
static const CGFloat kAnimationBounceTimes = 1.1f;

@interface ONEBubbleView ()
@property (nonatomic, strong) CAShapeLayer *bubbleLayer;
@property (nonatomic, strong) UITapGestureRecognizer *tapGesture;
@end

@implementation ONEBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    [self initBubble];
    [self reloadBubbleLayer];
    return self;
}

#pragma mark - content

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateContentViewPosition];
    [self reloadBubbleLayer];
}

- (void)setContentView:(UIView *)contentView {
    if (_contentView != contentView) {
        if (_contentView.superview == self) {
            [_contentView removeFromSuperview];
        }
        _contentView = contentView;
        if (_contentView) {
            [self addSubview:_contentView];
        }
    }
    [self updateWithContentView];
}

- (void)updateWithContentView {
    CGRect frame = self.frame;
    frame.size.width = self.bubblePadding * 2 + self.contentView.frame.size.width;
    frame.size.height = self.bubblePadding * 2 + self.contentView.frame.size.height;
    switch (self.arrowDirection) {
        case ONEBubbleArrowDirectionUp:
        case ONEBubbleArrowDirectionDown: {
            frame.size.height += self.arrowSize;
        } break;
        case ONEBubbleArrowDirectionLeft:
        case ONEBubbleArrowDirectionRight: {
            frame.size.width += self.arrowSize;
        } break;
        default: break;
    }    
    self.frame = frame;
    [self setNeedsLayout];
}

- (void)updateContentViewPosition {
    CGRect frame = self.contentView.frame;
    frame.origin = CGPointMake(self.bubblePadding, self.bubblePadding);
    if (self.arrowDirection == ONEBubbleArrowDirectionUp) {
        frame.origin.y += self.arrowSize;
    } else if (self.arrowDirection == ONEBubbleArrowDirectionLeft) {
        frame.origin.x += self.arrowSize;
    }
    self.contentView.frame = frame;
}

#pragma mark - properties

- (void)setArrowDirection:(ONEBubbleArrowDirection)arrowDirection {
    if (_arrowDirection != arrowDirection) {
        switch (arrowDirection) {
            case ONEBubbleArrowDirectionUp:
            case ONEBubbleArrowDirectionDown:
            case ONEBubbleArrowDirectionLeft:
            case ONEBubbleArrowDirectionRight:break;
            default: arrowDirection = ONEBubbleArrowDirectionDown;
        }
        _arrowDirection = arrowDirection;
    }
    [self updateContentViewPosition];
    [self updateWithContentView];
    [self setNeedsLayout];
}

- (void)setArrowSize:(CGFloat)arrowSize {
    if (_arrowSize != arrowSize) {
        _arrowSize = arrowSize;
        [self setNeedsLayout];
    }
}

- (void)setArrowRadius:(CGFloat)arrowRadius {
    if (_arrowRadius != arrowRadius) {
        _arrowRadius = arrowRadius;
        [self setNeedsLayout];
    }
}

- (void)setArrowPositionRatio:(CGFloat)arrowPositionRatio {
    if (_arrowPositionRatio != arrowPositionRatio) {
        _arrowPositionRatio = arrowPositionRatio;
        [self setNeedsLayout];
    }
}

- (void)setArrowPosition:(CGFloat)arrowPosition {
    switch (self.arrowDirection) {
        case ONEBubbleArrowDirectionUp:
        case ONEBubbleArrowDirectionDown: {
            CGFloat width = self.frame.size.width;
            if (width > 0) {
                self.arrowPositionRatio = arrowPosition / width;
            }
        } break;
        case ONEBubbleArrowDirectionLeft:
        case ONEBubbleArrowDirectionRight: {
            CGFloat height = self.frame.size.height;
            if (height > 0) {
                self.arrowPositionRatio = arrowPosition / height;
            }
        } break;
        default: break;
    }
}

- (CGFloat)arrowPosition {
    switch (self.arrowDirection) {
        case ONEBubbleArrowDirectionUp:
        case ONEBubbleArrowDirectionDown: {
            return _arrowPositionRatio * self.frame.size.width;
        } break;
        case ONEBubbleArrowDirectionLeft:
        case ONEBubbleArrowDirectionRight: {
            return _arrowPositionRatio * self.frame.size.height;
        } break;
        default: return 0;
    }
}

- (void)setBubblePadding:(CGFloat)bubblePadding {
    if (_bubblePadding != bubblePadding) {
        _bubblePadding = bubblePadding;
        [self setNeedsLayout];
    }
}

- (void)setBubbleCornerRadius:(CGFloat)bubbleCornerRadius {
    if (_bubbleCornerRadius != bubbleCornerRadius) {
        _bubbleCornerRadius = bubbleCornerRadius;
        [self setNeedsLayout];
    }
}

- (void)setBubbleFillColor:(UIColor *)bubbleFillColor {
    _bubbleFillColor = bubbleFillColor;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    
    _bubbleLayer.fillColor = _bubbleFillColor.CGColor;
    [CATransaction commit];
}

- (void)setBubbleStrokeColor:(UIColor *)bubbleStrokeColor {
    _bubbleStrokeColor = bubbleStrokeColor;
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _bubbleLayer.strokeColor = _bubbleStrokeColor.CGColor;
    [CATransaction commit];
}

- (void)setTapAction:(void (^)(__kindof ONEBubbleView *))tapAction {
    _tapAction = [tapAction copy];
    if (_tapAction) {
        if (!_tapGesture) {
            _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
            [self addGestureRecognizer:_tapGesture];
        }
    } else {
        if (_tapGesture) {
            [self removeGestureRecognizer:_tapGesture];
            _tapGesture = nil;
        }
    }
}

- (void)handleTap:(id)gesture {
    if (_tapAction) _tapAction(self);
}

- (void)showAnimation {
    
    self.hidden = NO;
    [_tapGesture setEnabled:YES];
    
    CGPoint realPoint = self.frame.origin;
    
    CGPoint bouncePoint;
    CGPoint arrowPoint;
    
    switch (self.arrowDirection) {
        case ONEBubbleArrowDirectionUp: {
            arrowPoint = CGPointMake(realPoint.x + self.arrowPosition, realPoint.y);
//            bouncePoint = CGPointMake(self.center.x, self.center.y + (kAnimationBounceTimes - 1.f) * self.frame.size.height / 2);
        } break;
            
        case ONEBubbleArrowDirectionDown: {
            arrowPoint = CGPointMake(realPoint.x + self.arrowPosition, realPoint.y + self.frame.size.height);
//            bouncePoint = CGPointMake(self.center.x, self.center.y - (kAnimationBounceTimes - 1.f) * self.frame.size.height / 2);
        } break;
            
        case ONEBubbleArrowDirectionLeft: {
            arrowPoint = CGPointMake(realPoint.x, realPoint.y + self.arrowPosition);
//            bouncePoint = CGPointMake(self.center.x + (kAnimationBounceTimes - 1.f) * self.frame.size.width / 2, self.center.y);
        } break;
            
        case ONEBubbleArrowDirectionRight: {
            arrowPoint = CGPointMake(realPoint.x + self.frame.size.width, realPoint.y + self.arrowPosition);
//            bouncePoint = CGPointMake(self.center.x - (kAnimationBounceTimes - 1.f) * self.frame.size.width / 2, self.center.y);
        } break;
    }
    
    bouncePoint = CGPointMake(self.center.x * kAnimationBounceTimes - (kAnimationBounceTimes - 1.f) * arrowPoint.x,
                              self.center.y * kAnimationBounceTimes - (kAnimationBounceTimes - 1.f) * arrowPoint.y
                              );
    
    // size 放大
    CABasicAnimation *animationBounceSize = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationBounceSize.fillMode = kCAFillModeForwards;
    animationBounceSize.removedOnCompletion = NO;
    animationBounceSize.repeatCount = 1;
    animationBounceSize.duration = kAnimationDuration;
    animationBounceSize.beginTime = CACurrentMediaTime();
    animationBounceSize.fromValue = [NSNumber numberWithFloat:0];
    animationBounceSize.toValue = [NSNumber numberWithFloat:kAnimationBounceTimes];
    
    // 缩小
    CABasicAnimation *animationSize = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationSize.fillMode = kCAFillModeForwards;
    animationSize.removedOnCompletion = NO;
    animationSize.repeatCount = 1;
    animationSize.duration = kAnimationBounceDuration;
    animationSize.beginTime = CACurrentMediaTime() + kAnimationDuration;
    animationSize.fromValue = [NSNumber numberWithFloat:kAnimationBounceTimes];
    animationSize.toValue = [NSNumber numberWithFloat:1];
    
    // 放大位置变化
    CABasicAnimation *animationBouncePosition = [CABasicAnimation animationWithKeyPath:@"position"];
    animationBouncePosition.removedOnCompletion = NO;
    animationBouncePosition.fillMode = kCAFillModeForwards;
    animationBouncePosition.duration = kAnimationDuration;
    animationBouncePosition.repeatCount = 1;
    animationBouncePosition.beginTime = CACurrentMediaTime();
    animationBouncePosition.fromValue = [NSValue valueWithCGPoint:arrowPoint];
    animationBouncePosition.toValue = [NSValue valueWithCGPoint:bouncePoint];
    
    // 缩小位置变化
    CABasicAnimation *animationPosition = [CABasicAnimation animationWithKeyPath:@"position"];
    animationPosition.removedOnCompletion = NO;
    animationPosition.fillMode = kCAFillModeForwards;
    animationPosition.duration = kAnimationBounceDuration;
    animationPosition.repeatCount = 1;
    animationPosition.beginTime = CACurrentMediaTime() + kAnimationDuration;
    animationPosition.fromValue = [NSValue valueWithCGPoint:bouncePoint];
    animationPosition.toValue = [NSValue valueWithCGPoint:self.center];
    
    
    [self.layer addAnimation:animationBounceSize forKey:@"AnimationBounce"];
    [self.layer addAnimation:animationSize forKey:@"AnimationSize"];
    
    [self.layer addAnimation:animationBouncePosition forKey:@"bounce-layer"];
    [self.layer addAnimation:animationPosition forKey:@"move-layer"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((kAnimationDuration+kAnimationBounceDuration) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.layer removeAllAnimations];
    });

}

- (void)dismissAfterDelay:(NSTimeInterval)delay {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismiss];
    });
}

- (void)dismiss{
    
    [_tapGesture setEnabled:NO];
    
    CGPoint realPoint = self.frame.origin;
    
    CGPoint bouncePoint;
    CGPoint arrowPoint;
    
    switch (self.arrowDirection) {
        case ONEBubbleArrowDirectionUp: {
            arrowPoint = CGPointMake(realPoint.x + self.arrowPosition, realPoint.y);
//            bouncePoint = CGPointMake(self.center.x, self.center.y + (kAnimationBounceTimes - 1.f) * self.frame.size.height / 2);
        } break;
            
        case ONEBubbleArrowDirectionDown: {
            arrowPoint = CGPointMake(realPoint.x + self.arrowPosition, realPoint.y + self.frame.size.height);
//            bouncePoint = CGPointMake(self.center.x, self.center.y - (kAnimationBounceTimes - 1.f) * self.frame.size.height / 2);
        } break;
            
        case ONEBubbleArrowDirectionLeft: {
            arrowPoint = CGPointMake(realPoint.x, realPoint.y + self.arrowPosition);
//            bouncePoint = CGPointMake(self.center.x + (kAnimationBounceTimes - 1.f) * self.frame.size.width / 2, self.center.y);
        } break;
            
        case ONEBubbleArrowDirectionRight: {
            arrowPoint = CGPointMake(realPoint.x + self.frame.size.width, realPoint.y + self.arrowPosition);
//            bouncePoint = CGPointMake(self.center.x - (kAnimationBounceTimes - 1.f) * self.frame.size.width / 2, self.center.y);
        } break;
    }
    
    bouncePoint = CGPointMake(self.center.x * kAnimationBounceTimes - (kAnimationBounceTimes - 1.f) * arrowPoint.x,
                              self.center.y * kAnimationBounceTimes - (kAnimationBounceTimes - 1.f) * arrowPoint.y
                              );
    
    // size 放大
    CABasicAnimation *animationBounceSize = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationBounceSize.fillMode = kCAFillModeForwards;
    animationBounceSize.removedOnCompletion = NO;
    animationBounceSize.repeatCount = 1;
    animationBounceSize.duration = kAnimationBounceDuration;
    animationBounceSize.beginTime = CACurrentMediaTime();
    animationBounceSize.fromValue = [NSNumber numberWithFloat:1];
    animationBounceSize.toValue = [NSNumber numberWithFloat:kAnimationBounceTimes];
    
    // 缩小
    CABasicAnimation *animationSize = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animationSize.fillMode = kCAFillModeForwards;
    animationSize.removedOnCompletion = NO;
    animationSize.repeatCount = 1;
    animationSize.duration = kAnimationDuration;
    animationSize.beginTime = CACurrentMediaTime() + kAnimationBounceDuration;
    animationSize.fromValue = [NSNumber numberWithFloat:kAnimationBounceTimes];
    animationSize.toValue = [NSNumber numberWithFloat:0];
    
    // 放大位置变化
    CABasicAnimation *animationBouncePosition = [CABasicAnimation animationWithKeyPath:@"position"];
    animationBouncePosition.removedOnCompletion = NO;
    animationBouncePosition.fillMode = kCAFillModeForwards;
    animationBouncePosition.duration = kAnimationBounceDuration;
    animationBouncePosition.repeatCount = 1;
    animationBouncePosition.beginTime = CACurrentMediaTime();
    animationBouncePosition.fromValue = [NSValue valueWithCGPoint:self.center];
    animationBouncePosition.toValue = [NSValue valueWithCGPoint:bouncePoint];
    
    // 缩小位置变化
    CABasicAnimation *animationPosition = [CABasicAnimation animationWithKeyPath:@"position"];
    animationPosition.removedOnCompletion = NO;
    animationPosition.fillMode = kCAFillModeForwards;
    animationPosition.duration = kAnimationDuration;
    animationPosition.repeatCount = 1;
    animationPosition.beginTime = CACurrentMediaTime() + kAnimationBounceDuration;
    animationPosition.fromValue = [NSValue valueWithCGPoint:bouncePoint];
    animationPosition.toValue = [NSValue valueWithCGPoint:arrowPoint];
    
    [self.layer addAnimation:animationBounceSize forKey:@"AnimationBounce"];
    [self.layer addAnimation:animationSize forKey:@"AnimationSize"];
    
    [self.layer addAnimation:animationBouncePosition forKey:@"bounce-layer"];
    [self.layer addAnimation:animationPosition forKey:@"move-layer"];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((kAnimationDuration + kAnimationBounceDuration + .5f) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.hidden = YES;
        [self.layer removeAllAnimations];
        [self removeFromSuperview];
    });

}

/*
- (void)setPointWithArrowPoint:(CGPoint)arrowPoint {
    
}
 */

#pragma mark - private

- (void)initBubble {
    _arrowDirection = ONEBubbleArrowDirectionDown;
    _arrowPositionRatio = 0.5;
    _arrowSize = 5;
    _arrowRadius = 1;
    _bubblePadding = 0;
    _bubbleCornerRadius = 2;
    _bubbleFillColor = kColorLightGray9;
    _bubbleStrokeColor = kColorClear;

    _bubbleLayer = [CAShapeLayer layer];
    _bubbleLayer.frame = self.bounds;
    _bubbleLayer.fillColor = kColorLightGray9.CGColor;
    _bubbleLayer.shouldRasterize = YES;
    _bubbleLayer.rasterizationScale = [UIScreen mainScreen].scale;
    [self.layer addSublayer:_bubbleLayer];
}

- (void)reloadBubbleLayer {
    
    UIBezierPath *path = [self.class pathWithBubbleSize:self.bounds.size
                                                padding:self.bubblePadding
                                           cornerRadius:self.bubbleCornerRadius
                                         arrowDirection:self.arrowDirection
                                              arrowSize:self.arrowSize
                                            arrowRadius:self.arrowRadius
                                          arrowPositionRatio:self.arrowPositionRatio];
    
    // disable path animation
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    _bubbleLayer.path = path.CGPath;
    _bubbleLayer.frame = self.bounds;
    [CATransaction commit];
}

/// Creates a bubble path (returns nil on error)
+ (UIBezierPath *)pathWithBubbleSize:(CGSize)size // layer size
                             padding:(CGFloat)padding
                        cornerRadius:(CGFloat)cornerRadius
                      arrowDirection:(ONEBubbleArrowDirection)arrowDirection
                           arrowSize:(CGFloat)arrowSize
                         arrowRadius:(CGFloat)arrowRadius
                  arrowPositionRatio:(CGFloat)arrowPositionRatio // [0, 1]
{
    // validate
    if (size.width <= 0 || size.height <= 0) return nil;
    if (padding < 0) padding = 0;
    if (padding >= MIN(size.width, size.height)) return nil;
    cornerRadius = MIN(cornerRadius, (MIN(size.width, size.height) - 2 * padding) / 2);
    if (cornerRadius < 0) cornerRadius = 0;
    if (arrowSize < 0) arrowSize = 0;
    if (arrowRadius < 0) arrowRadius = 0;
    if (arrowRadius > arrowSize / sqrt(2)) arrowRadius = arrowSize / sqrt(2);
    
    // arrow
    CGFloat arrowPos = 0; // absolute position in point
    if (arrowDirection == ONEBubbleArrowDirectionLeft ||
        arrowDirection == ONEBubbleArrowDirectionRight) {
        arrowPos = size.height * arrowPositionRatio;
        arrowPos = MAX(arrowPos, padding + cornerRadius + arrowSize);
        arrowPos = MIN(arrowPos, size.height - padding - cornerRadius - arrowSize);
    } else {
        arrowPos = size.width * arrowPositionRatio;
        arrowPos = MAX(arrowPos, padding + cornerRadius + arrowSize);
        arrowPos = MIN(arrowPos, size.width - padding - cornerRadius - arrowSize);
    }
    
    // corner position
    CGFloat x1 = padding;
    CGFloat x2 = size.width - padding;
    CGFloat y1 = padding;
    CGFloat y2 = size.height - padding;
    CGFloat sqrtArrowRadius = sqrt(arrowRadius);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    switch (arrowDirection) {
        case ONEBubbleArrowDirectionLeft: x1 += arrowSize; x2 += arrowSize;
        case ONEBubbleArrowDirectionRight: x2 -= arrowSize; break;
//        case ONEBubbleArrowDirectionRight: y2 -= arrowSize; break;
        case ONEBubbleArrowDirectionUp: y1 += arrowSize; break;
        case ONEBubbleArrowDirectionDown: y2 -= arrowSize; break;
    }
    
    //  pixel align (描边是 1px, path 需要对齐到像素中间位置)
    CGFloat scale = [UIScreen mainScreen].scale;
    x1 = (floor(x1 * scale) + 0.5) / scale;
    x2 = (floor(x2 * scale) + 0.5) / scale;
    y1 = (floor(y1 * scale) + 0.5) / scale;
    y2 = (floor(y2 * scale) + 0.5) / scale;
    arrowPos = (floor(arrowPos * scale)) / scale;
    
    // start
    [path moveToPoint:(CGPoint){x1, y1 + cornerRadius}];
    // top-left
    [path addQuadCurveToPoint:(CGPoint){x1 + cornerRadius, y1} controlPoint:(CGPoint){x1, y1}];
    // top
    if (arrowDirection == ONEBubbleArrowDirectionUp) {
        [path addLineToPoint:(CGPoint){arrowPos - arrowSize, y1}];
        [path addLineToPoint:(CGPoint){arrowPos - sqrtArrowRadius, y1 - arrowSize + sqrtArrowRadius}];
        [path addQuadCurveToPoint:(CGPoint){arrowPos + sqrtArrowRadius, y1 - arrowSize + sqrtArrowRadius} controlPoint:(CGPoint){arrowPos, y1 - arrowSize}];
        [path addLineToPoint:(CGPoint){arrowPos + arrowSize, y1}];
    }
    [path addLineToPoint:CGPointMake(x2 - cornerRadius, y1)];
    // top-right
    [path addQuadCurveToPoint:(CGPoint){x2, y1 + cornerRadius} controlPoint:(CGPoint){x2, y1}];
    // right
    if (arrowDirection == ONEBubbleArrowDirectionRight) {
//        arrowPos -= 2;
        [path addLineToPoint:(CGPoint){x2, arrowPos - arrowSize}];
        [path addLineToPoint:(CGPoint){x2 + arrowSize - sqrtArrowRadius, arrowPos - sqrtArrowRadius}];
        [path addQuadCurveToPoint:(CGPoint){x2 + arrowSize - sqrtArrowRadius, arrowPos + sqrtArrowRadius} controlPoint:(CGPoint){x2 + arrowSize, arrowPos}];
        [path addLineToPoint:(CGPoint){x2, arrowPos + arrowSize}];
    }
    [path addLineToPoint:(CGPoint){x2, y2 - cornerRadius}];
    // bottom-right
    [path addQuadCurveToPoint:(CGPoint){x2 - cornerRadius, y2} controlPoint:(CGPoint){x2, y2}];
    // bottom
    if (arrowDirection == ONEBubbleArrowDirectionDown) {
        [path addLineToPoint:(CGPoint){arrowPos + arrowSize, y2}];
        [path addLineToPoint:(CGPoint){arrowPos + sqrtArrowRadius, y2 + arrowSize - sqrtArrowRadius}];
        [path addQuadCurveToPoint:(CGPoint){arrowPos - sqrtArrowRadius, y2 + arrowSize - sqrtArrowRadius} controlPoint:(CGPoint){arrowPos, y2 + arrowSize}];
        [path addLineToPoint:(CGPoint){arrowPos - arrowSize, y2}];
    }
    [path addLineToPoint:(CGPoint){x1 + cornerRadius, y2}];
    // bottom-left
    [path addQuadCurveToPoint:(CGPoint){x1, y2 - cornerRadius} controlPoint:(CGPoint){x1, y2}];
    // left
    if (arrowDirection == ONEBubbleArrowDirectionLeft) {
//        arrowPos -= 2;
        [path addLineToPoint:(CGPoint){x1, arrowPos + arrowSize}];
        [path addLineToPoint:(CGPoint){x1 - arrowSize + sqrtArrowRadius, arrowPos + sqrtArrowRadius}];
        [path addQuadCurveToPoint:(CGPoint){x1 - arrowSize + sqrtArrowRadius, arrowPos - sqrtArrowRadius} controlPoint:(CGPoint){x1 - arrowSize, arrowPos}];
        [path addLineToPoint:(CGPoint){x1, arrowPos - arrowSize}];
    }
    [path closePath];
    
    return path;
}

@end
