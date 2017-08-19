//
//  UIViewController+ONEExtends.m
//  Pods
//
//  Created by didi on 16/10/10.
//
//

#import "UIViewController+ONEExtends.h"

@implementation UIViewController (Visible)

- (BOOL)one_isVisible {
    return [self isViewLoaded] && self.view.window;
}

@end
