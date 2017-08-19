//
//  ONEGuideLineView.m
//  Pods
//
//  Created by 张华威 on 2016/12/13.
//
//

#import "ONEGuideLineView.h"
#import <ONEUIKit/ONEUIKitTheme.h>

static const CGFloat kDefaultLineWidth = 1.f;
static const CGFloat kDefaultSubLineLength = 4.f;
static const CGFloat kDefaultSubSpacelength = 3.f;

//static const CGFloat kDefaultLineDuration = .2f;
static const CGFloat kDefaultLineSpeed = 500.f;

@interface ONEGuideLineView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation ONEGuideLineView

- (instancetype)init {
    if (self = [super init]) {
        _lineColor = kColorLightGray9;
        _lineWidth = kDefaultLineWidth;
        _subLineLength = kDefaultSubLineLength;
        _subSpacelength = kDefaultSubSpacelength;
        self.backgroundColor = kColorClear;
        self.clipsToBounds = YES;
        self.hidden = YES;
        [self setStyle:ONEGuideLineViewStyleToTop];
    }
    return self;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithImage:[self drawLineByFrame:self.frame]];
    }
    return _imageView;
}

- (void)setLineLength:(CGFloat)lineLength {
    _lineLength = lineLength;
    [self updateFrame];
}

// 返回虚线image的方法
- (UIImage *)drawLineByFrame:(CGRect)frame {
    UIGraphicsBeginImageContext(frame.size);
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    
    CGFloat lengths[] = {self.subLineLength, self.subSpacelength}; // 线的宽度，间隔宽度
    CGContextRef line = UIGraphicsGetCurrentContext();
    CGContextSetStrokeColorWithColor(line, self.lineColor.CGColor);  // 设置颜色
    
    CGContextSetLineDash(line, 0, lengths, 2);//画虚线
    CGContextMoveToPoint(line, 0, 0); //开始画线
    CGContextAddLineToPoint(line, self.frame.size.width - self.lineWidth, self.frame.size.height - self.lineWidth);//画直线
    CGContextStrokePath(line);
    
    return UIGraphicsGetImageFromCurrentImageContext();
}

- (void)moveTohiddenImageView {
    CGRect imageViewFrame = self.imageView.frame;
    
    switch (self.style) {
        case ONEGuideLineViewStyleToTop: {
            self.imageView.frame = CGRectMake(imageViewFrame.origin.x, imageViewFrame.origin.y + self.lineLength, imageViewFrame.size.width, imageViewFrame.size.height);
        } break;
            
        case ONEGuideLineViewStyleToBottom: {
            self.imageView.frame = CGRectMake(imageViewFrame.origin.x, imageViewFrame.origin.y - self.lineLength, imageViewFrame.size.width, imageViewFrame.size.height);
        } break;
            
        case ONEGuideLineViewStyleToLeft: {
            self.imageView.frame = CGRectMake(imageViewFrame.origin.x - self.lineLength, imageViewFrame.origin.y, imageViewFrame.size.width, imageViewFrame.size.height);
        } break;
            
        case ONEGuideLineViewStyleToRight: {
            self.imageView.frame = CGRectMake(imageViewFrame.origin.x + self.lineLength, imageViewFrame.origin.y, imageViewFrame.size.width, imageViewFrame.size.height);
        } break;
    }
}

- (void)updateFrame {
    switch (self.style) {
        case ONEGuideLineViewStyleToTop:
        case ONEGuideLineViewStyleToBottom: {
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.lineWidth, self.lineLength)];
            [self.imageView removeFromSuperview];
            self.imageView = [[UIImageView alloc] initWithImage:[self drawLineByFrame:self.frame]];
            [self addSubview:self.imageView];
            
        } break;
            
        case ONEGuideLineViewStyleToLeft:
        case ONEGuideLineViewStyleToRight: {
            [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.lineLength, self.lineWidth)];
            self.imageView = [[UIImageView alloc] initWithImage:[self drawLineByFrame:self.frame]];
            [self.imageView removeFromSuperview];
            self.imageView = [[UIImageView alloc] initWithImage:[self drawLineByFrame:self.frame]];
            [self addSubview:self.imageView];
        } break;
    }
}

- (void)showWithAnimation:(BOOL)animation completion:(void (^)(void))completion {
    [self updateFrame];
    
    self.hidden = NO;
    
    [self addSubview:self.imageView];
    
    CGRect imageViewFrame = self.imageView.frame;
    
    [self moveTohiddenImageView];
    
    CGFloat duration = self.lineLength / kDefaultLineSpeed;
    
    [UIView animateWithDuration:duration animations:^{
        self.imageView.frame = imageViewFrame;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
    
}

- (void)dismissWithAnimation:(BOOL)animation completion:(void (^)(void))completion {
    CGFloat duration = self.lineLength / kDefaultLineSpeed;
    [UIView animateWithDuration:duration animations:^{
        [self moveTohiddenImageView];
    } completion:^(BOOL finished) {
        [self.imageView removeFromSuperview];
        if (completion) {
            completion();
        }
    }];
}

@end
