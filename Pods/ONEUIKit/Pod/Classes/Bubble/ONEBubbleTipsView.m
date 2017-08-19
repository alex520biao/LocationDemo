//
//  ONEBubbleTipsView.m
//  Pods
//
//  Created by guoyaoyuan on 16/5/30.
//
//

#import "ONEBubbleTipsView.h"
#import "ONEUIKitTheme.h"
#import "ONEPixelAlign.h"
#import <UIView+Positioning/UIView+Positioning.h>
#import "ONEUIKitHelper.h"
#import "UIButton+ZoomSpots.h"
#import <ONEFoundation/ONEFoundation.h>
#import <ONEUIKit/ONEUIKit.h>

static const CGFloat kInnerPaddingHeight = 14; ///< 文字距离泡泡边缘纵向距离
static const CGFloat kInnerPaddingWidth = 16; ///< 文字距离泡泡边缘横向距离
//static const CGFloat kInnerPaddingShrink = 0; ///< 文字距离泡泡边缘距离，根据设计微调，去除font本身ascent、descent
static const CGFloat kIconPadding = 8;   ///< 图标距文字的距离
//static const CGFloat kButtonPadding = 10;  ///< 文字距按钮的距离
static const CGFloat kTextLabelLineSpacing = 3; ///< 行间距
//static const CGFloat kTextLabelMaxHeight = 35; ///< 两行的最大高度
static const CGFloat kCloseButtonPadding = 10; ///< 关闭按钮距文字距离
static const CGSize kCloseButtonSize = (CGSize){12, 12}; ///< 关闭按钮大小

@interface ONEBubbleTipsView()
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIButton *close;
@property (nonatomic, assign) BOOL canClose;

@property (nonatomic, copy) ONEBubbleTipsViewCloseAction closeAction; ///< 关闭回调

@end

@implementation ONEBubbleTipsView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) return nil;
    
//    self.arrowRadius = 0.33;
    self.contentView = [UIView new];
    
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:_iconView];
    
    _textLabel = [UILabel new];
    _textLabel.userInteractionEnabled = NO;
    _textLabel.numberOfLines = 0;
    _textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _textLabel.font = kFontSizeSmall;
    _textLabel.textColor = kColorWhite;
    _textLabel.clipsToBounds = YES;
    [self.contentView addSubview:_textLabel];
    
    _close = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, kCloseButtonSize.width, kCloseButtonSize.height)];
    [_close setImage:[ONEUIKitTheme imageNamed:@"tips_icon_close" inBundle:@"Bubble"] forState:UIControlStateNormal];
    [_close addTarget:self action:@selector(p_dismiss) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_close];
    
    for (UIView *view in self.subviews) {
        view.isAccessibilityElement = NO;
    }
    self.isAccessibilityElement = YES;
    
    return self;
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    _iconView.image = icon;
    [self updateSizeWithMaxWidth];
}

- (void)setText:(NSString *)text {
    _text = text;
    
    _textLabel.text = [ONEStringWithColor getNewString:text];
    _textLabel.numberOfLines = 0;

    self.accessibilityLabel = _textLabel.text;
    [self updateSizeWithMaxWidth];
}

- (void)setMaxWidth:(CGFloat)maxWidth {
    _maxWidth = maxWidth;
    [self updateSizeWithMaxWidth];
}

- (void)setSingleLine:(BOOL)singleLine {
    _singleLine = singleLine;
    [self updateSizeWithMaxWidth];
}

- (void)showAnimation {
    [super showAnimation];
    [self.close setEnabled:YES];
}

- (void)p_dismiss {
    if (self.closeAction) {
        self.closeAction(self);
    }
    [self.close setEnabled:NO];
    [self dismiss];
}

