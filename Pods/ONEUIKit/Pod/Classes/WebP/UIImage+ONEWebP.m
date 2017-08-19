//
//  UIImage+ONEWebP.m
//  SDWebImage
//
//  Created by Olivier Poitrey on 07/06/13.
//  Copyright (c) 2013 Dailymotion. All rights reserved.
//

#define SD_WEBP 1
#ifdef SD_WEBP
#import "UIImage+ONEWebP.h"

#if !COCOAPODS
#import "webp/decode.h"
#else
#import "webp/decode.h"
#endif

// Callback for CGDataProviderRelease
static void FreeImageData(void *info, const void *data, size_t size)
{
    free((void *)data);
}



#pragma mark - WebP Cache

@interface ONEWebPCache : NSObject

+ (nonnull instancetype)sharedCache;

- (nullable UIImage*)imageForKey:(NSString*)key;

- (void)setImage:(UIImage*)image forKey:(NSString*)key;
- (void)removeImageForKey:(NSString*)key;

- (void)clearMemoryCache;

@end

@interface ONEWebPCache ()

@property (nonatomic, strong) NSCache<NSString*, UIImage*> *cacheObject;

@end

@implementation ONEWebPCache

+ (nonnull instancetype)sharedCache {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _cacheObject = [NSCache new];
        _cacheObject.totalCostLimit = 100 * 1024 * 1024; //100M
        _cacheObject.countLimit = 15;
        _cacheObject.name = @"com.didi.theone.WebP.cache";
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMemoryCache) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearMemoryCache) name:UIApplicationDidEnterBackgroundNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setImage:(UIImage*)image forKey:(NSString*)key {
    NSCParameterAssert(image && key);
    NSCParameterAssert(key);
    if (image && key) {
        // ref: https://github.com/rs/SDWebImage/blob/master/SDWebImage/SDImageCache.m
        NSInteger cost = image.size.height * image.size.width * image.scale * image.scale;
        [self.cacheObject setObject:image forKey:key cost:cost];
    }
}

- (void)removeImageForKey:(NSString*)key {
    [self.cacheObject removeObjectForKey:key];
}

- (nullable UIImage*)imageForKey:(NSString*)key {
    return [self.cacheObject objectForKey:key];
}

- (void)clearMemoryCache {
    [self.cacheObject removeAllObjects];
}

@end


@implementation UIImage (ONEWebP)

#pragma mark - Cached

+ (UIImage*)one_imageWithWebPName:(NSString*)name {
    return [UIImage one_imageWithWebPName:name bundle:[NSBundle mainBundle] cache:YES];
}

+ (UIImage*)one_imageWithWebPName:(NSString*)name bundle:(NSBundle*)bundle {
    return [UIImage one_imageWithWebPName:name bundle:bundle cache:YES];
}

#pragma mark - Direct access

+ (UIImage*)one_imageWithContentsOfWebPName:(NSString*)name {
    return [UIImage one_imageWithWebPName:name bundle:[NSBundle mainBundle] cache:NO];
}

+ (UIImage*)one_imageWithContentsOfWebPName:(NSString*)name bundle:(NSBundle*)bundle {
    return [UIImage one_imageWithWebPName:name bundle:bundle cache:NO];
}

+ (UIImage*)one_imageWithWebPName:(NSString*)name bundle:(NSBundle*)bundle cache:(BOOL)cache {
    NSString *path = [UIImage one_imagePathWithName:name bundle:bundle type:@"webp"];
    if (path.length == 0) {
        return nil;
    }
    CGFloat scale = [UIImage one_scaleWithImageName:[path stringByDeletingPathExtension]];
    if (scale == 0) {
        scale = 1;
    }
    
    UIImage *image;
    if (cache) {
        image = [[ONEWebPCache sharedCache] imageForKey:path];
    }
    
    if (!image) {
        NSError *dataError = nil;
        NSData *imgData = [NSData dataWithContentsOfFile:path options:NSDataReadingMappedIfSafe error:&dataError];
        if (dataError != nil) {
            NSLog(@"webp image load failed: %@", dataError);
            return nil;
        }
        image = [UIImage one_imageWithWebPData:imgData scale:scale];
        if (cache) {
            [[ONEWebPCache sharedCache] setImage:image forKey:path];
        }
    }
    
    return image;
}

