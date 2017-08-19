//
//  ONEAlertViewManager.h
//  DiTravel
//
//  Created by liubiao on 14-5-14.
//  Copyright (c) 2014年 didi inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ONEAlertView.h"

@class ONEAlertViewModel;

@interface ONEAlertViewManager : NSObject

    typedef enum {
    ONEAlertViewIconNone = 0,                 //无icon
    ONEAlertViewIconExclamMark,               //感叹号提示
    ONEAlertViewIconWifiError,                //wifi
    ONEAlertViewIconRedStar,                  //红心
    ONEAlertViewIconAddr,                     //地址
    ONEAlertViewIconMaike,                    //麦克
    ONEAlertViewIconLocation,                 //定位
    ONEAlertViewIconPay,                      //支付
    ONEAlertViewIconTime,                     //等待
    ONEAlertViewIconWanliu,                   //湾流专车
    ONEAlertViewIconFace,                     //笑脸
    ONEAlertViewIconCorrect,                  //成功
    ONEAlertViewIconService,                  //客服
    ONEAlertViewIconCustomImage               // 传入Image类型，调用方请传入iamge
}ONEAlertViewIcon;

+ (BOOL)isAlertShow;

/*
 *  采用view model方式自定义alertView，可简单定义，也可复杂定义。
 *  viewModel  ONEAlertViewModel
 *  completion 按钮点击处理
 */
+ (ONEAlertView *)showAlertONEAlertViewWithViewModel:(ONEAlertViewModel *)viewModel completion:(ONEAlertViewCompletionBlock)completion;


/**
 采用view model方式自定义alertView，可简单定义，也可复杂定义。

 @param modelBlock 定义alert的展示内容
 @param completion 点击事件

 @return 返回ONEAlertView实例，但不要强引用，Alert内部会持有
 */
+ (ONEAlertView *)showAlertONEAlertView:(void (^)(ONEAlertViewModel *model))modelBlock completion:(ONEAlertViewCompletionBlock)completion;

/**
 隐藏alert
 */
+ (void)dissmissAlert:(ONEAlertView *)alert animated:(BOOL)animated;

+ (ONEAlertView *)alertONEAlertViewWithViewModel:(ONEAlertViewModel *)viewModel completion:(ONEAlertViewCompletionBlock)completion;

/*
 * 慎用此方法
 */
+ (void)dissmissAll;

@end

@interface ONEAlertViewModel : NSObject

@property (nonatomic, assign) ONEAlertViewIcon    iconType;//图标样式自带枚举
@property (nonatomic, strong) UIImage            *iconImage;//图标UIImage类型
@property (nonatomic, strong) UIImage            *iconPlaceholderImage;//图标默认UIImage
@property (nonatomic, copy  ) NSString           *iconUrl;//图标内容由url设置
@property (nonatomic, assign) CGSize             iconSize;//图标宽高，不设置默认都50
@property (nonatomic, strong) UIView             *iconCustomView;//自定义iconView

@property (nonatomic, copy  ) NSString           *title;//标题

@property (nonatomic, copy  ) NSString           *message;//消息正文（黑体，16号）
@property (nonatomic, copy  ) NSAttributedString *messageOfAttributed;//消息正文AttributedString

@property (nonatomic, copy  ) NSString           *checkText;///< 可点选
@property (nonatomic, copy  ) NSString           *detialMessage;///< 不可点选

@property (nonatomic, assign) BOOL               canClose;//是否有关闭按钮
@property (nonatomic, strong) NSArray            *buttonTitles;///< !!!第一个值为高亮按钮，不区分左右

@property (nonatomic, strong) UIView             *customView;//自定义的view

@end
