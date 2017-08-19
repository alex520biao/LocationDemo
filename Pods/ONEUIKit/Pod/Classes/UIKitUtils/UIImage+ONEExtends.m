//
//  UIImage+ONEExtends.m
//  Pods
//
//  Created by didi on 16/10/10.
//
//

#import "UIImage+ONEExtends.h"
#import <Accelerate/Accelerate.h>

@implementation UIImage(Pod)

+ (UIImage*)one_imageNamed:(NSString *)name bundleName:(NSString *)podName{
    //bundle name should be like "ONEOperationForm.bundle";
    NSString *path = [NSString stringWithFormat:@"%@/%@", podName, name];
    UIImage *image = [UIImage imageNamed:path];
    return image;
}

@end

@implementation UIImage (FX)

- (UIImage *)one_imageWithCornerRadius:(CGFloat)radius
{
    //create drawing context
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //clip image
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0.0f, radius);
    CGContextAddLineToPoint(context, 0.0f, self.size.height - radius);
    CGContextAddArc(context, radius, self.size.height - radius, radius, M_PI, M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, self.size.width - radius, self.size.height);
    CGContextAddArc(context, self.size.width - radius, self.size.height - radius, radius, M_PI / 2.0f, 0.0f, 1);
    CGContextAddLineToPoint(context, self.size.width, radius);
    CGContextAddArc(context, self.size.width - radius, radius, radius, 0.0f, -M_PI / 2.0f, 1);
    CGContextAddLineToPoint(context, radius, 0.0f);
    CGContextAddArc(context, radius, radius, radius, -M_PI / 2.0f, M_PI, 1);
    CGContextClip(context);
    
    //draw image
    [self drawAtPoint:CGPointZero];
    
    //capture resultant image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //return image
    return image;
}

@end

@implementation UIImage (Color)
+ (UIImage *)one_imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end



@implementation UIImage (Blur)

- (UIImage *)one_blurredImageWithRadius:(CGFloat)radius iterations:(NSUInteger)iterations tintColor:(UIColor *)tintColor
{
    //image must be nonzero size
    if (floorf(self.size.width) * floorf(self.size.height) <= 0.0f) return self;
    
    //boxsize must be an odd integer
    uint32_t boxSize = (uint32_t)(radius * self.scale);
    if (boxSize % 2 == 0) boxSize ++;
    
    //create image buffers
    CGImageRef imageRef = self.CGImage;
    vImage_Buffer buffer1, buffer2;
    buffer1.width = buffer2.width = CGImageGetWidth(imageRef);
    buffer1.height = buffer2.height = CGImageGetHeight(imageRef);
    buffer1.rowBytes = buffer2.rowBytes = CGImageGetBytesPerRow(imageRef);
    size_t bytes = buffer1.rowBytes * buffer1.height;
    buffer1.data = malloc(bytes);
    buffer2.data = malloc(bytes);
    
    //create temp buffer
    void *tempBuffer = malloc((size_t)vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, NULL, 0, 0, boxSize, boxSize,
                                                                 NULL, kvImageEdgeExtend + kvImageGetTempBufferSize));
    
    //copy image data
    CFDataRef dataSource = CGDataProviderCopyData(CGImageGetDataProvider(imageRef));
    memcpy(buffer1.data, CFDataGetBytePtr(dataSource), bytes);
    CFRelease(dataSource);
    
    for (NSUInteger i = 0; i < iterations; i++)
    {
        //perform blur
        vImageBoxConvolve_ARGB8888(&buffer1, &buffer2, tempBuffer, 0, 0, boxSize, boxSize, NULL, kvImageEdgeExtend);
        
        //swap buffers
        void *temp = buffer1.data;
        buffer1.data = buffer2.data;
        buffer2.data = temp;
    }
    
    //free buffers
    free(buffer2.data);
    free(tempBuffer);
    
    //create image context from buffer
    CGContextRef ctx = CGBitmapContextCreate(buffer1.data, buffer1.width, buffer1.height,
                                             8, buffer1.rowBytes, CGImageGetColorSpace(imageRef),
                                             CGImageGetBitmapInfo(imageRef));
    
    //apply tint
    if (tintColor && CGColorGetAlpha(tintColor.CGColor) > 0.0f)
    {
        CGContextSetFillColorWithColor(ctx, [tintColor colorWithAlphaComponent:0.25].CGColor);
        CGContextSetBlendMode(ctx, kCGBlendModePlusLighter);
        CGContextFillRect(ctx, CGRectMake(0, 0, buffer1.width, buffer1.height));
    }
    
    //create image from context
    imageRef = CGBitmapContextCreateImage(ctx);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    CGContextRelease(ctx);
    free(buffer1.data);
    return image;
}

