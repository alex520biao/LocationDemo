//
//  UIColor+ONEExtends.h
//  Pods
//
//  Created by didi on 16/10/10.
//
//

#import <UIKit/UIKit.h>

@interface UIColor (HEX)

@property (nonatomic, readonly) CGFloat red; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat green; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat blue; // Only valid if canProvideRGBComponents is YES
@property (nonatomic, readonly) CGFloat white; // Only valid if colorSpaceModel == kCGColorSpaceModelMonochrome
@property (nonatomic, readonly) CGFloat alpha;


+ (UIColor *)one_colorWithHex:(UInt32)hex;
+ (UIColor *)one_colorWithHex:(UInt32)hex andAlpha:(CGFloat)alpha;
+ (UIColor *)one_colorWithHexString:(NSString *)hexString;

+ (UIColor *)one_colorWithString:(NSString *)hexString;

@end
