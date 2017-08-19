//
//  UIView+ONETheme.h
//  Pods
//
//  Created by 张华威 on 2017/5/12.
//
//

#import <UIKit/UIKit.h>

@interface UIView (ONETheme)

- (void)oneTheme_setThemeWithId:(NSString *)identifier inPath:(NSString *)path;

- (void)oneTheme_setThemeWithId:(NSString *)identifier inBundle:(NSString *)bundle;

- (void)oneTheme_setStyle:(NSUInteger)style;

@end
