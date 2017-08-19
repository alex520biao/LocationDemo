//
//  KPTakePhoto.h
//  Pods
//
//  Created by lee on 15/9/23.
//
//

#import "ONEImagePicker.h"
#import <ONEFoundation/ONEFoundation.h>
#define ONETakePhotoLocalizedStr(str) ONELocalizedStr(str, @"ONEUIKit-ImagePicker")
static NSString *const cancelTitle = @"取消";
static NSString *const librayTitle = @"相册中获取";
static NSString *const phoneLibrayTitle = @"从手机相册选择";
static NSString *const cameraTitle = @"拍照";
@interface ONEImagePicker()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic ,copy) ONETakePhotoResultBlock block;
@property (nonatomic ,weak) UIViewController *parrentViewController;
@property (nonatomic ,strong) UIAlertController *alertSheet;
@property (nonatomic ,strong) UIImagePickerController *imagePicker;
@property (nonatomic ,copy) NSString *fileName;
@end

@implementation ONEImagePicker

+ (void)showPickerInController:(UIViewController *)controller fileName:(NSString *)fileName result:(ONETakePhotoResultBlock)result{
    ONEImagePicker *imagerPicker = [[ONEImagePicker alloc]init];
    imagerPicker.block = result;
    imagerPicker.fileName = fileName;
    imagerPicker.parrentViewController = controller;
    [controller presentViewController:imagerPicker.alertSheet animated:YES completion:nil];
}


#pragma mark - imagePicker delegte

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    if(picker.sourceType == UIImagePickerControllerSourceTypeCamera){
        UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    }
    if (self.fileName.length == 0) {
        NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
        self.fileName = [dateFormatter stringFromDate:[NSDate date]];
    }
    NSArray<NSString *> *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filePath = [paths.firstObject stringByAppendingPathComponent:self.fileName];
    NSData *data = UIImageJPEGRepresentation(image,0.5);
    [[NSFileManager defaultManager] createFileAtPath:filePath contents:data attributes:nil];
    self.block(image,filePath);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - getter

- (UIAlertController *)alertSheet{
    if (!_alertSheet) {
        _alertSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:ONETakePhotoLocalizedStr(cancelTitle) style:UIAlertActionStyleCancel handler:nil];
        [_alertSheet addAction:cancel];
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            UIAlertAction *openCamera = [UIAlertAction actionWithTitle:ONETakePhotoLocalizedStr(cameraTitle) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self.parrentViewController presentViewController:self.imagePicker animated:YES completion:nil];
            }];
            [_alertSheet addAction:openCamera];
            UIAlertAction *openLibray = [UIAlertAction actionWithTitle: ONETakePhotoLocalizedStr(phoneLibrayTitle) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.parrentViewController presentViewController:self.imagePicker animated:YES completion:nil];
            }];
            [_alertSheet addAction:openLibray];
        }
        else {
            UIAlertAction *openLibray = [UIAlertAction actionWithTitle:ONETakePhotoLocalizedStr(librayTitle) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                [self.parrentViewController presentViewController:self.imagePicker animated:YES completion:nil];
            }];
            [_alertSheet addAction:openLibray];
        }
    }
    return _alertSheet;
}


- (UIImagePickerController *)imagePicker{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc]init];
        _imagePicker.delegate = self;
        _imagePicker.allowsEditing = YES;
    }
    return _imagePicker;
}

@end

