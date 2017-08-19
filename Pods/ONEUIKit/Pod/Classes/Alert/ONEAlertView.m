//
//  ONEAlertView.m
//  ONEAlertViewDemo
//
//  Created by Alex Jarvis on 25/09/2013.
//  Copyright (c) 2013 Panaxiom Ltd. All rights reserved.
//

#import "ONEAlertView.h"
#import "ONEUIKitTheme.h"
#import <ONEUIKit/ONELocalizedTheme.h>
#import <ONEUIKit/UIView+ONETheme.h>
#import <ONEFoundation/ONEFoundation.h>

@interface ONEZoomSpotButton : UIButton
@end

@implementation ONEZoomSpotButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGRect bounds = self.bounds;
    //若原热区小于44x44，则放大热区，否则保持原大小不变
    CGFloat widthDelta = MAX(44.0 - bounds.size.width, 0);
    CGFloat heightDelta = MAX(44.0 - bounds.size.height, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end

@interface ONEAlertViewStack : NSObject

@property (nonatomic) NSMutableArray *alertViews;

+ (ONEAlertViewStack *)sharedInstance;

- (void)push:(ONEAlertView *)alertView;
- (void)pop:(ONEAlertView *)alertView;

@end

static const CGFloat AlertViewWidth                 = 267.0;
static const CGFloat AlertViewContentMargin         = 16;
static const CGFloat AlertViewCheckMargin          = 12;
static const CGFloat AlertViewVerticalElementSpace  = 20;
static const CGFloat AlertViewButtonHeight          = 50.5;
static const CGFloat AlertViewLineLayerWidth        = .5f;
static const CGFloat AlertViewMessageLineSpace       = 4.5;
static const CGSize AlertViewcheckImageViewSize      = (CGSize) {12, 12};

@interface ONEAlertView ()

@property (nonatomic) UIWindow               *mainWindow;
@property (nonatomic) UIWindow               *alertWindow;
@property (nonatomic) UIView                 *backgroundView;
@property (nonatomic) UIView                 *alertView;
@property (nonatomic) UILabel                *titleLabel;
@property (nonatomic) UIView                 *contentView;
@property (nonatomic) UIView                 *contentBackgroundView;
@property (nonatomic) UILabel                *messageLabel;
@property (nonatomic) UILabel                *detialMessageLabel;
@property (nonatomic) UIImageView            *checkImageView;
@property (nonatomic) BOOL                   checkButtonSelected;
@property (nonatomic) UIButton               *checkViewButton;
@property (nonatomic) UIButton               *close;
@property (nonatomic) NSMutableArray         *buttons;
@property (nonatomic) UITapGestureRecognizer *tap;
@property (nonatomic, copy) ONEAlertViewCompletionBlock completion;

@end

@implementation ONEAlertView

+ (NSArray<ONEAlertView *> *)alertViews {
    return [ONEAlertViewStack sharedInstance].alertViews;
}

- (UIWindow *)windowWithLevel:(UIWindowLevel)windowLevel {
    NSArray *windows = [[UIApplication sharedApplication] windows];

    for (UIWindow *window in windows) {
        if (window.windowLevel == windowLevel) {
            return window;
        }
    }

    return nil;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//customAlertView
- (id)initWithCustomView:(UIView *)customView buttonsTitle:(NSArray <NSString *> *)titles canClose:(BOOL)canClose completion:(ONEAlertViewCompletionBlock)completion{
    self = [super init];

    if (self) {
        _autoDismiss = YES;
        _mainWindow = [self windowWithLevel:UIWindowLevelNormal];
        _alertWindow = [self windowWithLevel:UIWindowLevelAlert];

        if (!_alertWindow) {
            _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _alertWindow.windowLevel = UIWindowLevelAlert;
            _alertWindow.backgroundColor = kColorClear;
        }

        _alertWindow.userInteractionEnabled = YES;
        _alertWindow.rootViewController = self;

        CGRect frame = [self frameForOrientation];
        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
        self.view.frame = frame;

        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = kBackgroundColor;
        _backgroundView.alpha = 0;
        [self.view addSubview:_backgroundView];

        _alertView = [[UIView alloc] init];
        _alertView.backgroundColor = kColorWhite;
        _alertView.layer.cornerRadius = 2.0;
        _alertView.clipsToBounds = YES;
        _alertView.layer.opacity = 1.f;
        
        [_alertView addSubview:customView];
        
        if (canClose) {
            [self setupCloseButton];
        }
        if (completion) {
            self.completion = completion;
        }
        if (titles && titles.count) {
            [self setupButtons:customView.frame.size.height + customView.frame.origin.y titles:titles];
        }

        [self.view addSubview:_alertView];
        _alertView.bounds = CGRectMake(0, 0, AlertViewWidth, 0);
        
        CGFloat totalHeight = 0;
        if (self.buttons && self.buttons.count) {
            totalHeight += AlertViewVerticalElementSpace;
            
            UIView *lastButton = self.buttons.lastObject;
            totalHeight = lastButton.frame.origin.y + lastButton.frame.size.height;
        } else {
            totalHeight += customView.frame.size.height;
        }
        
        self.alertView.frame = CGRectMake(self.alertView.frame.origin.x,
                                          self.alertView.frame.origin.y,
                                          self.alertView.frame.size.width,
                                          MIN(totalHeight, self.alertWindow.frame.size.height));
        _alertView.center = [self centerWithFrame:frame];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repositionFrame) name:UIDeviceOrientationDidChangeNotification object:nil];
    }

    return self;
}

- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
messageOfAttributed:(NSAttributedString *)messageOfAttributed
      checkMessaage:(NSString *)checkMessaage
      detialMessage:(NSString *)detialMessage
       buttonTitles:(NSArray *)buttonTitles
           canClose:(BOOL)canClose
        contentView:(UIView *)contentView
           isCustom:(BOOL)isCustom
         completion:(ONEAlertViewCompletionBlock)completion {
    self = [super init];

    if (self) {
        _autoDismiss = YES;
        _mainWindow = [self windowWithLevel:UIWindowLevelNormal];
        _alertWindow = [self windowWithLevel:UIWindowLevelAlert];
        
        if (!_alertWindow) {
            _alertWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
            _alertWindow.windowLevel = UIWindowLevelAlert;
            _alertWindow.backgroundColor = kColorClear;
        }
        
        _alertWindow.userInteractionEnabled = YES;
        _alertWindow.rootViewController = self;

        CGRect frame = [self frameForOrientation];
        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
        self.view.frame = frame;

        self.backgroundView = [[UIView alloc] initWithFrame:frame];
        self.backgroundView.backgroundColor = kBackgroundColor;
        [self.view addSubview:self.backgroundView];

        self.alertView = [[UIView alloc] init];
        self.alertView.backgroundColor = kColorWhite;
        self.alertView.layer.cornerRadius = 2.0;
        self.alertView.clipsToBounds = YES;
        [self.view addSubview:self.alertView];

        // Optional Content View
        CGFloat curY = AlertViewVerticalElementSpace;
        
        if (canClose) {
            curY += 10;
        }
        
        if (contentView) {
            if (isCustom) {
                self.contentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, curY, contentView.frame.size.width, contentView.frame.size.height)];
            } else {
                self.contentBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, curY, 50, 50)];
            }
            [self.contentBackgroundView setBackgroundColor:kColorClear];
            self.contentBackgroundView.center = CGPointMake(AlertViewWidth / 2, self.contentBackgroundView.center.y);
            
            self.contentView = contentView;
            
            CGRect contentFrame = CGRectZero;
            contentFrame.size = self.contentBackgroundView.frame.size;
            self.contentView.frame = self.contentBackgroundView.frame;

            [self.alertView addSubview:self.contentView];
            curY += self.contentBackgroundView.frame.size.height + AlertViewContentMargin;
        }
        
        if (title) {
            // Title
            curY -= 2; 
            self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(AlertViewContentMargin, curY, AlertViewWidth - AlertViewContentMargin * 2, 0)];
            self.titleLabel.text = title;
            self.titleLabel.backgroundColor = kColorClear;
            self.titleLabel.textColor = kColorDeepGray;
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.font = kFontSizeLarge;
            self.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.titleLabel.numberOfLines = 0;
            self.titleLabel.frame = [self adjustLabelFrameHeight:self.titleLabel];
            [self.alertView addSubview:self.titleLabel];
            curY += self.titleLabel.frame.size.height + AlertViewContentMargin;
            curY -= 2;
        }
        
        if (message) {
            curY -= 2;
            self.messageLabel = [[UILabel alloc] initWithFrame:(CGRect) {AlertViewContentMargin, curY, AlertViewWidth - AlertViewContentMargin * 2, 0}];
            self.messageLabel.text = message;
            self.messageLabel.backgroundColor = kColorClear;
            self.messageLabel.textColor = kColorGray;
            self.messageLabel.textAlignment = NSTextAlignmentCenter;
            self.messageLabel.font = [UIFont systemFontOfSize:14];
            self.messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.messageLabel.numberOfLines = 0;
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:message];
            NSMutableParagraphStyle *style = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
            if (!messageOfAttributed || messageOfAttributed.length == 0) {
                style.lineSpacing = AlertViewMessageLineSpace;
                style.lineBreakMode = NSLineBreakByWordWrapping;
                style.alignment = NSTextAlignmentCenter;
                [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
                [str addAttribute:NSFontAttributeName value:self.messageLabel.font range:NSMakeRange(0, str.length)];
                [str addAttribute:NSForegroundColorAttributeName value:self.messageLabel.textColor range:NSMakeRange(0, str.length)];
//                messageOfAttributed = str;
            }
            
            self.messageLabel.attributedText = messageOfAttributed && messageOfAttributed.length ? messageOfAttributed : str;
            self.messageLabel.frame = [self adjustLabelFrameHeight:self.messageLabel];
            
            [self.messageLabel sizeToFit];
            
            if (self.messageLabel.frame.size.height >= self.messageLabel.font.lineHeight * 1.5 + AlertViewMessageLineSpace) {
                // 多行
                if (messageOfAttributed && messageOfAttributed.length) {
                    NSDictionary *dicAttribute = [messageOfAttributed attributesAtIndex:0 effectiveRange:nil];
                    
                    if ([dicAttribute isKindOfClass:[NSDictionary class]]) {
                        NSParagraphStyle *originStyle = [dicAttribute objectForKey:@"NSParagraphStyle"];
                        if ([originStyle isKindOfClass:[NSParagraphStyle class]] &&
                            originStyle.alignment == NSTextAlignmentCenter) {
                            self.messageLabel.center = CGPointMake(AlertViewWidth / 2.f, self.messageLabel.center.y);
                        }
                    }
                    
                } else {
                    [str removeAttribute:NSParagraphStyleAttributeName range:NSMakeRange(0, str.length)];
                    [style setAlignment:NSTextAlignmentLeft];
                    [str addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, str.length)];
                    [self.messageLabel setAttributedText:str];
                }
                
                [self.messageLabel sizeToFit];
            } else {
                // 一行
                CGRect messageFrame = self.messageLabel.frame;
                self.messageLabel.frame = CGRectMake(messageFrame.origin.x, messageFrame.origin.y + 2.5, messageFrame.size.width, messageFrame.size.height);
                self.messageLabel.center = CGPointMake(AlertViewWidth / 2, self.messageLabel.center.y);
            }
            
            [self.alertView addSubview:self.messageLabel];
            
            curY += self.messageLabel.frame.size.height + AlertViewContentMargin;
            
            curY -= 2;

        }
        if (checkMessaage) {
            curY -= AlertViewContentMargin - AlertViewCheckMargin;
            self.checkImageView = [[UIImageView alloc] init];
            [self.checkImageView setImage:[ONEUIKitTheme imageNamed:@"btn_popup_unselected" inBundle:@"Alert"]];
            [self.checkImageView setFrame:(CGRect) {0, 0, AlertViewcheckImageViewSize.width, AlertViewcheckImageViewSize.height }];

            self.detialMessageLabel = [[UILabel alloc] init];
            self.detialMessageLabel.backgroundColor = kColorClear;
            self.detialMessageLabel.textColor = kColorLightGray;
            self.detialMessageLabel.textAlignment = NSTextAlignmentLeft;
            self.detialMessageLabel.font = [UIFont systemFontOfSize:12];
            self.detialMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.detialMessageLabel.numberOfLines = 1;
            self.detialMessageLabel.text = checkMessaage;
            [self.detialMessageLabel sizeToFit];
            self.detialMessageLabel.frame = CGRectMake(self.checkImageView.frame.size.width + 4, 0, self.detialMessageLabel.frame.size.width, AlertViewcheckImageViewSize.height);

            self.checkViewButton = [[UIButton alloc] initWithFrame:CGRectMake(AlertViewContentMargin, curY, self.detialMessageLabel.frame.origin.x + self.detialMessageLabel.frame.size.width, AlertViewcheckImageViewSize.height)];

            [self.checkViewButton addSubview:self.checkImageView];
            [self.checkViewButton addSubview:self.detialMessageLabel];
            [self.alertView addSubview:self.checkViewButton];
            
            [self.checkViewButton addTarget:self action:@selector(checkImageViewDidSelected:) forControlEvents:UIControlEventTouchUpInside];
            
            curY += self.checkViewButton.frame.size.height + AlertViewCheckMargin + 4;
        } else if (detialMessage) {
            curY -= AlertViewContentMargin - AlertViewCheckMargin;
            
            self.detialMessageLabel = [[UILabel alloc] init];
            self.detialMessageLabel.backgroundColor = kColorClear;
            self.detialMessageLabel.textColor = kColorLightGray;
            self.detialMessageLabel.textAlignment = NSTextAlignmentLeft;
            self.detialMessageLabel.font = [UIFont systemFontOfSize:12];
            self.detialMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
            self.detialMessageLabel.numberOfLines = 1;
            self.detialMessageLabel.text = detialMessage;
            [self.detialMessageLabel sizeToFit];
            self.detialMessageLabel.frame = CGRectMake(self.checkImageView.frame.size.width + AlertViewContentMargin, curY, self.detialMessageLabel.frame.size.width, AlertViewcheckImageViewSize.height);
            
            [self.alertView addSubview:self.detialMessageLabel];
            curY += self.detialMessageLabel.frame.size.height + AlertViewCheckMargin + 2;
        }

        if (canClose) {
            [self setupCloseButton];
        }
        
        [self setupButtons:curY + AlertViewVerticalElementSpace - AlertViewContentMargin titles:buttonTitles];

        self.alertView.bounds = CGRectMake(0, 0, AlertViewWidth, 150);

        if (completion) {
            self.completion = completion;
        }

        [self resizeViews];

        self.alertView.center = [self centerWithFrame:frame];

