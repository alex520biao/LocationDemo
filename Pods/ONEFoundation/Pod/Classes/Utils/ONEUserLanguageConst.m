//
//  ONEUserLanguageConst.m
//  Pods
//
//  Created by Liushulong on 13/01/2017.
//
//

#import "ONEUserLanguageConst.h"
#import "ONEValidJudge.h"

NSString *const ONEUserlanguageZHCN = @"zh-CN";/**< 中文(大陆) */
NSString *const ONEUserlanguageENUS = @"en-US";/**< 英语(美国) */
NSString *const ONEUserlanguageZHHK = @"zh-HK";/**< 中文(香港)*/
NSString *const ONEUserlanguagePTBR = @"pt-BR";/**< 葡萄牙语(巴西)*/

NSDictionary *DiLanguageCode_ISO639CodeMap() {
    NSDictionary *dict = @{ONEUserlanguageZHCN:@"zh-Hans"
                           ,ONEUserlanguageENUS:@"en"
                           ,ONEUserlanguageZHHK:@"zh-Hant"
                           ,ONEUserlanguagePTBR:@"pt-BR"};
    return dict;
}

NSString *DILanguageCodeToISO639(NSString *languageCode) {
    if (![ONEValidJudge isValidString:languageCode]) {
        return nil;
    }
    return [DiLanguageCode_ISO639CodeMap() objectForKey:languageCode];
}

NSString *ISO639ToDILanguageCode(NSString *languageCode) {
    
    if (![ONEValidJudge isValidString:languageCode]) {
        return nil;
    }
    
    __block NSString *lan = nil;
    [DiLanguageCode_ISO639CodeMap() enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
        
        if ([obj isEqualToString:languageCode]) {
            lan = key;
            *stop = YES;
        }
        
    }];
    
    if (!lan) { //取前缀
        NSArray *arr = [languageCode componentsSeparatedByString:@"-"];
        if ([arr count] < 2) {
            return nil;
        }
        NSString *str = [NSString stringWithFormat:@"%@-%@",arr[0],arr[1]];
        [DiLanguageCode_ISO639CodeMap() enumerateKeysAndObjectsUsingBlock:^(NSString  *_Nonnull key, NSString *  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([obj isEqualToString:str]) {
                lan = key;
                *stop = YES;
            }
            
        }];
    }
    
    return lan;
    
}

@implementation ONEUserLanguageConst

+ (BOOL)isValidLanguage:(NSString *)language {
    NSArray *array = DiLanguageCode_ISO639CodeMap().allKeys;
    return [array containsObject:language];
}

@end
