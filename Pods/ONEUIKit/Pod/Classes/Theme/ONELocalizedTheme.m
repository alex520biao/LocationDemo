//
//  ONELocalizedTheme.m
//  Pods
//
//  Created by 张华威 on 2017/5/8.
//
//

#import "ONELocalizedTheme.h"
#import <ONEFoundation/ONEFoundation.h>
#import <ONEUIKit/ONEUIKit.h>
#import <objc/runtime.h>

@interface ONELocalizedThemeStore : NSObject
@property (nonatomic, strong) NSMutableDictionary <NSString *, NSDictionary *> *allConfigs;
@end

@implementation ONELocalizedThemeStore
ARC_SYNTHESIZE_SINGLETON_FOR_CLASS(ONELocalizedThemeStore)

- (instancetype)init {
    if (self = [super init]) {
        _allConfigs = [NSMutableDictionary dictionary];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMemoryWarning) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)handleMemoryWarning {
    [self.allConfigs removeAllObjects];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end

@interface ONELocalizedTheme () {
    NSString *_identifier;
    NSString *_path;
    NSDictionary *_currentThemeConfig;
}

@end

@implementation ONELocalizedTheme

#pragma mark - public

+ (ONELocalizedTheme *)themeWithIdentifier:(NSString *)identifier inBundle:(NSString *)bundle {
    NSString *path = [NSBundle one_pathForResource:@"ONETheme" ofType:@"json" inBundle:bundle];
    return [self themeWithIdentifier:identifier inPath:path];
}

+ (ONELocalizedTheme *)themeWithIdentifier:(NSString *)identifier inPath:(NSString *)path {
    return [ONELocalizedTheme.alloc initWithThemeWithIdentifier:identifier inPath:path];
}

+ (void)clear {
    [ONELocalizedThemeStore.sharedInstance.allConfigs removeAllObjects];
}

- (void)setStyle:(NSUInteger)style {
    __block NSDictionary *themeConfig;
    
    [self.themeConfigs enumerateObjectsUsingBlock:^(NSDictionary * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![ONEValidJudge isValidDictionary:obj]) {
            return ;
        }
        if ([obj[@"styleType"] integerValue] == style) {
            themeConfig = obj;
            *stop = YES;
        }
    }];
    if ([ONEValidJudge isValidDictionary:themeConfig]) {
        _currentThemeConfig = themeConfig;
    }
}

- (UIColor *)colorForKey:(NSString *)key {
    NSString *colorHexString = _currentThemeConfig[key];
    return [UIColor one_colorWithHexString:colorHexString];
}

- (UIImage *)imageForKey:(NSString *)key {
    NSString *imageNamed = _currentThemeConfig[key];
    return [UIImage imageNamed:imageNamed];
}

- (id)valueForKey:(NSString *)key {
    return _currentThemeConfig[key];
}

- (NSDictionary *)currentThemeConfig {
    return _currentThemeConfig;
}

#pragma mark - private

- (instancetype)initWithThemeWithIdentifier:(NSString *)identifier inPath:(NSString *)path {
    NSAssert([ONEValidJudge isValidString:identifier], @"无效的id:%@", identifier);
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _identifier = identifier;
    _path = path;
    
    NSArray *themeConfigs;
    
    if ([ONEValidJudge isValidArray:self.themeConfigs]) {
        themeConfigs = self.themeConfigs;
    } else {
        NSData *jsonData = [NSData.alloc initWithContentsOfFile:path];
        
        if (!jsonData.length) {
            return nil;
        }
        
        NSDictionary *dictionary;
        dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:nil];
        if (![ONEValidJudge isValidDictionary:dictionary]) {
            NSAssert(NO, @"配置文件不正确");
            return nil;
        }
        
        if (![ONEValidJudge isValidArray:dictionary[identifier]]) {
            return nil;
        }
        
        [ONELocalizedThemeStore.sharedInstance.allConfigs one_setValue:dictionary forKey:_path];
        themeConfigs = dictionary[identifier];
    }
    
    if ([ONEValidJudge isValidDictionary:themeConfigs.firstObject]) {
        _currentThemeConfig = themeConfigs.firstObject;
        _style = [themeConfigs.firstObject[@"styleType"] integerValue];
    }

    return self;
}

- (NSArray *)themeConfigs {
    NSArray *configs = ONELocalizedThemeStore.sharedInstance.allConfigs[_path][_identifier];
    return [ONEValidJudge isValidArray:configs] ? configs : nil;
}
@end