//        [self setupGestures];

        if ((self = [super init])) {
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center addObserver:self selector:@selector(keyboardWillShown:) name:UIKeyboardWillShowNotification object:nil];
            [center addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(repositionFrame) name:UIDeviceOrientationDidChangeNotification object:nil];

        return self;
    }

    return self;
}

- (void)keyboardWillShown:(NSNotification *)notification {
    if (self.isVisible) {
        CGRect keyboardFrameBeginRect = [[[notification userInfo] valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];

        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 8 && (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft || self.interfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
            keyboardFrameBeginRect = (CGRect) {
                keyboardFrameBeginRect.origin.y, keyboardFrameBeginRect.origin.x, keyboardFrameBeginRect.size.height, keyboardFrameBeginRect.size.width
            };
        }

        CGRect interfaceFrame = [self frameForOrientation];

        if (interfaceFrame.size.height -  keyboardFrameBeginRect.size.height <= _alertView.frame.size.height + _alertView.frame.origin.y) {
            [UIView animateWithDuration:.35
                                  delay:0
                                options:0x70000
                             animations:^(void)
            {
                _alertView.frame = (CGRect) {_alertView.frame.origin.x, interfaceFrame.size.height - keyboardFrameBeginRect.size.height - _alertView.frame.size.height - 20, _alertView.frame.size };
            }
                             completion:nil];
        }
    }
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.isVisible) {
        [UIView animateWithDuration:.35
                              delay:0
                            options:0x70000
                         animations:^(void)
        {
            _alertView.center = [self centerWithFrame:[self frameForOrientation]];
        }
                         completion:nil];
    }
}

