//
//  ONEPopupTableViewCell.m
//  Pods
//
//  Created by 张华威 on 16/9/13.
//
//

#import "ONEPopupTableViewCell.h"
#import <ONEUIKit/ONEUIKitTheme.h>
#import <UIView+Positioning/UIView+Positioning.h>
#import <ONEUIKit/ONEPixelAlign.h>

static const CGFloat iconMargin = 16;
static const CGFloat iconPadding = 6;
static const CGSize iconSize = (CGSize){16, 16};

@interface ONEPopupTableViewCell ()

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *coverView;

@end

@implementation ONEPopupTableViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [self addSubview:self.titleLabel];
    if (self.alignLeft) {
        _imgView = [[UIImageView alloc] initWithImage:self.icon];
        [self addSubview:self.imgView];
    }
    
    CGRect lineFrame = CGRectMake(0, ONEPixelFloor(rect.size.height - .5f), rect.size.width, .5f);
    
    UIView *line = [[UIView alloc] initWithFrame:lineFrame];
    [line setBackgroundColor:[kColorBlack colorWithAlphaComponent:.1f]];
    [self addSubview:line];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.alignLeft) {
        CGFloat titleLabelX = 0.0;
        self.titleLabel.frame = CGRectMake(0, 0, self.width - titleLabelX - iconMargin, self.height);
        self.titleLabel.height = self.height;
        if (self.icon) {
            self.imgView.frame = CGRectMake(iconMargin, 0, self.icon.size.width, iconSize.height);
            self.imgView.centerY = self.titleLabel.centerY;
            titleLabelX = iconMargin + iconPadding + self.icon.size.width;
        } else {
            titleLabelX = iconMargin;
        }
        self.titleLabel.frame = CGRectMake(titleLabelX, 0, self.width - titleLabelX - iconMargin, self.height);
    } else {
        self.titleLabel.frame = CGRectZero;
        self.titleLabel.size = self.size;
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self.coverView setSize:self.size];
    [self addSubview:self.coverView];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    
    CGPoint touchPoint = [touches.anyObject locationInView:self];
    if ([self pointInside:touchPoint withEvent:event]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .3f * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            [self.coverView setSize:CGSizeZero];
            [self.coverView removeFromSuperview];
        });
    } else {
        [self.coverView setSize:CGSizeZero];
        [self.coverView removeFromSuperview];
    }

}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.coverView setSize:CGSizeZero];
    [self.coverView removeFromSuperview];
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:kFontSizeLarge];
        [_titleLabel setTextColor:kColorGray];
        if (self.left) {
            [_titleLabel setTextAlignment:NSTextAlignmentLeft];
        }
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _titleLabel;
}

- (UIImageView *)imageView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
        [_imgView setBackgroundColor:[UIColor blueColor]];
    }
    return _imgView;
}

- (UIView *)coverView {
    if (!_coverView) {
        _coverView = [[UIView alloc] initWithFrame:CGRectZero];
        [_coverView setBackgroundColor:[kColorBlack colorWithAlphaComponent:.04f]];
    }
    return _coverView;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:_title];
}

- (void)setIcon:(UIImage *)icon {
    _icon = icon;
    [self.imageView setImage:_icon];
}

- (void)setAlignLeft:(BOOL)alignLeft {
    _alignLeft = alignLeft;
    if (_alignLeft) {
        [_titleLabel setTextAlignment:NSTextAlignmentLeft];
    } else {
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
    }
}

- (void)setIsDefault:(BOOL)isDefault {
    _isDefault = isDefault;
    if (_isDefault) {
        [self.titleLabel setTextColor:kColorOrange1];
        if (self.highLightIcon) {
            [self.imgView setImage:self.highLightIcon];
        }
    } else {
        [self.imgView setImage:self.icon];
        [self.titleLabel setTextColor:kColorGray];
    }
}

@end
