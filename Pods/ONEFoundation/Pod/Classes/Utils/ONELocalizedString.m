//
//  ONELocalizedString.m
//  Pods
//
//  Created by 张华威 on 2016/12/14.
//
//

#import "ONELocalizedString.h"
#import "ONEUserLanguageManager.h"

//copy from yyImage
static NSArray *_ONENSBundlePreferredScales() {
    static NSArray *scales;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        CGFloat screenScale = [UIScreen mainScreen].scale;
        if (screenScale <= 1) {
            scales = @[@1,@2,@3];
        } else if (screenScale <= 2) {
            scales = @[@2,@3,@1];
        } else {
            scales = @[@3,@2,@1];
        }
    });
    return scales;
}

/**
 Add scale modifier to the file name (without path extension),
 From @"name" to @"name@2x".
 
 e.g.
 <table>
 <tr><th>Before     </th><th>After(scale:2)</th></tr>
 <tr><td>"icon"     </td><td>"icon@2x"     </td></tr>
 <tr><td>"icon "    </td><td>"icon @2x"    </td></tr>
 <tr><td>"icon.top" </td><td>"icon.top@2x" </td></tr>
 <tr><td>"/p/name"  </td><td>"/p/name@2x"  </td></tr>
 <tr><td>"/path/"   </td><td>"/path/"      </td></tr>
 </table>
 
 @param scale Resource scale.
 @return String by add scale modifier, or just return if it's not end with file name.
 */
static NSString *_ONENSStringByAppendingNameScale(NSString *string, CGFloat scale) {
    if (!string) return nil;
    if (fabs(scale - 1) <= __FLT_EPSILON__ || string.length == 0 || [string hasSuffix:@"/"]) return string.copy;
    return [string stringByAppendingFormat:@"@%@x", @(scale)];
}



NSString *ONELocalizedStr(NSString *key,NSString *bundleName) {
    return [ONELocalizedString localizedString:key inBundle:bundleName];
}

UIImage *ONELocalizedImg(NSString *imageName,NSString *bundle){
    return [ONELocalizedString localizedImage:imageName inBundle:bundle];
}


/**
 eg:
 NSBundle *bundle = ONEBundleWithName(@"ONEUIKit.bundle")
 */
static inline NSBundle *ONEBundleWithName(NSString *name) {
    NSString *tmpBundleName = name;
    if (![name hasSuffix:@".bundle"]) {
        tmpBundleName = [NSString stringWithFormat:@"%@.bundle",name];
    }
    
    NSString *mainBundlePath = [[NSBundle mainBundle] resourcePath];
    NSString *frameworkBundlePath = [mainBundlePath stringByAppendingPathComponent:tmpBundleName];
    return [NSBundle bundleWithPath:frameworkBundlePath];
}


@implementation ONELocalizedString


+ (UIImage *)localizedImage:(NSString *)imageName inBundle:(NSString *)bundleName {
    
    if (imageName.length == 0) return nil;
    if ([imageName hasSuffix:@"/"]) return nil;
    
    NSString *res = imageName.stringByDeletingPathExtension;
    NSString *ext = imageName.pathExtension;
    NSString *path = nil;
    CGFloat scale = 1;

    NSArray *exts = ext.length > 0 ? @[ext] : @[@"", @"png", @"jpg"];
    NSArray *scales = _ONENSBundlePreferredScales();
    NSBundle *tmp = ONEBundleWithName(bundleName);
    NSString *language = [ONEUserLanguageManager currentLanguage];
    
    NSString *fileNamePrefix = DILanguageCodeToISO639(language);
    if (![ONEValidJudge isValidString:fileNamePrefix]) {
        DDLogError(@"语言编码转化错误:%@",fileNamePrefix);
        return nil;
    }

    NSString *bundlePath = [tmp pathForResource:fileNamePrefix ofType:@"lproj"];
    NSBundle *bundle = [NSBundle bundleWithPath:bundlePath];
    
    for (int s = 0; s < scales.count; s++) {
        scale = ((NSNumber *)scales[s]).floatValue;
        NSString *scaledName = _ONENSStringByAppendingNameScale(res, scale);
        for (NSString *e in exts) {
            path = [bundle pathForResource:scaledName ofType:e];
            if (path) break;
        }
        if (path) break;
    }
    if (path.length == 0) return nil;
    
    NSData *data = [NSData dataWithContentsOfFile:path];
    if (data.length == 0) return nil;
    
    return [[UIImage alloc] initWithData:data scale:scale];

}


+ (NSString *)localizedString:(NSString *)key inBundle:(NSString *)bundleName {
    return [ONELocalizedString localizedString:key defaultKey:key inBundle:bundleName];
}

+ (NSString *)localizedString:(NSString *)key defaultKey:(NSString *)defaultKey inBundle:(NSString *)bundleName {
    if (![ONEValidJudge isValidString:key])
    {
        return defaultKey;
    }
    
    NSBundle *tmp = ONEBundleWithName(bundleName);
    NSString *language = [ONEUserLanguageManager currentLanguage];
    
    NSString *fileNamePrefix = DILanguageCodeToISO639(language);
    if (![ONEValidJudge isValidString:fileNamePrefix]) {
        DDLogError(@"语言编码转化错误:%@",fileNamePrefix);
        return defaultKey;
    }
    
    NSString *path = [tmp pathForResource:fileNamePrefix ofType:@"lproj"];
    NSBundle *bundle = [NSBundle bundleWithPath:path];
    NSString *localizedString = [bundle localizedStringForKey:key value:defaultKey table:@"Localizable"];
    
    if (!localizedString) {
        localizedString = defaultKey;
    }
    return localizedString;
    
}



@end
