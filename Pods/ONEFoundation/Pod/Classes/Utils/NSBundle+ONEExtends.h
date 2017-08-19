//
//  NSBundle+ONEExtends.h
//  Pods
//
//  Created by 张华威 on 2017/5/9.
//
//

#import <Foundation/Foundation.h>

@interface NSBundle (ONEExtends)

+ (NSString *)one_pathForResource:(NSString *)resource ofType:(NSString *)type InBundle:(NSString *)bundleName __deprecated_msg("");

+ (NSString *)one_pathForResource:(NSString *)resource ofType:(NSString *)type inBundle:(NSString *)bundleName;

@end