- (CGRect)frameForOrientation {
    UIWindow *window = [[UIApplication sharedApplication].windows count] > 0 ? [[UIApplication sharedApplication].windows objectAtIndex:0] : nil;

    if (!window) {
        window = [UIApplication sharedApplication].keyWindow;
    }

    if ([[window subviews] count] > 0) {
        return [[[window subviews] objectAtIndex:0] bounds];
    }

    return [[self windowWithLevel:UIWindowLevelNormal] bounds];
}

- (CGRect)adjustLabelFrameHeight:(UILabel *)label {
    CGFloat height;

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGSize size = [label.text
                        sizeWithFont:label.font
                   constrainedToSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                       lineBreakMode:NSLineBreakByWordWrapping];

        height = size.height;
#pragma clang diagnostic pop
    } else {
        NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
        context.minimumScaleFactor = 1.0;
        CGRect bounds = [label.text
                         boundingRectWithSize:CGSizeMake(label.frame.size.width, FLT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{ NSFontAttributeName: label.font }
                                      context:context];
        height = bounds.size.height;
    }

    return CGRectMake(label.frame.origin.x, label.frame.origin.y, label.frame.size.width, height);
}

- (UIButton *)genericButton:(NSString *)title {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];

    [button setTitle:title forState:UIControlStateNormal];
    button.backgroundColor = kColorClear;
    [button setAdjustsImageWhenHighlighted:NO];
    button.titleLabel.font = [UIFont systemFontOfSize:16];
    button.titleLabel.adjustsFontSizeToFitWidth = YES;
    button.titleEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
    [button setTitleColor:kColorLightGray forState:UIControlStateNormal];
    [button addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(setBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragEnter];
    [button addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchDragExit];
    [button addTarget:self action:@selector(clearBackgroundColorForButton:) forControlEvents:UIControlEventTouchUpInside];
    return button;
}

