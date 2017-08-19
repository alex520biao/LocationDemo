//
//  NSBundle+ONEExtends.m
//  Pods
//
//  Created by 张华威 on 2017/5/9.
//
//

#import "NSBundle+ONEExtends.h"

@implementation NSBundle (ONEExtends)

+ (NSString *)one_pathForResource:(NSString *)resource ofType:(NSString *)type InBundle:(NSString *)bundleName {
    return [self one_pathForResource:resource ofType:type inBundle:bundleName];
}

+ (NSString *)one_pathForResource:(NSString *)resource ofType:(NSString *)type inBundle:(NSString *)bundleName {
    NSString *tmpBundleName = bundleName;
    if (tmpBundleName.length && ![tmpBundleName hasSuffix:@".bundle"]) {
        tmpBundleName = [NSString stringWithFormat:@"%@.bundle", tmpBundleName];
    }
    
    NSString *mainBundlePath = NSBundle.mainBundle.resourcePath;
    NSString *localBundlePath = [mainBundlePath stringByAppendingPathComponent:tmpBundleName];
    
    NSBundle *localBundle = [NSBundle bundleWithPath:localBundlePath];
    
    NSString *path = [localBundle pathForResource:resource ofType:type];
    
    return path;
}

@end
