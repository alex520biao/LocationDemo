//
//  ONEPixelAlign.m
//  Pods
//
//  Created by guoyaoyuan on 16/6/20.
//
//

#import "ONEPixelAlign.h"

static CGFloat ONEScreenScale() {
    static CGFloat scale;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        scale = [UIScreen mainScreen].scale;
    });
    return scale;
}

#pragma mark convert

CGFloat ONEPixelToFloat(CGFloat value) {
    return value / ONEScreenScale();
}

CGFloat ONEPixelFromFloat(CGFloat value) {
    return value * ONEScreenScale();
}

#pragma mark float

CGFloat ONEPixelFloor(CGFloat value) {
    CGFloat scale = ONEScreenScale();
    return floor(value * scale) / scale;
}

CGFloat ONEPixelRound(CGFloat value) {
    CGFloat scale = ONEScreenScale();
    return round(value * scale) / scale;
}

CGFloat ONEPixelCeil(CGFloat value) {
    CGFloat scale = ONEScreenScale();
    return ceil(value * scale) / scale;
}

#pragma mark point

CGPoint ONEPixelPointFloor(CGPoint point) {
    CGFloat scale = ONEScreenScale();
    return CGPointMake(floor(point.x * scale) / scale, floor(point.y * scale) / scale);
}

CGPoint ONEPixelPointRound(CGPoint point) {
    CGFloat scale = ONEScreenScale();
    return CGPointMake(round(point.x * scale) / scale, round(point.y * scale) / scale);
}

CGPoint ONEPixelPointCeil(CGPoint point) {
    CGFloat scale = ONEScreenScale();
    return CGPointMake(ceil(point.x * scale) / scale, ceil(point.y * scale) / scale);
}

#pragma mark size

CGSize ONEPixelSizeFloor(CGSize size) {
    CGFloat scale = ONEScreenScale();
    return CGSizeMake(floor(size.width * scale) / scale, floor(size.height * scale) / scale);
}

CGSize ONEPixelSizeRound(CGSize size) {
    CGFloat scale = ONEScreenScale();
    return CGSizeMake(round(size.width * scale) / scale, round(size.height * scale) / scale);
}

CGSize ONEPixelSizeCeil(CGSize size) {
    CGFloat scale = ONEScreenScale();
    return CGSizeMake(ceil(size.width * scale) / scale, ceil(size.height * scale) / scale);
}

#pragma mark rect

CGRect ONEPixelRectFloor(CGRect rect) {
    CGPoint origin = ONEPixelPointCeil(rect.origin);
    CGPoint corner = ONEPixelPointFloor(CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height));
    CGRect ret = CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
    if (ret.size.width < 0) ret.size.width = 0;
    if (ret.size.height < 0) ret.size.height = 0;
    return ret;
}

CGRect ONEPixelRectRound(CGRect rect) {
    CGPoint origin = ONEPixelPointRound(rect.origin);
    CGPoint corner = ONEPixelPointRound(CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}

CGRect ONEPixelRectCeil(CGRect rect) {
    CGPoint origin = ONEPixelPointFloor(rect.origin);
    CGPoint corner = ONEPixelPointCeil(CGPointMake(rect.origin.x + rect.size.width, rect.origin.y + rect.size.height));
    return CGRectMake(origin.x, origin.y, corner.x - origin.x, corner.y - origin.y);
}
