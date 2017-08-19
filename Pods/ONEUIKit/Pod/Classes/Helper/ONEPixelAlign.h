//
//  ONEPixelAlign.h
//  Pods
//
//  Created by guoyaoyuan on 16/6/20.
//
//

#import <UIKit/UIKit.h>

/**
 在用手动布局时，需要把控件边缘与屏幕像素进行对齐，避免出现模糊的图像或线条。
 用 AutoLayout 时，像素对齐是默认行为，不需要手动处理。
 */

#pragma mark convert
/// 将像素转为 point 值
CGFloat ONEPixelToFloat(CGFloat value);
/// 将 point 值转为像素
CGFloat ONEPixelFromFloat(CGFloat value);

#pragma mark float
/// CGFloat 像素对齐 (向下取整)
CGFloat ONEPixelFloor(CGFloat value);
/// CGFloat 像素对齐 (四舍五入)
CGFloat ONEPixelRound(CGFloat value);
/// CGFloat 像素对齐 (向上取整)
CGFloat ONEPixelCeil(CGFloat value);

#pragma mark point
/// CGPoint 像素对齐 (向下取整)
CGPoint ONEPixelPointFloor(CGPoint point);
/// CGPoint 像素对齐 (四舍五入)
CGPoint ONEPixelPointRound(CGPoint point);
/// CGPoint 像素对齐 (向上取整)
CGPoint ONEPixelPointCeil(CGPoint point);

#pragma mark size
/// CGSize 像素对齐 (向下取整)
CGSize ONEPixelSizeFloor(CGSize size);
/// CGSize 像素对齐 (四舍五入)
CGSize ONEPixelSizeRound(CGSize size);
/// CGSize 像素对齐 (向上取整)
CGSize ONEPixelSizeCeil(CGSize size);

#pragma mark rect
/// CGRect 像素对齐 (向下取整)
CGRect ONEPixelRectFloor(CGRect rect);
/// CGRect 像素对齐 (四舍五入)
CGRect ONEPixelRectRound(CGRect rect);
/// CGRect 像素对齐 (向上取整)
CGRect ONEPixelRectCeil(CGRect rect);
