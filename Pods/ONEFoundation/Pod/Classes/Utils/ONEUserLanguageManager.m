//
//  ONELocalizeManager.m
//  Pods
//
//  Created by Liushulong on 12/01/2017.
//
//

#import "ONEUserLanguageManager.h"
#import "ONEValidJudge.h"
#import "ONELog.h"

NSString * const ONEUserLanguageDidChangeNotification = @"ONEUserLanguageDidChangeNotification";

NSString * const kONEUserLanguagekey = @"kONEUserLanguagekey";

NSString * const kONEUserCurrentLanguagekey = @"kONEUserCurrentLanguagekey";

static NSString *const ONEAppleLanguageKey = @"AppleLanguages";

@interface ONEUserLanguageManager ()

@property (nonatomic,copy) NSString *userLanguage;/**<用户当前语言设置,内存保存一份提高查询效率 */
@property (nonatomic,copy) NSString *currentLanguage;/**< 应IM需求保存的一份当前最新语言的状态 */
@property (nonatomic,copy) NSArray<NSString *>  *supportLanguages;/**< 当前支持的语言列表 */

@end

@implementation ONEUserLanguageManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static ONEUserLanguageManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [[ONEUserLanguageManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    
    if (self = [super init]) {
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        _userLanguage = [ud stringForKey:kONEUserLanguagekey];
        _supportLanguages = @[ONEUserlanguageZHCN,ONEUserlanguageENUS];
    }
    return self;
}

+ (NSString *)currentLanguage {
    
    //开关关闭返回第一个支持的语言
    if (![ONEUserLanguageManager sharedInstance].isMultiLanguageEnabled) {
        NSString *lang = [ONEUserLanguageManager sharedInstance].supportLanguages.firstObject;
        [self syncCurrentLanguageStatus:lang];
        return lang;
    }
    
    //用户主动设置的语言
    __block NSString *language = [ONEUserLanguageManager sharedInstance].userLanguage;
    if (language) {
        [self syncCurrentLanguageStatus:language];
        return language;
    }
    
    if (![ONEUserLanguageManager sharedInstance].useSysLanguage) {
        language = [ONEUserLanguageManager sharedInstance].supportLanguages.firstObject;
        [self syncCurrentLanguageStatus:language];
        return language;
    }
    
    //系统默认语言
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:ONEAppleLanguageKey];
    NSString *syslanguage = [languages firstObject];
    
    NSArray<NSString *> *supportLanguages = [ONEUserLanguageManager sharedInstance].supportLanguages;
    
    //非简体中文的都是英文,简体中文都以zh-Hans开头
    //https://developer.apple.com/library/content/documentation/MacOSX/Conceptual/BPInternational/LanguageandLocaleIDs/LanguageandLocaleIDs.html
    [supportLanguages enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSString *tmp = DILanguageCodeToISO639(obj);
        if ([syslanguage hasPrefix:DILanguageCodeToISO639(obj)]) {
            language = tmp;
            *stop = YES;
        }
    }];
    
    if (!language) {
        language = [supportLanguages lastObject];
    } else {
        language = ISO639ToDILanguageCode(language);
    }
    [ONEUserLanguageManager sharedInstance].userLanguage = language;
    [self syncCurrentLanguageStatus:language];
    return language;
}

/**
 * 同步当前最新的语言
 */
+ (void)syncCurrentLanguageStatus:(NSString *)language {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [self privateSyncCurrentLanguageStatus:language];
    });
    
}

+ (void)privateSyncCurrentLanguageStatus:(NSString *)language {
    
    @synchronized ([ONEUserLanguageManager sharedInstance].currentLanguage) {
        if ([language length] == 0) {
            NSLog(@"参数不合法");
            return ;
        }
        
        if ([[ONEUserLanguageManager sharedInstance].currentLanguage isEqualToString: language]) {
            return;
        }
        [ONEUserLanguageManager sharedInstance].currentLanguage = language;
        [[NSUserDefaults standardUserDefaults] setObject:language forKey:kONEUserCurrentLanguagekey];
    }

}

