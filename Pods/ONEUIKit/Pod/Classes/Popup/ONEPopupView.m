//
//  ONEPopupView.m
//  Pods
//
//  Created by 张华威 on 16/9/8.
//
//

#import "ONEPopupView.h"
#import <ONEUIKit/ONEUIKitTheme.h>
#import <UIView+Positioning/UIView+Positioning.h>
#import <ONEFoundation/ONEFoundation.h>

#define SafeBlockRun(block, ...) block ? block(__VA_ARGS__) : nil
#define ONEPopupLocalizedStr(str) ONELocalizedStr(str, @"ONEUIKit-Popup")

static const CGFloat kTopViewHeight = 60.5f;

static const CGFloat kTitleTopY = 8.5f;
static const CGFloat kDetialTopMargin = 3.5f;

@interface ONEPopupView () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UITapGestureRecognizer *recognizer;
@property (nonatomic, copy) ONEPopupViewcloseBlock closeBlock;
@property (nonatomic, copy) ONEPopupViewConfirmedBlock confirmBlock;

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *detialTitleLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation ONEPopupView

- (void)showOnView:(UIView *)superView close:(ONEPopupViewcloseBlock)closeBlock confirm:(ONEPopupViewConfirmedBlock)confirmBlock {
    if (!self.contentView) {
        return;
    }

    if (!superView) {
        superView  = [[UIApplication sharedApplication].delegate window];
    }
    self.frame = superView.bounds;
    
    self.closeBlock = closeBlock;
    self.confirmBlock = confirmBlock;

    [superView addSubview:self];
    
    [self addSubview:self.backgroundView];
    [self.backgroundView setHidden:YES];
    [self addSubview:self.contentView];
    
    self.contentView.width = self.width;
    
    if (self.showTopView) {
        self.topView.size = CGSizeMake(self.width, kTopViewHeight);
        
        [self.topView addSubview:self.titleLabel];
        if ([self.detialTitle isKindOfClass:[NSString class]] && self.detialTitle.length) {
            [self.topView addSubview:self.detialTitleLabel];
        }
        
        [self.topView addSubview:self.cancelButton];
        [self.topView addSubview:self.confirmButton];
        
        [self addSubview:self.topView];
    }
    
    if (_isShow) {
        [self dismiss];
    }
    [self layoutSubviews];
    _isShow = YES;
    [UIView animateWithDuration:.3f animations:^{
//        [self setBackgroundColor:kBackgroundColor];
        [self.backgroundView setHidden:NO];
        [self layoutSubviews];
    }];
}

- (void)dismiss {
    _isShow = NO;
    [UIView animateWithDuration:.3f animations:^{
//        [self setBackgroundColor:kColorClear];
        [self.backgroundView setHidden:YES];
        [self layoutSubviews];
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

#pragma mark - private

- (BOOL)shouldShowDetialTitle {
    if ([self.detialTitle isKindOfClass:[NSString class]] && self.detialTitle.length) {
        if (self.titleLabel.height < self.titleLabel.font.lineHeight * 1.5f) {
            return YES;
        }
        NSAssert(NO, @"主标题过长，副标题无法显示");
    }
    return NO;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.contentView.centerX = self.centerX;
    self.topView.centerX = self.centerX;
    
    [self.cancelButton sizeToFit];
    self.cancelButton.x = 15;
    self.cancelButton.centerY = kTopViewHeight / 2;

    [self.confirmButton sizeToFit];
    self.confirmButton.x = self.topView.width - 15 - self.confirmButton.width;
    self.confirmButton.centerY = kTopViewHeight / 2;
    
    self.titleLabel.width = self.topView.width - 2 * (15 + MAX(self.confirmButton.width, self.cancelButton.width) + 16);
    [self.titleLabel sizeToFit];
    self.titleLabel.centerX = self.centerX;
    
    if ([self shouldShowDetialTitle]) {
        
        [self.detialTitleLabel sizeToFit];
        self.detialTitleLabel.centerX = self.centerX;
        
        self.titleLabel.top = kTitleTopY;
        self.detialTitleLabel.top = self.titleLabel.bottom + kDetialTopMargin;
    } else {
        self.titleLabel.centerY = kTopViewHeight / 2;
    }
    
    self.line.width = self.topView.width;
    self.line.y = self.topView.height - 0.5f;
    
    if (self.isShow) {
        self.contentView.bottom = self.bottom;
        self.topView.bottom = self.contentView.top;
    } else {
        self.topView.top = self.bottom;
        self.contentView.top = self.topView.bottom;
    }
}

- (instancetype)init {
    if (self = [super init]) {
        _shouldClose = YES;
        _recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchRecognizer:)];
        [_recognizer setDelegate:self];
        [self addGestureRecognizer:_recognizer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _shouldClose = YES;
        _recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchRecognizer:)];
        [_recognizer setDelegate:self];
        [self addGestureRecognizer:_recognizer];
    }
    return self;
}

#pragma mark - ButtonPressed

- (void)confirmPressed {
    SafeBlockRun(self.confirmBlock);
    if (_autoDismiss) {
        [self dismiss];
    }
}

- (void)confirmTouchDown {
    [_confirmButton setTitleColor:[ONEUIKitTheme colorWithHexString:@"fdc2a5"] forState:UIControlStateNormal];
}

- (void)confirmTouchUp {
    [_confirmButton setTitleColor:kColorOrange1 forState:UIControlStateNormal];
}

- (void)cancelPressed {
    SafeBlockRun(self.closeBlock, ONEPopupViewCloseTypeCancel);
    [self dismiss];
}

