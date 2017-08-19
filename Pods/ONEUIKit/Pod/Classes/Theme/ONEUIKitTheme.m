//
//  ONEUIKitTheme.m
//  Pods
//
//  Created by ranwenjie on 16/4/14.
//
//

#import "ONEUIKitTheme.h"
#import "ONELocalizedTheme.h"

UIColor *ONEHighlightColor() {
    ONELocalizedTheme *theme = [ONELocalizedTheme themeWithIdentifier:@"__common__ONEHighlightColor" inBundle:@"TheOneConfig"];
    UIColor *color = [theme colorForKey:@"color"];
    return color ? :kColorOrange;
}

UIColor *ONEHighlightColor1() {
    ONELocalizedTheme *theme = [ONELocalizedTheme themeWithIdentifier:@"__common__ONEHighlightColor" inBundle:@"TheOneConfig"];
    UIColor *color = [theme colorForKey:@"color"];
    return color ? :kColorOrange1;
}

@implementation ONEUIKitTheme

+ (UIColor *)colorWithHexString:(NSString *)hexString {
    NSString *stringToConvert = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    
    NSScanner *scanner = [NSScanner scannerWithString:stringToConvert];
    unsigned hexNum;
    if (![scanner scanHexInt:&hexNum]) return nil;
    return [ONEUIKitTheme _colorWithRGBHex:hexNum];
}

+ (UIColor *)colorWithHexString:(NSString *)string alpha:(CGFloat)alpha {
    return [[self colorWithHexString:string] colorWithAlphaComponent:alpha];
}

+ (UIColor *)_colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSString *)bundle {
    if (!name.length) return nil;
//    NSString *path = [NSString stringWithFormat:@"ONEUIKit.bundle/%@",name];
//    = [UIImage imageNamed:path];
//    if (image) return image;
    
    __block UIImage *image;
    if (bundle.length) {
        NSString *path = [NSString stringWithFormat:@"ONEUIKit-%@.bundle/%@", bundle, name];
        image = [UIImage imageNamed:path];
    }
    
    if (!image) {
        [@[@"Alert",@"Bubble",@"HUD",@"Popup"] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSString *path = [NSString stringWithFormat:@"ONEUIKit-%@.bundle/%@", obj, name];
            image = [UIImage imageNamed:path];
            if (image) {
                *stop = YES;
            }
        }];
    }
    
    NSAssert(image, @"找不到图片");
    
    return image;
}

+ (UIColor *)buttonTextColorWithStyle:(ONEButtonStyle)style state:(UIControlState)state {
    switch (style) {
        case ONEButtonStyleColorFlat: {
            switch (state) {
                case UIControlStateNormal: return kColorWhite;
                case UIControlStateHighlighted: return kColorLightGray5;
                case UIControlStateDisabled: return kColorWhite;
                default: break;
            }
        } break;
        case ONEButtonStyleColorBorder: {
            switch (state) {
                case UIControlStateNormal: return kColorNormalOrange;
                case UIControlStateHighlighted: return kColorNormalOrange;
                case UIControlStateDisabled: return kColorLightGray8;
                default: break;
            }
        } break;
        case ONEButtonStyleGrayBorder: {
            switch (state) {
                case UIControlStateNormal: return kColorGray;
                case UIControlStateHighlighted: return kColorGray;
                case UIControlStateDisabled: return kColorLightGray8;
                default: break;
            }
        } break;
        default: break;
    }
    
    return nil;
}

