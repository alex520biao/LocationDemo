//
//  TRValidJudge.m
//  DiTravel
//
//  Created by 李 贤辉 on 14-5-15.
//  Copyright (c) 2014年 didi inc. All rights reserved.
//

#import "ONEValidJudge.h"
#import <arpa/inet.h>

@implementation ONEValidJudge

/*
 是否是有效字符串
 */
+ (BOOL)isValidString:(NSString *)aString{
    if ([aString isKindOfClass:[NSString class]] && [aString length] > 0){
        return YES;
    }else{
        return NO;
    }
}

/*
 是否是有效NSArray
 */
+ (BOOL)isValidArray:(NSArray *)aArray{
    if ([aArray isKindOfClass:[NSArray class]]){
        return YES;
    }else{
        return NO;
    }
}

/*
 是否是有效NSDictionary
 */
+ (BOOL)isValidDictionary:(NSDictionary *)aDictionary{
    if ([aDictionary isKindOfClass:[NSDictionary class]]){
        return YES;
    }else{
        return NO;
    }
}

/*
 是否大于0
 */
+ (BOOL)isValidInteger:(NSInteger)count{
    return (count >= 0) ? YES : NO;
}

/*
 是否有效数据
 */
+ (BOOL)isValidDistance:(NSString *)aDistance{
    if ([self isValidString:aDistance] && [aDistance floatValue] >= 0.00000) {
        return YES;
    } else {
        return NO;
    }
}

/*
 是否有效时间
 */
+ (BOOL)isValidTime:(NSString *)aTime{
    if ([self isValidString:aTime] && [aTime integerValue] >= 0) {
        return YES;
    } else {
        return NO;
    }
}

/*
 是否为有效的经纬度
 */
+ (BOOL)isValidCoor2D:(CLLocationCoordinate2D)aCoor2D{
    if ((fabs(aCoor2D.latitude) >= 0.1 || fabs(aCoor2D.longitude) >= 0.1) && CLLocationCoordinate2DIsValid(aCoor2D)) {
        return YES;
    } else {
        return NO;
    }
}

#pragma mark - 浮点型及相关数据结构合法性判断(判断NaN)

/*!
 *  @brief  判断是否为有效/合法的浮点数
 *
 *  @param value
 *
 *  @return
 */
+ (BOOL)isValidFloat:(CGFloat)value{
    if(!isnan(value)){
        return YES;
    }else{
        return NO;
    }
}

/*!
 *  @brief  判断是否为有效/合法的时间戳
 *
 *  @param timeInterval
 *
 *  @return
 */
+ (BOOL)isValidTimeInterval:(NSTimeInterval)timeInterval{
    if(!isnan(timeInterval)){
        return YES;
    }else{
        return NO;
    }
}

/*!
 *  @brief  判断是否为有效/合法的点
 *
 *  @param point
 *
 *  @return
 */
+ (BOOL)isValidPoint:(CGPoint)point{
    //x,y均不能为NaN,否则会引起视图crash
    if(!isnan(point.x) && !isnan(point.y)){
        return YES;
    }else{
        return NO;
    }
}

/*!
 *  @brief  判断是否为有效/合法的尺寸
 *
 *  @param size
 *
 *  @return
 */
+ (BOOL)isValidSize:(CGSize)size{
    //width,height均不能为NaN,否则会引起视图crash
    if(!isnan(size.width) && !isnan(size.height)){
        return YES;
    }else{
        return NO;
    }
}

/*!
 *  @brief  判断是否为有效/合法的frame
 *
 *  @param frame
 *
 *  @return
 */
+ (BOOL)isValidFrame:(CGRect)frame{
    //origin,size均不能为NaN,否则会引起视图crash
    if([ONEValidJudge isValidPoint:frame.origin] && [ONEValidJudge isValidSize:frame.size]){
        return YES;
    }else{
        return NO;
    }
}

+ (BOOL)isValidIPAddress:(NSString*)str {
    if ([ONEValidJudge isValidString:str] == NO) {
        return NO;
    }
    
    const char *utf8 = [str UTF8String];
    int success;
    
    struct in_addr dst;
    success = inet_pton(AF_INET, utf8, &dst);
    if (success != 1) {
        struct in6_addr dst6;
        success = inet_pton(AF_INET6, utf8, &dst6);
    }
    
    return success == 1;
}

+ (BOOL)isValidURLHost:(NSString*)str {
    if ([ONEValidJudge isValidString:str] == NO) {
        return NO;
    }
    
    if ([str componentsSeparatedByString:@"."].count < 2) {
        return NO;
    }
    
    return YES;
}

@end
