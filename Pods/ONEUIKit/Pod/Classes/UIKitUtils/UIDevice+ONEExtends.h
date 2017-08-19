//
//  UIDevice+ONEExtends.h
//  Pods
//
//  Created by didi on 16/10/10.
//
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIDeviceModelType) {
    UIDeviceModelUnknown,
    UIDeviceModelPhone,
    UIDeviceModelPhone5,
    UIDeviceModelPhone6,
    UIDeviceModelPhone6p
};

@interface UIDevice (AutoSize)

+ (UIDeviceModelType)one_deviceModel;

//+ (NSString *)imageType;

+ (CGRect)one_autoResizeToFrame:(CGRect)rect;
+ (CGFloat)one_autoResizeHeight:(CGFloat)height;
+ (CGFloat)one_autoResizeWidth:(CGFloat)width;

@end

#pragma mark iOS 的版本判断

#ifndef kONESystemVersion
#define kONESystemVersion [UIDevice systemVersion]
#endif

#ifndef kONEiOS6Later
#define kONEiOS6Later ([[UIDevice currentDevice].systemVersion floatValue] >= 6.f)
#endif

#ifndef kONEiOS7Later
#define kONEiOS7Later ([[UIDevice currentDevice].systemVersion floatValue] >= 7.f)
#endif

#ifndef kONEiOS8Later
#define kONEiOS8Later ([[UIDevice currentDevice].systemVersion floatValue] >= 8.f)
#endif

#ifndef kONEiOS9Later
#define kONEiOS9Later ([[UIDevice currentDevice].systemVersion floatValue] >= 9.f)
#endif

#define IOS8                        ([[UIDevice currentDevice].systemVersion floatValue] >= 8.f)
#define IOS7                        ([[UIDevice currentDevice].systemVersion floatValue] >= 7.f)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
#define DEVICE_IOS_VERSION [[UIDevice currentDevice].systemVersion floatValue]
#define DEVICE_HARDWARE_BETTER_THAN(i) [[UIDevice currentDevice] isCurrentDeviceHardwareBetterThan:i]

#define DEVICE_HAS_RETINA_DISPLAY (fabs([UIScreen mainScreen].scale - 2.0) <= fabs([UIScreen mainScreen].scale - 2.0)*DBL_EPSILON)
#define IS_IOS7_OR_LATER (((double)(DEVICE_IOS_VERSION)-7.0) > -((double)(DEVICE_IOS_VERSION)-7.0)*DBL_EPSILON)
#define NSStringAdd568hIfIphone4inch(str) [NSString stringWithFormat:[UIDevice currentDevice].isIphoneWith4inchDisplay ? @"%@-568h" : @"%@", str]

#pragma mark - 区分不同代的iphone设备 主要区分屏幕大小
/**
 *  是否是iPhone4的大小 320*480
 */
#define IS_IPHONE_4         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  是否是iPhone5的大小 320*568
 */
#define IS_IPHONE_5         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  是否是iPhone6的大小 375*667
 */
#define IS_IPHONE_6         ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  是否是iphone6 plus大小  414*736
 */
#define IS_IPHONE_6_PLUS    ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? \
CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

/**
 *  是否比iphone4大
 */
#define IS_BIGGER_THAN_IPHONE_4 (([[UIScreen mainScreen] bounds].size.height > 480.0f )? YES : NO)


typedef enum
{
    NOT_AVAILABLE,
    
    IPHONE_2G,
    IPHONE_3G,
    IPHONE_3GS,
    IPHONE_4,
    IPHONE_4_CDMA,
    IPHONE_4S,
    IPHONE_5,
    IPHONE_5_CDMA_GSM,
    IPHONE_5C,
    IPHONE_5C_CDMA_GSM,
    IPHONE_5S,
    IPHONE_5S_CDMA_GSM,
    IPHONE_6,
    IPHONE_6_PLUS,
    
    
    IPOD_TOUCH_1G,
    IPOD_TOUCH_2G,
    IPOD_TOUCH_3G,
    IPOD_TOUCH_4G,
    IPOD_TOUCH_5G,
    
    IPAD,
    IPAD_2,
    IPAD_2_WIFI,
    IPAD_2_CDMA,
    IPAD_3,
    IPAD_3G,
    IPAD_3_WIFI,
    IPAD_3_WIFI_CDMA,
    IPAD_4,
    IPAD_4_WIFI,
    IPAD_4_GSM_CDMA,
    
    IPAD_MINI,
    IPAD_MINI_WIFI,
    IPAD_MINI_WIFI_CDMA,
    IPAD_MINI_RETINA_WIFI,
    IPAD_MINI_RETINA_WIFI_CDMA,
    
    IPAD_AIR_WIFI,
    IPAD_AIR_WIFI_GSM,
    IPAD_AIR_WIFI_CDMA,
    
    SIMULATOR
} Hardware;


@interface UIDevice (Hardware)
/** This method retruns the hardware type */

- (NSString*)one_hardwareString;

/** This method returns the Hardware enum depending upon harware string */
- (Hardware)one_hardware;

/** This method returns the readable description of hardware string */
- (NSString*)one_hardwareDescription;

/** This method returs the readble description without identifier (GSM, CDMA, GLOBAL) */
- (NSString *)one_hardwareSimpleDescription;

/** This method returns YES if the current device is better than the hardware passed */
- (BOOL)one_isCurrentDeviceHardwareBetterThan:(Hardware)hardware;

/** This method returns the resolution for still image that can be received
 from back camera of the current device. Resolution returned for image oriented landscape right. **/
- (CGSize)one_backCameraStillImageResolutionInPixels;

/** This method returns YES if the currend device is iPhone and has 4" display **/
- (BOOL)one_isIphoneWith4inchDisplay;

+ (NSString *)macAddress;

//Return the current device CPU frequency
+ (NSUInteger)one_cpuFrequency;
// Return the current device BUS frequency
+ (NSUInteger)one_busFrequency;
//current device RAM size
+ (NSUInteger)one_ramSize;
//Return the current device CPU number
+ (NSUInteger)one_cpuNumber;
//Return the current device total memory

/// 获取iOS系统的版本号
+ (NSString *)one_systemVersion;
/// 判断当前系统是否有摄像头
+ (BOOL)one_hasCamera;
/// 获取手机内存总量, 返回的是字节数
+ (NSUInteger)one_totalMemoryBytes;
/// 获取手机可用内存, 返回的是字节数
+ (NSUInteger)one_freeMemoryBytes;

/// 获取手机硬盘空闲空间, 返回的是字节数
+ (long long)one_freeDiskSpaceBytes;
/// 获取手机硬盘总空间, 返回的是字节数
+ (long long)one_totalDiskSpaceBytes;

// 探测 Wifi 开关是否打开
+ (void)one_isWifiEnabledAsyncBlock:(void (^)(BOOL isEnabled))block;

@end

@interface UIDevice (ONEIdentifier)

/**
 *  平台参数imei
 */
- (NSString *)one_UniqueGlobalDeviceIdentifier;

/**
 *  广告唯一标识advertisingIdentifier
 */
- (NSString *)one_idfaString;

/**
 *  app供应商唯一标识identifierForVendor
 */
- (NSString *)one_idfvString;

@end
