//
//  ONEStringWithColor.m
//  Pods
//
//  Created by 张华威 on 2017/3/27.
//
//

#import "ONEStringWithColor.h"
#import <ONEFoundation/ONEFoundation.h>

@implementation ONEStringWithColor

//按层级去掉大括号
+ (NSString *)getNewString:(NSString *)str {
    if (str.length==0)
        return nil;
    
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSMutableString *mStr = [NSMutableString string];
    
    NSRange range = NSMakeRange(0, 0);
    BOOL needFindRight = NO;
    NSUInteger bufLength = 0;
    
    for (int i = 0; i < str.length; i++) {
        NSString *aChar = [str substringWithRange:NSMakeRange(i, 1)];
        if (!needFindRight) {
            if ([aChar isEqualToString:@"{"]) {
                range.location = i - bufLength++;
                needFindRight = YES;
            } else {
                NSAssert(![aChar isEqualToString:@"}"], @"大括号层级出现异常");
                [mStr appendString:aChar];
            }
        } else {
            if ([aChar isEqualToString:@"}"]) {
                [rangeArray addObject:[NSValue valueWithRange:range]];
                range = NSMakeRange(0, 0);
                needFindRight = NO;
                bufLength++;
            } else {
                NSAssert(![aChar isEqualToString:@"{"], @"大括号层级出现异常");
                range.length++;
                [mStr appendString:aChar];
            }
        }
    }
    
    if (needFindRight) {
        NSAssert(NO, @"存在多余的大括号");
    }
    
    return mStr;
}

//ios6以上处理显示文字
+ (NSMutableAttributedString *)getAttibutedString:(NSString *)str lightColor:(UIColor *)lColor normalColor:(UIColor *)nColor font:(UIFont *)afont {
    return [self getAttibutedString:str lightColor:lColor normalColor:nColor lightFont:afont normalFont:afont];
}

+ (NSMutableAttributedString *)getAttibutedString:(NSString *)str lightColor:(UIColor *)lColor normalColor:(UIColor *)nColor lightFont:(UIFont *)lfont normalFont:(UIFont *)nfont {
    
    NSMutableArray *rangeArray = [NSMutableArray array];
    NSMutableString *mStr = [NSMutableString string];
    
    NSRange range = NSMakeRange(0, 0);
    BOOL needFindRight = NO;
    NSUInteger bufLength = 0;
    
    for (int i = 0; i < str.length; i++) {
        NSString *aChar = [str substringWithRange:NSMakeRange(i, 1)];
        if (!needFindRight) {
            if ([aChar isEqualToString:@"{"]) {
                range.location = i - bufLength++;
                needFindRight = YES;
            } else {
                NSAssert(![aChar isEqualToString:@"}"], @"大括号层级出现异常");
                [mStr appendString:aChar];
            }
        } else {
            if ([aChar isEqualToString:@"}"]) {
                [rangeArray addObject:[NSValue valueWithRange:range]];
                range = NSMakeRange(0, 0);
                needFindRight = NO;
                bufLength++;
            } else {
                NSAssert(![aChar isEqualToString:@"{"], @"大括号层级出现异常");
                range.length++;
                [mStr appendString:aChar];
            }
        }
    }
    if (needFindRight) {
        NSAssert(NO, @"存在多余的大括号");
        [rangeArray addObject:[NSValue valueWithRange:range]];
    }
    
    NSMutableAttributedString *attStr = [[NSMutableAttributedString alloc] initWithString:mStr];
    
    //普通文案
    [attStr addAttribute:NSForegroundColorAttributeName
                   value:nColor
                   range:NSMakeRange(0, mStr.length)];
    [attStr addAttribute:NSFontAttributeName value:nfont range:NSMakeRange(0, mStr.length)];
    
    //高亮文案
    [rangeArray enumerateObjectsUsingBlock:^(NSValue * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [attStr addAttribute:NSForegroundColorAttributeName
                       value:lColor
                       range:[obj rangeValue]];
        [attStr addAttribute:NSFontAttributeName value:lfont range:[obj rangeValue]];
        
    }];
    
    return attStr;
}


@end