+ (UIImage *)buttomImageWithStyle:(ONEButtonStyle)style state:(UIControlState)state {
    
    static NSLock *lock;
    static NSMutableDictionary *dic;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        lock = [NSLock new];
        dic = [NSMutableDictionary new];
    });
    
    NSUInteger key = (style << 16) | state;
    [lock lock];
    UIImage *image = dic[@(key)];
    [lock unlock];
    if (image) return image;
    
    UIColor *strokeColor = nil;
    UIColor *fillColor = nil;
    switch (style) {
        case ONEButtonStyleColorFlat: {
            switch (state) {
                case UIControlStateNormal: {
                    fillColor = kColorNormalOrange;
                } break;
                case UIControlStateHighlighted: {
                    fillColor = kColorDarkOrange;
                } break;
                case UIControlStateDisabled: {
                    fillColor = kColorLightGray3;
                } break;
                default: break;
            }
        } break;
        case ONEButtonStyleColorBorder: {
            switch (state) {
                case UIControlStateNormal: {
                    fillColor = kColorWhite;
                    strokeColor = kColorNormalOrange;
                } break;
                case UIControlStateHighlighted: {
                    fillColor = [kColorDarkOrange colorWithAlphaComponent:0.08];
                    strokeColor = kColorDarkOrange;
                } break;
                case UIControlStateDisabled: {
                    fillColor = kColorWhite;
                    strokeColor = kColorLightGray3;
                } break;
                default: break;
            }
        } break;
        case ONEButtonStyleGrayBorder: {
            switch (state) {
                case UIControlStateNormal: {
                    fillColor = kColorWhite;
                    strokeColor = kColorLightGray7;
                } break;
                case UIControlStateHighlighted: {
                    fillColor = [UIColor colorWithWhite:0 alpha:0.08];;
                    strokeColor = kColorLightGray7;
                } break;
                case UIControlStateDisabled: {
                    fillColor = kColorWhite;
                    strokeColor = kColorLightGray3;
                } break;
                default: break;
            }
        } break;
        default: break;
    }
    
    if (!fillColor && !strokeColor) return nil;
    
    CGSize size = CGSizeMake(14, 14);
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat radius = 4;
    
    if (fillColor) {
        [fillColor setFill];
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height) cornerRadius:radius];
        [path fill];
    }
    
    if (strokeColor) {
        [strokeColor setStroke];
        CGFloat pixel = 1 / scale;
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(pixel / 2, pixel / 2, size.width - pixel, size.height - pixel) cornerRadius:radius];
        path.lineWidth = pixel;
        [path stroke];
    }
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    image = [image resizableImageWithCapInsets:UIEdgeInsetsMake(image.size.height / 2,
                                                                image.size.width / 2,
                                                                image.size.height / 2,
                                                                image.size.width / 2)];
    UIGraphicsEndImageContext();
    
    [lock lock];
    if (image) dic[@(key)] = image;
    [lock unlock];
    
    return image;
}

+ (UIButton *)buttonWithStyle:(ONEButtonStyle)style size:(ONEButtonSize)size {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [self setButton:button withStyle:style];
    [self setButton:button withSize:size];
    return button;
}

+ (void)setButton:(UIButton *)button withStyle:(ONEButtonStyle)style {
    [button setBackgroundImage:[self buttomImageWithStyle:style state:UIControlStateNormal]
                      forState:UIControlStateNormal];
    [button setBackgroundImage:[self buttomImageWithStyle:style state:UIControlStateHighlighted]
                      forState:UIControlStateHighlighted];
    [button setBackgroundImage:[self buttomImageWithStyle:style state:UIControlStateDisabled]
                      forState:UIControlStateDisabled];
    
    [button setTitleColor:[self buttonTextColorWithStyle:style state:UIControlStateNormal]
                 forState:UIControlStateNormal];
    [button setTitleColor:[self buttonTextColorWithStyle:style state:UIControlStateHighlighted]
                 forState:UIControlStateHighlighted];
    [button setTitleColor:[self buttonTextColorWithStyle:style state:UIControlStateDisabled]
                 forState:UIControlStateDisabled];
}

+ (void)setButton:(UIButton *)button withSize:(ONEButtonSize)size {
    CGRect frame = button.frame;
    frame.size.height = size;
    button.frame = frame;
    
    switch (size) {
        case ONEButtonSizeLarge1:
        case ONEButtonSizeLarge2:
        case ONEButtonSizeLarge3: {
            button.titleLabel.font = kFontSizeLarge;
        } break;
        case ONEButtonSizeSmall: {
            button.titleLabel.font = kFontSizeSmall;
        } break;
    }
}

@end