- (CGPoint)centerWithFrame:(CGRect)frame {
    return CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame) - [self statusBarOffset]);
}

- (CGFloat)statusBarOffset {
    CGFloat statusBarOffset = 0;

    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1) {
        statusBarOffset = 20;
    }

    return statusBarOffset;
}

- (void)setupGestures {
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss:)];
    [self.tap setNumberOfTapsRequired:1];
    [self.backgroundView setUserInteractionEnabled:YES];
    [self.backgroundView setMultipleTouchEnabled:NO];
    [self.backgroundView addGestureRecognizer:self.tap];
}

- (void)repositionFrame {
    CGRect frame = [self frameForOrientation];
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
    self.backgroundView.frame = frame;
    self.alertView.center = [self centerWithFrame:frame];
}

- (void)resizeViews {
    CGFloat totalHeight = 0;

    if (self.buttons && self.buttons.count) {

        UIView *lastButton = self.buttons.lastObject;
        totalHeight = lastButton.frame.origin.y + lastButton.frame.size.height;
    } else {
        for (UIView *view in [self.alertView subviews]) {
            if ([view class] != [UIButton class]) {
                totalHeight += view.frame.size.height + AlertViewContentMargin;
            }
        }

        totalHeight += 2 * AlertViewVerticalElementSpace - AlertViewContentMargin;
    }

    self.alertView.frame = CGRectMake(self.alertView.frame.origin.x,
                                      self.alertView.frame.origin.y,
                                      self.alertView.frame.size.width,
                                      MIN(totalHeight, self.alertWindow.frame.size.height));
}

- (void)setBackgroundColorForButton:(id)sender {
    if ([sender isEqual:self.buttons.firstObject]) {
        [sender setBackgroundColor:[ONEHighlightColor() colorWithAlphaComponent:.04f]];
    } else {
        [sender setBackgroundColor:[kColorBlack colorWithAlphaComponent:.04f]];
    }
}

- (void)clearBackgroundColorForButton:(id)sender {
    [sender setBackgroundColor:kColorClear];
}

- (void)checkImageViewDidSelected:(id)sender {
    if (self.checkButtonSelected) {
        [self.checkImageView setImage:[ONEUIKitTheme imageNamed:@"btn_popup_unselected" inBundle:@"Alert"]];
        self.checkButtonSelected = NO;
    } else {
        [self.checkImageView setImage:[ONEUIKitTheme imageNamed:@"btn_popup_select" inBundle:@"Alert"]];
        self.checkButtonSelected = YES;
    }
}

- (void)show {
    [[ONEAlertViewStack sharedInstance] push:self];
}

