//
//  ONEAlertViewManager.m
//  DiTravel
//
//  Created by liubiao on 14-5-14.
//  Copyright (c) 2014年 didi inc. All rights reserved.
//

#import "ONEAlertViewManager.h"
#import "UIImageView+WebCache.h"
#import "ONEUIKitTheme.h"

@implementation ONEAlertViewManager

#pragma mark- public

+ (ONEAlertView *)showAlertONEAlertViewWithViewModel:(ONEAlertViewModel *)viewModel completion:(ONEAlertViewCompletionBlock)completion {
    ONEAlertView *alertView = [self alertONEAlertViewWithViewModel:viewModel completion:completion];
    [alertView show];
    return alertView;
}

+ (ONEAlertView *)showAlertONEAlertView:(void (^)(ONEAlertViewModel *))modelBlock completion:(ONEAlertViewCompletionBlock)completion {
    ONEAlertViewModel *model = [[ONEAlertViewModel alloc] init];
    if (modelBlock) {
        modelBlock(model);
    }
    return [ONEAlertViewManager showAlertONEAlertViewWithViewModel:model completion:completion];
}

+ (BOOL)isAlertShow {
    BOOL ret = NO;
    UIWindow *currentWindow = [[UIApplication sharedApplication] keyWindow];
    if (!currentWindow.hidden) {
        UIViewController *vc = currentWindow.rootViewController;
        if ([NSStringFromClass([vc class]) isEqualToString:NSStringFromClass([ONEAlertView class])]) {
            ret = YES;
        }
    }
    return ret;
}

+ (void)dissmissAlert:(ONEAlertView *)alert animated:(BOOL)animated {
    [alert dismissWithAnimated:animated];
}

+ (void)dissmissAll {
    [[ONEAlertView alertViews] enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.class dissmissAlert:obj animated:NO];
    }];
}

+ (ONEAlertView *)alertONEAlertViewWithViewModel:(ONEAlertViewModel *)viewModel completion:(ONEAlertViewCompletionBlock)completion {
    
    if (viewModel.customView) {
        return [[ONEAlertView alloc] initWithCustomView:viewModel.customView buttonsTitle:viewModel.buttonTitles canClose:viewModel.canClose completion:completion];
    }
    
    UIView *iconImageView;
    BOOL isCustom = NO;
    if (viewModel.iconCustomView) {
        iconImageView = viewModel.iconCustomView;
        isCustom = YES;
    } else {
        iconImageView = [self iconImageViewWithViewMode:viewModel];
    }
    
    //fix 只设置attribute字段会隐藏label的问题
    if (viewModel.messageOfAttributed.length > 0) {
        viewModel.message = viewModel.messageOfAttributed.string;
    }
//    if (viewModel.titleOfAttributed.length > 0) {
//        viewModel.title = viewModel.titleOfAttributed.string;
//    }
    
    return [[ONEAlertView alloc] initWithTitle:viewModel.title message:viewModel.message messageOfAttributed:viewModel.messageOfAttributed checkMessaage:viewModel.checkText detialMessage:viewModel.detialMessage buttonTitles:viewModel.buttonTitles canClose:viewModel.canClose contentView:iconImageView isCustom:isCustom completion:completion];
    
}

#pragma mark - private

+ (NSString *)imageNameWithType:(ONEAlertViewIcon)type {
    NSString *imageName;

    switch (type) {
        case ONEAlertViewIconNone: {
            imageName = nil;
        } break;

        case ONEAlertViewIconExclamMark: {
            imageName = @"dialog_icon_exclam";
        } break;
            
        case ONEAlertViewIconWifiError: {
            imageName = @"dialog_icn_wifi_error";
        } break;

        case ONEAlertViewIconRedStar: {
            imageName = @"dialog_icon_heart";
        } break;

        case ONEAlertViewIconAddr: {
            imageName = @"dialog_icon_address";
        } break;
        case ONEAlertViewIconMaike: {
            imageName = @"dialog_icon_micro_error";
        } break;

        case ONEAlertViewIconLocation: {
            imageName = @"dialog_icon_gps_error";
        } break;

        case ONEAlertViewIconPay: {
            imageName = @"dialog_icon_micro_pay";
        } break;

        case ONEAlertViewIconTime: {
            imageName = @"dialog_icon_time";
        } break;

        case ONEAlertViewIconWanliu: {
            imageName = @"dialog_icon_specialcar";
        } break;

        case ONEAlertViewIconFace: {
            imageName = @"dialog_icon_face";
        } break;

        case ONEAlertViewIconCorrect: {
            imageName = @"dialog_icon_correct";
        } break;
        
        case ONEAlertViewIconService: {
            imageName = @"dialog_icon_busService";
        } break;
        default: {
            imageName = nil;
        } break;
    }

    return imageName;
}

+ (UIImage *)resizableImageWithImageName:(NSString *)imageName {
    UIImage *resizableImage = [ONEUIKitTheme imageNamed:imageName inBundle:@"Alert"];
    
    resizableImage = [resizableImage resizableImageWithCapInsets:UIEdgeInsetsMake(
                          floor(resizableImage.size.height / 2),
                          floor(resizableImage.size.width / 2),
                          floor(resizableImage.size.height / 2),
                          floor(resizableImage.size.width / 2))];
    return resizableImage;
}

+ (UIImage *)resizableImageInCustomeUIWithImageName:(NSString *)imageName {
    UIImage *resizableImage = [ONEUIKitTheme imageNamed:imageName inBundle:@"Alert"];
    
    resizableImage = [resizableImage resizableImageWithCapInsets:UIEdgeInsetsMake(
                                                                                  floor(resizableImage.size.height / 2),
                                                                                  floor(resizableImage.size.width / 2),
                                                                                  floor(resizableImage.size.height / 2),
                                                                                  floor(resizableImage.size.width / 2))];
    return resizableImage;

}

+ (UIImageView *)iconImageViewWithViewMode:(ONEAlertViewModel *)viewModel {
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, viewModel.iconSize.width, viewModel.iconSize.height)];
    
    if (viewModel.iconUrl.length > 0) {
        //iconUrl
        [imageView sd_setImageWithURL:[NSURL URLWithString:viewModel.iconUrl] placeholderImage:viewModel.iconPlaceholderImage];
    } else if (viewModel.iconImage && [viewModel.iconImage isKindOfClass:[UIImage class]]) {
        //iconImage
        imageView.image = viewModel.iconImage;
    } else {
        //iconType
        NSString *imageName = [self imageNameWithType:viewModel.iconType];
        if (imageName.length > 0) {
            imageView.image = [ONEUIKitTheme imageNamed:imageName inBundle:@"Alert"];
        } else {
            imageView = nil;
        }
    }
    
    return imageView;
}

@end

@implementation ONEAlertViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self constructDefaultValueForInit];
    }
    return self;
}

//构造默认的数值
- (void)constructDefaultValueForInit {
    self.iconSize = CGSizeMake(50, 50);
}
#pragma mark - Getter


@end
