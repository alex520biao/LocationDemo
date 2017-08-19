//
//  UINavigationController+ONEExtends.h
//  Pods
//
//  Created by didi on 16/10/10.
//
//

#import <UIKit/UIKit.h>

@interface UINavigationController (TopVC)

- (id)one_getTopVC;

@end

@interface UINavigationController (StackManager)
- (id)one_findViewController:(NSString*)className;
- (UIViewController *)one_rootViewController;
- (NSArray *)one_popToViewControllerWithClassName:(NSString*)className animated:(BOOL)animated;
@end