- (void)showInternal {
    [self.alertWindow addSubview:self.view];
    [self.alertWindow makeKeyAndVisible];
    self.visible = YES;
    [self showBackgroundView];
    [self showAlertAnimation];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)showBackgroundView {
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeDimmed;
        [self.mainWindow tintColorDidChange];
    }

    [UIView animateWithDuration:0.3
                     animations:^{
        self.backgroundView.alpha = 1;
    }];
}

- (void)hide {
    [self.view removeFromSuperview];
}

- (void)dismissWithAnimated:(BOOL)animated {
    [self dismiss:nil animated:animated];
}

- (void)dismiss:(id)sender {
    
    if (self.autoDismiss) {
        [self dismiss:sender animated:YES];
    } else {
        [self runComplateBlock:sender];
    }
}

- (void)runComplateBlock:(id)sender {
    if (self.completion) {
        BOOL cancelled = NO;
        
        if (sender == self.close || sender == self.tap) {
            cancelled = YES;
        }
        
        NSInteger buttonIndex = -1;
        
        if (self.buttons) {
            NSUInteger index = [self.buttons indexOfObject:sender];
            
            if (index != NSNotFound) {
                buttonIndex = index;
            }
        }
        
        if (sender) {
            self.completion(cancelled, self.checkButtonSelected, buttonIndex);
        }
    }
}

- (void)dismiss:(id)sender animated:(BOOL)animated {
    self.visible = NO;

    [UIView animateWithDuration:(animated ? 0.2 : 0)
                     animations:^{
        self.alertView.alpha = 0;
    } completion:^(BOOL finished) {

        [self runComplateBlock:sender];

        if ([[[ONEAlertViewStack sharedInstance] alertViews] count] == 1) {
            if (animated) {
                [self dismissAlertAnimation];
            }

            if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
                self.mainWindow.tintAdjustmentMode = UIViewTintAdjustmentModeAutomatic;
                [self.mainWindow tintColorDidChange];
            }

            [UIView animateWithDuration:(animated ? 0.2 : 0)
                             animations:^{
                self.backgroundView.alpha = 0;
                [self.alertWindow
                 setHidden:YES];
                [self.alertWindow removeFromSuperview];
                self.alertWindow.rootViewController = nil;
                self.alertWindow = nil;
            }
                             completion:^(BOOL finished) {
                [self.mainWindow makeKeyAndVisible];
            }];
        }

        [[ONEAlertViewStack sharedInstance] pop:self];
    }];
}

- (void)showAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];

    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.05, 1.05, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.duration = .3;

    [self.alertView.layer addAnimation:animation forKey:@"showAlert"];
}

- (void)dismissAlertAnimation {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];

    animation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.95, 0.95, 1)],
                         [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 1)]];
    animation.keyTimes = @[ @0, @0.5, @1 ];
    animation.fillMode = kCAFillModeRemoved;
    animation.duration = .2;

    [self.alertView.layer addAnimation:animation forKey:@"dismissAlert"];
}

- (CALayer *)lineLayer {
    CALayer *lineLayer = [CALayer layer];

    lineLayer.backgroundColor = [[kColorBlack colorWithAlphaComponent:.1f] CGColor];
    return lineLayer;
}

#pragma mark -
#pragma mark UIViewController

