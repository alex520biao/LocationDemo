//
//  ONELocalizedTheme.h
//  Pods
//
//  Created by 张华威 on 2017/5/8.
//
//

#import <UIKit/UIKit.h>

@interface ONELocalizedTheme : NSObject

@property (nonatomic, assign) NSUInteger style;

- (UIColor *)colorForKey:(NSString *)key;

- (UIImage *)imageForKey:(NSString *)key;

- (id)valueForKey:(NSString *)key;

- (NSDictionary *)currentThemeConfig;

+ (ONELocalizedTheme *)themeWithIdentifier:(NSString *)identifier inPath:(NSString *)path;

+ (ONELocalizedTheme *)themeWithIdentifier:(NSString *)identifier inBundle:(NSString *)bundle;

+ (void)clear;

@end