- (void)updateSizeWithMaxWidth {
    CGFloat width = self.maxWidth;
    if (!width || width <= 0) {
        width = [UIScreen mainScreen].bounds.size.width;
    }
    
    width -= self.bubblePadding * 2 + kInnerPaddingWidth * 2 + kCloseButtonSize.width + kCloseButtonPadding;
    if (self.arrowDirection == ONEBubbleArrowDirectionLeft ||
        self.arrowDirection == ONEBubbleArrowDirectionRight) {
        width -= self.arrowSize;
    }
    if (_iconView.image) {
        width -= _iconView.bounds.size.width + kIconPadding;
    }

    width = ONEPixelRound(width);
    
    [_textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    
    NSMutableAttributedString *attributedText = [ONEStringWithColor getAttibutedString:self.text lightColor:kColorOrange1 normalColor:kColorWhite font:kFontSizeSmall];
    
    CGRect textBounds = [attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    CGSize textSize = textBounds.size;
    textSize.width = ceil(textSize.width);
    textSize.height = ceil(textSize.height);
    
    CGRect labelFrame;
    if ((textSize.height > 2 * _textLabel.font.pointSize) && !_singleLine) {
        // 多行
        self.textLabel.numberOfLines = 0;
        NSMutableParagraphStyle *style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
        style.lineSpacing = kTextLabelLineSpacing;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.string.length)];
        [self.textLabel setAttributedText:attributedText];
        
        CGPoint iconCenter;
        iconCenter.x = kInnerPaddingWidth + _iconView.frame.size.width / 2;
        iconCenter.y = iconCenter.x;
        _iconView.center = iconCenter;
        
        labelFrame.size = CGSizeMake(ceil(width), ceil(textSize.height+10));
        labelFrame.origin.x = kInnerPaddingWidth + (_iconView.image ? _iconView.bounds.size.width + kIconPadding : 0);
        labelFrame.origin.y = kInnerPaddingHeight;
        _textLabel.frame = labelFrame;
        [_textLabel sizeToFit];
        labelFrame = _textLabel.frame;
        
        if (self.canClose) {
            self.contentView.frame = CGRectMake(0, 0,
                                                CGRectGetMaxX(labelFrame) + kInnerPaddingWidth + kCloseButtonSize.width + kCloseButtonPadding,
                                                CGRectGetMaxY(labelFrame) + kInnerPaddingHeight - 1.5f);
        } else {
            self.contentView.frame = CGRectMake(0, 0,
                                                CGRectGetMaxX(labelFrame) + kInnerPaddingWidth,
                                                CGRectGetMaxY(labelFrame) + kInnerPaddingHeight - 1.5f);
        }
    } else {
        // 单行
        _textLabel.numberOfLines = 1;
        [_textLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        
        labelFrame.size = CGSizeZero;
        labelFrame.origin.x = kInnerPaddingWidth + (_iconView.image ? _iconView.bounds.size.width + kIconPadding : 0);
        labelFrame.origin.y = kInnerPaddingHeight;
        _textLabel.frame = labelFrame;
        [_textLabel sizeToFit];
        _textLabel.frame = CGRectMake(_textLabel.frame.origin.x, _textLabel.frame.origin.y, MIN(_textLabel.frame.size.width, width), _textLabel.frame.size.height);
        labelFrame = _textLabel.frame;
        
        NSMutableParagraphStyle *style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
        style.lineBreakMode = NSLineBreakByWordWrapping;
        style.alignment = NSTextAlignmentLeft;
        [attributedText addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attributedText.string.length)];
        [self.textLabel setAttributedText:attributedText];
        
        CGPoint iconCenter;
        iconCenter.x = kInnerPaddingWidth + _iconView.frame.size.width / 2;
        iconCenter.y = _textLabel.center.y; //fix
        _iconView.center = iconCenter;
        
        if (self.canClose) {
            self.contentView.frame = CGRectMake(0, 0,
                                                CGRectGetMaxX(labelFrame) + kInnerPaddingWidth + kCloseButtonSize.width + kCloseButtonPadding,
                                                CGRectGetMaxY(labelFrame) + kInnerPaddingHeight - 3);
        } else {
            self.contentView.frame = CGRectMake(0, 0,
                                                CGRectGetMaxX(labelFrame) + kInnerPaddingWidth,
                                                CGRectGetMaxY(labelFrame) + kInnerPaddingHeight - 3);
        }
    }
    
    _iconView.centerY = _textLabel.centerY;
    
    _textLabel.centerY = self.contentView.centerY;
    
    if (self.canClose) {
        [self.close setFrame:CGRectMake(labelFrame.origin.x + labelFrame.size.width + kCloseButtonPadding, kInnerPaddingHeight, kCloseButtonSize.width, kCloseButtonSize.height)];
    }

    [self updateWithContentView];
}

#pragma mark - 便捷方法

+ (instancetype)viewWithText:(NSString *)text {
    return [self viewWithText:text maxWidth:0 icon:nil canClose:YES];
}

+ (instancetype)viewWithText:(NSString *)text canClose:(BOOL)canClose {
    return [self viewWithText:text maxWidth:0 icon:nil canClose:canClose];
}

/*
+ (instancetype)viewWithText:(NSString *)text
                    maxWidth:(CGFloat)maxWidth
             showDefaultIcon:(BOOL)showDefaultIcon
                    canClose:(BOOL)canClose
{
    UIImage *icon = nil;
    if (showDefaultIcon) {
        icon = [ONEUIKitTheme imageNamed:@"icon_tips_default" inBundle:@"Bubble"];
    }
    return [self viewWithText:text maxWidth:maxWidth icon:icon canClose:canClose];
}
 */

+ (instancetype)viewWithText:(NSString *)text
                    maxWidth:(CGFloat)maxWidth
                        icon:(UIImage *)icon
                    canClose:(BOOL)canClose {
    ONEBubbleTipsView *tips = [self new];
    tips.text = text;
    tips.icon = icon;
    tips.maxWidth = maxWidth;
    tips.canClose = canClose;
    if (!canClose) {
        [tips.close removeFromSuperview];
    }
    [tips updateSizeWithMaxWidth];
    return tips;
}

@end