- (BOOL)prefersStatusBarHidden {
    return [UIApplication sharedApplication].statusBarHidden;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration {
    CGRect frame = [self frameForOrientation];

    self.backgroundView.frame = frame;
    self.alertView.center = [self centerWithFrame:frame];
}

- (void)setupCloseButton {
    self.close = [[ONEZoomSpotButton alloc] initWithFrame:CGRectMake(AlertViewWidth - 10 - 12, 10, 12, 12)];
    [self.close setImage:[ONEUIKitTheme imageNamed:@"adlayer_btn_close1" inBundle:@"Alert"] forState:UIControlStateNormal];
    [self.close setAdjustsImageWhenHighlighted:NO];
    [self.close addTarget:self action:@selector(dismiss:) forControlEvents:UIControlEventTouchUpInside];
    [self.close addTarget:self action:@selector(setCloseButtonPressed:) forControlEvents:UIControlEventTouchDown];
    [self.close addTarget:self action:@selector(setCloseButtonPressed:) forControlEvents:UIControlEventTouchDragEnter];
    [self.close addTarget:self action:@selector(setCloseButtonUnPressed:) forControlEvents:UIControlEventTouchDragExit];
    [self.close addTarget:self action:@selector(setCloseButtonUnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.close setAccessibilityLabel:@"关闭"];
    
    [self.alertView addSubview:self.close];
}

- (void)setCloseButtonPressed:(id)sender {
    [self.close setImage:[ONEUIKitTheme imageNamed:@"adlayer_btn_close1_pressed" inBundle:@"Alert"] forState:UIControlStateNormal];
}

- (void)setCloseButtonUnPressed:(id)sender {
    [self.close setImage:[ONEUIKitTheme imageNamed:@"adlayer_btn_close1" inBundle:@"Alert"] forState:UIControlStateNormal];
}

- (void)setupButtons:(CGFloat)buttonsY titles:(NSArray <NSString *> *)titles {
    // 兼容开发者给titles设置NSString的情况
    if ([titles isKindOfClass:[NSString class]]) {
        titles = @[titles];
    }
    
    if (![titles isKindOfClass:[NSArray class]] || titles.count == 0) {
        return;
    }
    
    self.buttons = [NSMutableArray array];
    [titles enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [self.buttons addObject:[self genericButton:obj]];
    }];

    if (self.buttons.count == 2) {
        CALayer *lineLayer = [self lineLayer];
        lineLayer.frame = CGRectMake(0, buttonsY, AlertViewWidth, AlertViewLineLayerWidth);
        [self.alertView.layer addSublayer:lineLayer];

        lineLayer = [self lineLayer];
        lineLayer.frame = CGRectMake(AlertViewWidth / 2, buttonsY, AlertViewLineLayerWidth, AlertViewButtonHeight);
        [self.alertView.layer addSublayer:lineLayer];

        [self.buttons.lastObject setFrame:CGRectMake(0, buttonsY, AlertViewWidth / 2, AlertViewButtonHeight)];
        [self.alertView addSubview:self.buttons.lastObject];

        [self.buttons.firstObject setFrame:CGRectMake(AlertViewWidth / 2, buttonsY, AlertViewWidth / 2, AlertViewButtonHeight)];
        [self.buttons.firstObject setTitleColor:ONEHighlightColor() forState:UIControlStateNormal];
        [self.alertView addSubview:self.buttons.firstObject];
    } else {
        __block CGFloat curY = buttonsY;
        [self.buttons enumerateObjectsUsingBlock:^(UIButton *_Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
            CALayer *lineLayer = [self lineLayer];
            lineLayer.frame = CGRectMake(0, curY, AlertViewWidth, AlertViewLineLayerWidth);
            [self.alertView.layer addSublayer:lineLayer];

            if (idx == 0) {
                [obj setTitleColor:ONEHighlightColor() forState:UIControlStateNormal];
            }

            [obj setFrame:CGRectMake(0, curY, AlertViewWidth, AlertViewButtonHeight)];
            [self.alertView addSubview:obj];
            curY += AlertViewButtonHeight;
        }];
    }
}

- (void)dismissWithClickedButtonIndex:(NSInteger)buttonIndex animated:(BOOL)animated {
    if (buttonIndex >= 0 && buttonIndex < [self.buttons count]) {
        [self dismiss:self.buttons[buttonIndex] animated:animated];
    }
}

@end

@implementation ONEAlertViewStack

+ (instancetype)sharedInstance {
    static ONEAlertViewStack *_sharedInstance = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _sharedInstance = [[ONEAlertViewStack alloc] init];
        _sharedInstance.alertViews = [NSMutableArray array];
    });

    return _sharedInstance;
}

- (void)push:(ONEAlertView *)alertView {
    for (ONEAlertView *av in self.alertViews) {
        if (av != alertView) {
            [av hide];
        } else {
            return;
        }
    }

    [self.alertViews addObject:alertView];
    [alertView showInternal];
}

- (void)pop:(ONEAlertView *)alertView {
    [alertView hide];
    [self.alertViews removeObject:alertView];
    ONEAlertView *last = [self.alertViews lastObject];

    if (last && !last.view.superview) {
        [last showInternal];
    }
}

@end
