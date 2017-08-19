//
//  ONECustomGuideView.m
//  Pods
//
//  Created by Liushulong on 1/19/16.
//
//
#if 0
#import "ONECustomGuideView.h"
#import "ONEAlertViewManager.h"
#import "ONEUIKitTheme.h"
#import <UIView+Positioning/UIView+Positioning.h>

//#define kAlertWidth (536/2.0)
//#define kAlertHeight (324/2.0)
//#define kAdjuest 20

static const CGFloat kViewWidth = 267; ///< Alert 宽度
static const CGFloat kPadding = 16; /// 按钮边距

typedef void(^CompletionBlock)(BOOL confirm);

@interface ONECustomGuideView ()

@property (nonatomic, weak)  ONEAlertView  *pxAlertView;
@property (nonatomic,strong) CompletionBlock completionBlock;

@end

@implementation ONECustomGuideView

+ (ONECustomGuideView *)showCustomGuideViewWithTopImage:(UIImage *)topImage
                                                message:(NSString *)message
                                             subMessage:(NSString *)subMessage
                                             tipMessage:(NSString *)tipMessage
                                           confirmTitle:(NSString *)confirmTitle
                                            cancelTitle:(NSString *)cancelTitle
                                             completion:(void (^)(BOOL confirm))completion {
    ONECustomGuideView *view = [[ONECustomGuideView alloc] initWithFrame:CGRectMake(0, 0, kViewWidth, 0)];
    view.backgroundColor = kColorWhite;
    view.completionBlock = completion;
    
    //顶部图片
    UIImageView *imageView = [[UIImageView alloc] initWithImage:topImage];
    [imageView sizeToFit];
    imageView.centerX = view.centerX;
    [view addSubview:imageView];

    // message
    UILabel *label = [UILabel new];
    label.frame = CGRectMake(0, imageView.bottom + 15, 0, 0);
    label.font = kFontSizeLarge1;
    label.textColor = kColorDeepGray;
    label.text = message;
    [label sizeToFit];
    [view addSubview:label];
    label.centerX = view.centerX;
    
    // sub
    UILabel *subLabel = [UILabel new];
    subLabel.font = kFontSizeMedium;
    subLabel.textColor = kColorGray;
    subLabel.text = subMessage;
    [subLabel sizeToFit];
    [view addSubview:subLabel];
    subLabel.centerX = view.centerX;
    
    // tip
    UILabel *tipLabel = [UILabel new];
    tipLabel.font = kFontSizeSmall;
    tipLabel.textColor = kColorLightGray8;
    tipLabel.text = tipMessage;
    [tipLabel sizeToFit];
    [view addSubview:tipLabel];
    tipLabel.centerX = view.centerX;
    
    
    // 布局
    CGFloat top = imageView.bottom;
    if (message.length) {
        top = imageView.bottom + 14;
        label.top = top;
        top = floor(label.bottom);
    }
    
    if (subMessage.length) {
        subLabel.top = top + 4;
        top = floor(subLabel.bottom);
    }
    
    if (tipMessage.length) {
        tipLabel.top = top + 6;
        top = floor(tipLabel.bottom);
    }
    
    if (top > imageView.bottom) {
        top += 18;
    }
    
    // 按钮
    UIButton *confirmBtn = [ONEUIKitTheme buttonWithStyle:ONEButtonStyleColorFlat
                                                size:ONEButtonSizeLarge1];
    confirmBtn.top = top;
    [confirmBtn setTitle:confirmTitle forState:UIControlStateNormal];
    [confirmBtn addTarget:view action:@selector(confirm) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:confirmBtn];
    
    UIButton *cancelBtn = [ONEUIKitTheme buttonWithStyle:ONEButtonStyleGrayBorder
                                               size:ONEButtonSizeLarge1];
    cancelBtn.top = top;
    [cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
    [cancelBtn addTarget:view action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    
    if (cancelTitle.length) {
        // 2个按钮
        [view addSubview:cancelBtn];
        [view addSubview:confirmBtn];
        cancelBtn.width = floorf((view.width - 3 * kPadding) / 2);
        cancelBtn.left = kPadding;
        confirmBtn.width = cancelBtn.width;
        confirmBtn.right = view.width - kPadding;
    } else {
        // 1 个按钮
        [view addSubview:confirmBtn];
        confirmBtn.width = view.width - 2 * kPadding;
        confirmBtn.left = kPadding;
    }
    
    view.height = confirmBtn.bottom + kPadding;
    view.pxAlertView = [ONEAlertViewManager showAlertWithCustomAlertView:view];
    view.width = kViewWidth;
    view.centerX = view.superview.centerX;
    return view;
}

- (void)confirm {
    if (_completionBlock) {
        _completionBlock(YES);
    }
    [self dismiss];
}

- (void)cancel {
    if (_completionBlock) {
        _completionBlock(NO);
    }
    [self dismiss];
}

- (void)dismiss {
    [self.pxAlertView dismissWithAnimated:YES];
}


+ (void)showNotificationAlertWithConfirmBlock:(void (^)())confirmBlock {
    [ONECustomGuideView showCustomGuideViewWithTopImage:[ONEUIKitTheme imageNamed:@"popup_pic_guide_push" inBundle:nil] message:@"开启推送通知" subMessage:@"您可以及时获得司机状态" tipMessage:nil confirmTitle:@"我知道了" cancelTitle:nil completion:^(BOOL confirm) {
        if (confirmBlock) {
            confirmBlock();
        }
    }];
}

+ (void)showLocationAlertWithConfirmBlock:(void (^)())confirmBlock {
    [ONECustomGuideView showCustomGuideViewWithTopImage:[ONEUIKitTheme imageNamed:@"popup_pic_guide_Gps" inBundle:nil] message:@"开启您的位置" subMessage:@"让司机师傅能准确抵达您身边" tipMessage:nil confirmTitle:@"我知道了" cancelTitle:nil completion:^(BOOL confirm) {
        if (confirmBlock) {
            confirmBlock();
        }
    }];
}

@end

#endif
