//
//  UINavigationController+ONEExtends.m
//  Pods
//
//  Created by didi on 16/10/10.
//
//

#import "UINavigationController+ONEExtends.h"

@implementation UINavigationController (TopVC)

/**
 *  get top vc of navgationcontroller
 */
- (id)one_getTopVC {
    if ([self.viewControllers count]) {
        if ([[self.viewControllers lastObject]isKindOfClass:[UINavigationController class]]){
            UINavigationController *nav = [self.viewControllers lastObject];
            [nav one_getTopVC];
        }else if ([[self.viewControllers lastObject]isKindOfClass:[UIViewController class]]) {
            UIViewController *vc = (UIViewController *)[self.viewControllers lastObject];
            if (vc.presentedViewController)
            {
                vc = vc.presentedViewController;
                [vc.navigationController one_getTopVC];
            }
            return vc;
        }
    }
    return nil;
}

@end

@implementation UINavigationController (StackManager)
- (id)one_findViewController:(NSString*)className
{
    for (UIViewController *viewController in self.viewControllers) {
        if ([viewController isKindOfClass:NSClassFromString(className)]) {
            return viewController;
        }
    }
    
    return nil;
}

- (UIViewController *)one_rootViewController
{
    if (self.viewControllers && [self.viewControllers count] >0) {
        return [self.viewControllers firstObject];
    }
    return nil;
}

- (NSArray *)one_popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;
{
    return [self popToViewController:[self one_findViewController:className] animated:YES];
}

@end
