//
//  TRValidJudge.h
//  DiTravel
//
//  Created by 李 贤辉 on 14-5-15.
//  Copyright (c) 2014年 didi inc. All rights reserved.

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface ONEValidJudge : NSObject

/*
 是否是有效字符串
 */
+ (BOOL)isValidString:(NSString *)aString;

/*
 是否是有效NSArray
 */
+ (BOOL)isValidArray:(NSArray *)aArray;

/*
 是否是有效NSDictionary
 */
+ (BOOL)isValidDictionary:(NSDictionary *)aDictionary;

/*
 是否大于0
 */
+ (BOOL)isValidInteger:(NSInteger)count;

/*
 是否有效距离数据
 */
+ (BOOL)isValidDistance:(NSString *)aDistance;

/*
 是否有效时间
 */
+ (BOOL)isValidTime:(NSString *)aTime;

/*
 是否为有效的经纬度
 */
+ (BOOL)isValidCoor2D:(CLLocationCoordinate2D)aCoor2D;


#pragma mark - 浮点型及相关数据结构合法性判断(判断NaN)
/*!
 *  @brief  判断是否为有效/合法的浮点数
 *
 *  @param value
 *
 *  @return isValid
 */
+ (BOOL)isValidFloat:(CGFloat)value;

/*!
 *  @brief  判断是否为有效/合法的时间戳
 *
 *  @param timeInterval, NSDate的timeIntervalSinceDate返回NaN
 *
 *  @return isValid
 */
+ (BOOL)isValidTimeInterval:(NSTimeInterval)timeInterval;

/*!
 *  @brief  判断是否为有效/合法的点
 *
 *  @param point, 如视图设置center时判断center是否合法
 *
 *  @return isValid
 */
+ (BOOL)isValidPoint:(CGPoint)point;

/*!
 *  @brief  判断是否为有效/合法的尺寸
 *
 *  @param size
 *
 *  @return isValid
 */
+ (BOOL)isValidSize:(CGSize)size;

/*!
 *  @brief  判断是否为有效/合法的frame
 *
 *  @param frame 视图设置frame时判断frame是否合法
 *
 *  @return isValid
 */
+ (BOOL)isValidFrame:(CGRect)frame;

/*!
 *  @brief 是否是有效的 ip 地址
 *
 *  @param str ip 地址
 *
 *  @return isValid
 */
+ (BOOL)isValidIPAddress:(NSString*)str;

/*!
 *  @brief 是否是有效的 host 地址
 *
 *  @param str host 地址
 *
 *  @return isValid
 */
+ (BOOL)isValidURLHost:(NSString*)str;

@end
