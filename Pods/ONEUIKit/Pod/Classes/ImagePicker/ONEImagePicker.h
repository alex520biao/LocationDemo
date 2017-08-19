//
//  KPTakePhoto.h
//  Pods
//
//  Created by lee on 15/9/23.
//
//

#import <Foundation/Foundation.h>

typedef void (^ONETakePhotoResultBlock)(UIImage *image,NSString *filePath);
@interface ONEImagePicker : NSObject
+ (void)showPickerInController:(UIViewController *)controller fileName:(NSString *)fileName result:(ONETakePhotoResultBlock)result;
@end
