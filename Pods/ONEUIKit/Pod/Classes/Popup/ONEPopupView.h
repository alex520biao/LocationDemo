//
//  ONEPopupView.h
//  Pods
//
//  Created by 张华威 on 16/9/8.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ONEPopupViewCloseType){
    ONEPopupViewCloseTypeCancel = -1,
    ONEPopupViewCloseTypeCoverCancel = -2
};

typedef void (^ONEPopupViewcloseBlock)(ONEPopupViewCloseType type);
typedef void (^ONEPopupViewConfirmedBlock)();

typedef NS_ENUM(NSUInteger, ONEPopupViewStyle){
    ONEPopupViewStyleDefalut,
    ONEPopupViewStyleNone
};

@interface ONEPopupView : UIView

@property (nonatomic, strong) UIView *contentView; ///< 要显示的view
@property (nonatomic, assign) BOOL shouldClose; ///< 是否可以通过点击背景关闭，默认YES
@property (nonatomic, assign) BOOL showTopView; ///< 是否显示顶部View（确定，取消，title等）,默认NO
@property (nonatomic, assign, readonly) BOOL isShow;

@property (nonatomic, copy) NSString *title; ///< 顶部View的主Title
@property (nonatomic, copy) NSString *detialTitle; ///< 顶部View的副Title
@property (nonatomic, copy) NSString *confirmTitle; ///< 顶部View的确定按钮文案
@property (nonatomic, copy) NSString *cancelTitle; ///< 顶部View的取消按钮文案
@property (nonatomic, assign) BOOL autoDismiss; ///< 默认点击确定不会自动隐藏

@property (nonatomic, readonly) UILabel *titleLabel; ///< 顶部标题

- (void)showOnView:(UIView *)superView close:(ONEPopupViewcloseBlock)closeBlock confirm:(ONEPopupViewConfirmedBlock)confirmBlock;
- (void)dismiss;
@end
