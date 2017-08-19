//
//  UIView+ONETheme.m
//  Pods
//
//  Created by 张华威 on 2017/5/12.
//
//

#import "UIView+ONETheme.h"
#import "ONELocalizedTheme.h"
#import <objc/runtime.h>
#import <ONEFoundation/ONEValidJudge.h>
#import <ONEFoundation/NSObject+ONEExtends.h>
#import <ONEUIKit/ONEUIKit.h>

static void *kONELocalizedThemeValue = &kONELocalizedThemeValue;

static inline NSDictionary <NSString *, Class> *_suffixToClassMapping() {
    static NSDictionary *__suffixToClassMapping;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __suffixToClassMapping = @{
                                   @"Color":UIColor.class,
                                   @"Image":UIImage.class,
                                   };
    });
    return __suffixToClassMapping;
}

@implementation UIView (ONETheme)

- (void)oneTheme_setThemeWithId:(NSString *)identifier inPath:(NSString *)path {
    ONELocalizedTheme *theme = [ONELocalizedTheme themeWithIdentifier:identifier inPath:path];
    [self oneTheme_enableTheme:theme];
}

- (void)oneTheme_setThemeWithId:(NSString *)identifier inBundle:(NSString *)bundle {
    ONELocalizedTheme *theme = [ONELocalizedTheme themeWithIdentifier:identifier inBundle:bundle];
    [self oneTheme_enableTheme:theme];
}

- (void)oneTheme_enableTheme:(ONELocalizedTheme *)theme {
    
    [self one_associateValue:theme withKey:kONELocalizedThemeValue];
    
    NSDictionary *config = theme.currentThemeConfig;
    
    [self oneTheme_enableThemeWithConfig:config recurrence:0];
}

- (void)oneTheme_enableThemeWithConfig:(NSDictionary *)config recurrence:(NSUInteger)recursion {
    
    if (recursion > 3) {
        NSAssert(NO, @"递归调用栈过多，请优化主题结构");
        return;
    }
    __block NSUInteger locRecursion = recursion;
    [config enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([key isEqualToString:@"styleType"]) {
            return ;
        }
        
        Class propertyCls;
        NSString *setSELString = [NSString stringWithFormat:@"set%@%@:", [key substringToIndex:1].uppercaseString, [key substringFromIndex:1]];
        objc_property_t property = class_getProperty(self.class, [key UTF8String]);
        
        if (property) {
            const char *type = property_getAttributes(property);
            NSString *attr = [NSString stringWithCString:type!=NULL?type:"" encoding:NSUTF8StringEncoding];
            NSString *typeString = [attr componentsSeparatedByString:@","].firstObject;
            typeString = [[typeString stringByReplacingOccurrencesOfString:@"T@" withString:@""] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
            propertyCls = NSClassFromString(typeString);
            
            obj = [self oneTheme_transformObj:obj withClass:propertyCls];
            if (obj && [obj isKindOfClass:propertyCls]) {
                [self setValue:obj forKey:key];
                return;
            }
        }
        
        if ([self respondsToSelector:NSSelectorFromString(setSELString)]) {
            [self.class instanceMethodSignatureForSelector:NSSelectorFromString(setSELString)];
            
            for (NSString *aSuffix in _suffixToClassMapping().allKeys) {
                if ([key hasSuffix:aSuffix]) {
                    propertyCls = _suffixToClassMapping()[aSuffix];
                    break;
                }
            }
            
            obj = [self oneTheme_transformObj:obj withClass:propertyCls];
            if (obj && [obj isKindOfClass:propertyCls]) {
                [self performSelector:NSSelectorFromString(setSELString) withObject:obj];
                return;
            }
        }
        
        if ([obj isKindOfClass:NSDictionary.class] && [propertyCls isSubclassOfClass:UIView.class]) {
            UIView *subView = [self valueForKey:key];
            [subView oneTheme_enableThemeWithConfig:obj recurrence:++locRecursion];
        }
        
    }];
}

- (id)oneTheme_transformObj:(id)obj withClass:(Class)cls {
    if ([cls isSubclassOfClass:UIColor.class]) {
        obj = [UIColor one_colorWithHexString:obj];
    } else if ([cls isSubclassOfClass:UIImage.class]) {
        obj = [UIImage imageNamed:obj];
    }
    
    return obj;
}

- (void)oneTheme_setStyle:(NSUInteger)style {
    ONELocalizedTheme *theme = [self one_associatedValueForKey:kONELocalizedThemeValue class:ONELocalizedTheme.class];
    [theme setStyle:style];
    [self oneTheme_enableTheme:theme];
}

@end