- (void)cancelTouchDown {
    [_cancelButton setTitleColor:[ONEUIKitTheme colorWithHexString:@"c6c6c6"] forState:UIControlStateNormal];
}

- (void)cancelTouchUp {
    [_cancelButton setTitleColor:kColorLightGray forState:UIControlStateNormal];
}

- (void)touchRecognizer:(UITapGestureRecognizer *)sender {
    SafeBlockRun(self.closeBlock, ONEPopupViewCloseTypeCoverCancel);
    [self dismiss];
    
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    CGPoint point = [touch locationInView:self];
    if (!CGRectContainsPoint(self.contentView.frame, point) && !CGRectContainsPoint(self.topView.frame, point) && self.shouldClose) {
        return YES;
    }
    return NO;
}

#pragma mark - Setter/Getter

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:_title];
}

- (void)setDetialTitle:(NSString *)detialTitle {
    _detialTitle = detialTitle;
    [self.detialTitleLabel setText:_detialTitle];
}

- (void)setConfirmTitle:(NSString *)confirmTitle {
    _confirmTitle = confirmTitle;
    [self.confirmButton setTitle:_confirmTitle forState:UIControlStateNormal];
}

- (void)setCancelTitle:(NSString *)cancelTitle {
    _cancelTitle = cancelTitle;
    [self.cancelButton setTitle:_cancelTitle forState:UIControlStateNormal];
}

- (void)setContentView:(UIView *)contentView {
    [_contentView removeFromSuperview];
    _contentView = contentView;
    [self addSubview:_contentView];
}

- (UIView *)backgroundView {
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc] initWithFrame:self.frame];
        [_backgroundView setBackgroundColor:kBackgroundColor];
        [_backgroundView setIsAccessibilityElement:YES];
    }
    return _backgroundView;
}

- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] initWithFrame:CGRectZero];
        [_topView setBackgroundColor:kColorWhite];
        [_topView setClipsToBounds:YES];
        _line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, .5f)];
        [_line setBackgroundColor:[kColorBlack colorWithAlphaComponent:.1f]];
        [_topView addSubview:_line];
        
        _topView.isAccessibilityElement = NO;
    }
    return _topView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [UILabel new];
        if (self.title && self.title.length) {
            [_titleLabel setText:self.title];
        }
        [_titleLabel setTextColor:kColorDeepGray];
        [_titleLabel setFont:kFontSize_18];
        [_titleLabel setBackgroundColor:kColorClear];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setNumberOfLines:2];
        
        _titleLabel.isAccessibilityElement = YES;
        
    }
    return _titleLabel;
}

- (UILabel *)detialTitleLabel {
    if (!_detialTitleLabel) {
        _detialTitleLabel = [UILabel new];
        if ([self.detialTitle isKindOfClass:[NSString class]] && self.detialTitle.length) {
            [_detialTitleLabel setText:self.detialTitle];
        }
        [_detialTitleLabel setTextColor:kColorDarkGray];
        [_detialTitleLabel setFont:kFontSizeMedium];
        [_detialTitleLabel setBackgroundColor:kColorClear];
        [_detialTitleLabel setTextAlignment:NSTextAlignmentCenter];
    }
    return _detialTitleLabel;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        _confirmButton = [UIButton new];
        if (self.confirmTitle && self.confirmTitle.length) {
            [_confirmButton setTitle:self.confirmTitle forState:UIControlStateNormal];
        } else {
            [_confirmButton setTitle:ONEPopupLocalizedStr(@"确认") forState:UIControlStateNormal];
        }
        [_confirmButton setTitleColor:kColorOrange1 forState:UIControlStateNormal];
        [_confirmButton setFont:kFontSizeMedium];
        [_confirmButton setBackgroundColor:kColorClear];
        [_confirmButton.titleLabel setTextAlignment:NSTextAlignmentRight];
        [_confirmButton addTarget:self action:@selector(confirmPressed) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton addTarget:self action:@selector(confirmTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_confirmButton addTarget:self action:@selector(confirmTouchDown) forControlEvents:UIControlEventTouchDown];
        [_confirmButton addTarget:self action:@selector(confirmTouchDown) forControlEvents:UIControlEventTouchDragEnter];
        [_confirmButton addTarget:self action:@selector(confirmTouchUp) forControlEvents:UIControlEventTouchDragExit];
        
        _confirmButton.isAccessibilityElement = YES;
        
    }
    return _confirmButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton new];
        if (self.cancelTitle && self.cancelTitle.length) {
            [_cancelButton setTitle:self.cancelTitle forState:UIControlStateNormal];
        } else {
            [_cancelButton setTitle:ONEPopupLocalizedStr(@"取消") forState:UIControlStateNormal];
        }
        [_cancelButton setTitleColor:kColorLightGray forState:UIControlStateNormal];
        [_cancelButton setFont:kFontSizeMedium];
        [_cancelButton setBackgroundColor:kColorClear];
        [_cancelButton.titleLabel setTextAlignment:NSTextAlignmentLeft];
        [_cancelButton addTarget:self action:@selector(cancelPressed) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton addTarget:self action:@selector(cancelTouchUp) forControlEvents:UIControlEventTouchUpInside];
        [_cancelButton addTarget:self action:@selector(cancelTouchDown) forControlEvents:UIControlEventTouchDown];
        [_cancelButton addTarget:self action:@selector(cancelTouchDown) forControlEvents:UIControlEventTouchDragEnter];
        [_cancelButton addTarget:self action:@selector(cancelTouchUp) forControlEvents:UIControlEventTouchDragExit];
        
        _cancelButton.isAccessibilityElement = YES;
    }
    return _cancelButton;
}

@end