+ (UIImage *)one_imageWithWebPData:(NSData *)data scale:(CGFloat)scale {
    WebPDecoderConfig config;
    if (!WebPInitDecoderConfig(&config)) {
        return nil;
    }

    if (WebPGetFeatures(data.bytes, data.length, &config.input) != VP8_STATUS_OK) {
        return nil;
    }

    config.output.colorspace = config.input.has_alpha ? MODE_rgbA : MODE_RGB;
    config.options.use_threads = 1;

    // Decode the WebP image data into a RGBA value array.
    if (WebPDecode(data.bytes, data.length, &config) != VP8_STATUS_OK) {
        return nil;
    }

    int width = config.input.width;
    int height = config.input.height;
    if (config.options.use_scaling) {
        width = config.options.scaled_width;
        height = config.options.scaled_height;
    }

    // Construct a UIImage from the decoded RGBA value array.
    CGDataProviderRef provider =
    CGDataProviderCreateWithData(NULL, config.output.u.RGBA.rgba, config.output.u.RGBA.size, FreeImageData);
    CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = config.input.has_alpha ? kCGBitmapByteOrder32Big | kCGImageAlphaPremultipliedLast : 0;
    size_t components = config.input.has_alpha ? 4 : 3;
    CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
    CGImageRef imageRef = CGImageCreate(width, height, 8, components * 8, components * width, colorSpaceRef, bitmapInfo, provider, NULL, NO, renderingIntent);

    CGColorSpaceRelease(colorSpaceRef);
    CGDataProviderRelease(provider);

    UIImage *image = [[UIImage alloc] initWithCGImage:imageRef scale:scale orientation:UIImageOrientationUp];
    CGImageRelease(imageRef);

    return image;
}

#pragma mark - Utils

+ (NSString*)one_imagePathWithName:(NSString*)name bundle:(NSBundle*)bundle type:(NSString*)type {
    if (name.length <= 0 || !bundle || !type) {
        return nil;
    }
    
    NSInteger scale = [UIImage one_scaleWithImageName:name];
    
    NSString *fullName;
    if (scale != 0) { // use user specified version
        fullName = name;
    }
    else { // user is passing a common name without know suffix
        // 1. try recomment screen scale
        scale = [UIScreen mainScreen].scale;
        fullName = [NSString stringWithFormat:@"%@@%zdx", name, scale];
        
        if (![bundle pathForResource:fullName ofType:type]) {
            // 2. try @3..1x version
            BOOL isFounded = NO;
            for (int i = 3; i > 0; i--) {
                if (i == scale) { // main screen scale
                    continue;
                }
                fullName = [NSString stringWithFormat:@"%@@%zdx", name, i];
                if ([bundle pathForResource:fullName ofType:type]) {
                    scale = i;
                    isFounded = YES;
                    break;
                }
            }
            // 3. try same name file
            if (!isFounded && [bundle pathForResource:name ofType:type]) {
                scale = 1;
                fullName = name;
            }
        }
    }
    
    NSString *path = [bundle pathForResource:fullName ofType:type];
    return path;
}

+ (NSInteger)one_scaleWithImageName:(NSString*)name {
    NSInteger scale = 0;
    if (name.length > 3) { // "@3x".length
        NSString *scaleStr = [name substringWithRange:NSMakeRange(name.length-3, 3)];
        if (scaleStr.length > 0) {
            if ([scaleStr hasPrefix:@"@"] && [scaleStr hasSuffix:@"x"]) {
                scale = [[scaleStr substringFromIndex:1] integerValue];
            }
        }
    }
    return scale;
}

@end

#if !COCOAPODS
// Functions to resolve some undefined symbols when using WebP and force_load flag
void WebPInitPremultiplyNEON(void) {}
void WebPInitUpsamplersNEON(void) {}
void VP8DspInitNEON(void) {}
#endif

#endif
