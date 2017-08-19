//
//  UIApplication+ONEExtends.m
//  Pods
//
//  Created by qingshan on 2016/12/21.
//
//

#import "UIApplication+ONEExtends.h"

@implementation UIApplication (ONEExtends)

+ (void)one_openAppSystemPreferences {
    // iOS 8 +
    if (&UIApplicationOpenSettingsURLString != NULL) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
    // iOS7
    else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"prefs://"]];
    }
}
@end