+ (BOOL)isLanguageRTLWithLanguage:(NSString *)language{
    
    if ([language length] == 0) {
        return NO;
    }
    
    return ([NSLocale characterDirectionForLanguage:language] == NSLocaleLanguageDirectionRightToLeft);
}

+ (void)configureSysWithLanguage:(NSString *)language {
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    //系统文字顺序
    NSString *sysLanguage = language;
    if([sysLanguage length] > 0) {
        [ud setObject:@[sysLanguage] forKey:ONEAppleLanguageKey];
        
        BOOL isRightToLeft = [self isLanguageRTLWithLanguage:sysLanguage];
        if (isRightToLeft) {
            if ([[[UIView alloc] init] respondsToSelector:@selector(setSemanticContentAttribute:)]) {
                [[UIView appearance] setSemanticContentAttribute:
                 UISemanticContentAttributeForceRightToLeft];
            }
        }else {
            if ([[[UIView alloc] init] respondsToSelector:@selector(setSemanticContentAttribute:)]) {
                [[UIView appearance] setSemanticContentAttribute:UISemanticContentAttributeForceLeftToRight];
            }
        }
        [ud setBool:isRightToLeft forKey:@"AppleTextDirection"];
        [ud setBool:isRightToLeft forKey:@"NSForceRightToLeftWritingDirection"];
    }
    [ud synchronize];
}

+ (BOOL)setLanguage:(NSString *)language {
    @synchronized (self) {
        
        if (![ONEUserLanguageManager sharedInstance].isMultiLanguageEnabled) {
            DDLogInfo(@"多语言开关关闭");
            return NO;
        }
        
        if (![ONEValidJudge isValidString:language]) {
            DDLogError(@"Error:语言设置为空");
            return NO;
        }
        
        if (![ONEUserLanguageConst isValidLanguage:language]) {
            DDLogError(@"Error:语言编码不合法");
            return NO;
        }
        
        if (![[ONEUserLanguageManager sharedInstance].supportLanguages containsObject:language]) {
            DDLogError(@"Error:不支持的语言编码");
            return NO;
        }
        
        
        NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
        [ud setObject:language forKey:kONEUserLanguagekey];
        
        //系统文字顺序
        NSString *sysLanguage = DILanguageCodeToISO639(language);
        if([sysLanguage length] > 0) {
            [self configureSysWithLanguage:sysLanguage];
        }
        
        [ud synchronize];

        
        [ONEUserLanguageManager sharedInstance].userLanguage = language;
        [self privateSyncCurrentLanguageStatus:language];
        [[NSNotificationCenter defaultCenter] postNotificationName:ONEUserLanguageDidChangeNotification object:language];
        
        return YES;
    }
}

+ (BOOL)isSimpleChinese {
    return [[self currentLanguage] isEqualToString:ONEUserlanguageZHCN];
}

+ (BOOL)setSupportedLanguages:(NSArray<NSString *> *)supportedLanguages {
    if ([supportedLanguages count] == 0) {
        NSLog(@"支持的语言不能为空");
        return NO;
    }
    
    __block BOOL valid = YES;
    [supportedLanguages enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!DILanguageCodeToISO639(obj)) {
            valid = NO;
        }
    }];
    
    if (!valid) {
        NSLog(@"存在不支持的编码类型");
        return NO;
    }
    [[ONEUserLanguageManager sharedInstance] setSupportLanguages:supportedLanguages];
    
    return YES;
}

+ (NSString *)sysFirstLanguage {
    //系统默认语言
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *languages = [defaults objectForKey:ONEAppleLanguageKey];
    NSString *syslanguage = [languages firstObject];
    return ISO639ToDILanguageCode(syslanguage);
}


@end