@end

// Thanks to http://stackoverflow.com/a/20045142/2082172
// This category supports only iOS 7+, although it should be easy to add 6- support.

static NSString * const kAssetImageBaseFileName							= @"LaunchImage";

// Asset catalog part

static CGFloat const kAssetImage4inchHeight								= 568.;
static CGFloat const kAssetImage35inchHeight							= 480.;
static CGFloat const kAssetImage6PlusScale								= 3.;

static NSString * const kAssetImageiOS8Prefix							= @"-800";
static NSString * const kAssetImageiOS7Prefix							= @"-700";
static NSString * const kAssetImagePortraitString						= @"-Portrait";
static NSString * const kAssetImageLandscapeString						= @"-Landscape";
static NSString * const kAssetImageiPadPostfix							= @"~ipad";
static NSString * const kAssetImageHeightFormatString					= @"-%.0fh";
static NSString * const kAssetImageScaleFormatString					= @"@%.0fx";

// IB based part
static NSString * const kAssetImageLandscapeLeftString					= @"-LandscapeLeft";
static NSString * const kAssetImagePathToFileFormatString				= @"~/Library/Caches/LaunchImages/%@/%@";
static NSString * const kAssetImageSizeFormatString						= @"{%.0f,%.0f}";


@implementation UIImage (AssetLaunchImage)

+ (UIImage *)one_assetLaunchImageWithOrientation:(UIInterfaceOrientation)orientation useSystemCache:(BOOL)cache
{
    UIScreen *screen = [UIScreen mainScreen];
    CGFloat screenHeight = screen.bounds.size.height;
    if ([screen respondsToSelector:@selector(convertRect:toCoordinateSpace:)]) {
        screenHeight = [screen.coordinateSpace convertRect:screen.bounds toCoordinateSpace:screen.fixedCoordinateSpace].size.height;
    }
    CGFloat scale = screen.scale;
    BOOL portrait = UIInterfaceOrientationIsPortrait(orientation);
    BOOL isiPhone = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone);
    BOOL isiPad = ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad);
    NSMutableString *imageNameString = [NSMutableString stringWithString:kAssetImageBaseFileName];
    if (isiPhone && screenHeight > kAssetImage4inchHeight) { // currently here will be launch images for iPhone 6 and 6 plus
        [imageNameString appendString:kAssetImageiOS8Prefix];
    } else {
        [imageNameString appendString:kAssetImageiOS7Prefix];
    }
    if (scale >= kAssetImage6PlusScale || isiPad) {
        NSString *orientationString = portrait ? kAssetImagePortraitString : kAssetImageLandscapeString;
        [imageNameString appendString:orientationString];
    }
    
    if (isiPhone && screenHeight > kAssetImage35inchHeight) {
        [imageNameString appendFormat:kAssetImageHeightFormatString, screenHeight];
    }
    if (scale > 1) {
        [imageNameString appendFormat:kAssetImageScaleFormatString, scale];
    }
    if (isiPad) {
        [imageNameString appendString:kAssetImageiPadPostfix];
    }
    if (cache) {
        return [UIImage imageNamed:imageNameString];
    } else {
        NSString* pathToFile = [[NSBundle mainBundle] pathForResource:imageNameString ofType:@".png"];
        return [UIImage imageWithContentsOfFile:pathToFile];
    }
}

@end


