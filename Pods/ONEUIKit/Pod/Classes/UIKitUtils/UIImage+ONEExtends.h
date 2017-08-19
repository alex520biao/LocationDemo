//
//  UIImage+ONEExtends.h
//  Pods
//
//  Created by didi on 16/10/10.
//
//

#import <UIKit/UIKit.h>

@interface UIImage(Pod)

//bundle name should be like "ONEOperationForm.bundle";
+ (UIImage*)one_imageNamed:(NSString *)name bundleName:(NSString *)podName;

@end

@interface UIImage (FX)

- (UIImage *)one_imageWithCornerRadius:(CGFloat)radius;

@end

@interface UIImage (Color)

+ (UIImage *)one_imageWithColor:(UIColor *)color;

@end

@interface UIImage (Blur)

- (UIImage *)one_blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor;

@end

@interface UIImage (AssetLaunchImage)

/**
 *  Constructs launch image name and returns it via @code [UIImage imageNamed:] @endcode method if cache is YES
 *  or via @code [UIImage imageWithContentsOfFile:] @endcode if cache is NO.
 *  App should use Asset catalog or this method may return nil.
 *
 *  @param orientation Image orientation to find.
 *  @param cache       If image should be cached by system means.
 *
 *  @return Launch image with passed orientation.
 */
+ (UIImage *)one_assetLaunchImageWithOrientation:(UIInterfaceOrientation)orientation useSystemCache:(BOOL)cache;

@end
