//
//  UIImage+ONEWebP.h
//  SDWebImage
//
//  Created by Olivier Poitrey on 07/06/13.
//  Copyright (c) 2013 Dailymotion. All rights reserved.
//
//  WebP 使用文档：https://git.xiaojukeji.com/one-ios/ONEUIKit/blob/master/Doc/WebP.md

#define SD_WEBP 1
#ifdef SD_WEBP

#import <UIKit/UIKit.h>

// Fix for issue #416 Undefined symbols for architecture armv7 since WebP introduction when deploying to device
void WebPInitPremultiplyNEON(void);

void WebPInitUpsamplersNEON(void);

void VP8DspInitNEON(void);

@interface UIImage (ONEWebP)

#pragma mark - Cached

+ (UIImage*)one_imageWithWebPName:(NSString*)name;
+ (UIImage*)one_imageWithWebPName:(NSString*)name bundle:(NSBundle*)bundle;

#pragma mark - Direct access

+ (UIImage*)one_imageWithContentsOfWebPName:(NSString*)name; /**< not cache */
+ (UIImage*)one_imageWithContentsOfWebPName:(NSString*)name bundle:(NSBundle*)bundle; /**< not cache */

+ (UIImage*)one_imageWithWebPData:(NSData*)data scale:(CGFloat)scale; /**< not cache */

#pragma mark - Util

+ (NSInteger)one_scaleWithImageName:(NSString*)name;
+ (NSString*)one_imagePathWithName:(NSString*)name bundle:(NSBundle*)bundle type:(NSString*)type;

@end

#endif
