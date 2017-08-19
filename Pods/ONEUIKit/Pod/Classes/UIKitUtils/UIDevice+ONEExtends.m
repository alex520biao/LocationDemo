//
//  UIDevice+ONEExtends.m
//  Pods
//
//  Created by didi on 16/10/10.
//
//

#import "UIDevice+ONEExtends.h"
#include <sys/types.h>
#include <sys/sysctl.h>

#import <sys/socket.h>
#import <sys/param.h>
#import <sys/mount.h>
#import <sys/stat.h>
#import <sys/utsname.h>
#import <net/if.h>
#import <net/if_dl.h>
#import <mach/mach.h>
#import <mach/mach_host.h>
#import <mach/processor_info.h>

// isWifiEnabled
#import <ifaddrs.h>
#import <net/if.h>

#import <ONEFoundation/ONEFoundation.h>
#import <UICKeyChainStore/UICKeyChainStore.h>
#import <OpenUDID/OpenUDID.h>
#import <AdSupport/AdSupport.h>

#ifndef IOS6_OR_LATER
#define IOS6_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

#define kKeyChainUDID   @"keyChainUDID"

@implementation UIDevice (AutoSize)

+ (UIDeviceModelType)one_deviceModel {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && IS_IPHONE_4) {
        return UIDeviceModelPhone;
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && IS_IPHONE_5) {
        return UIDeviceModelPhone5;
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && IS_IPHONE_6) {
        return UIDeviceModelPhone6;
    } else if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone && IS_IPHONE_6_PLUS) {
        return UIDeviceModelPhone6p;
    }
    return UIDeviceModelUnknown;
}

+ (CGRect)one_autoResizeToFrame:(CGRect)rect {
    if ([UIDevice one_deviceModel] == UIDeviceModelPhone6) {
        rect.size.width = rect.size.width * 1.2f;
        rect.size.height = rect.size.height * 1.2f;
    } else if ([UIDevice one_deviceModel] == UIDeviceModelPhone6p) {
        rect.size.width = rect.size.width * 1.3f;
        rect.size.height = rect.size.height * 1.3f;
    }
    return rect;
}

//+ (NSString *)imageType {
//    /*
//     image type equal 1,2,3,4
//     1 present 640 * 960  device 4,4s
//     2 present 640 * 1136 device 5,5s
//     3 present 750 * 1334 device 6,
//     4 present 1242 * 2208 device 6p
//     default is 2
//     */
//    NSString *imageType = @"2";
//    if ([UIDevice deviceModel] != UIDeviceModelUnknown) {
//        imageType = [NSString stringWithFormat:@"%ld",(long)[UIDevice deviceModel]];
//    }
//    return imageType;
//}

+ (CGFloat)one_autoResizeHeight:(CGFloat)height {
    if ([UIDevice one_deviceModel] == UIDeviceModelPhone6) {
        return height * 1.2f;
    } else if ([UIDevice one_deviceModel] == UIDeviceModelPhone6p) {
        return height * 1.3f;
    }
    return height;
}

+ (CGFloat)one_autoResizeWidth:(CGFloat)width {
    if ([UIDevice one_deviceModel] == UIDeviceModelPhone6) {
        return width * 1.2f;
    } else if ([UIDevice one_deviceModel] == UIDeviceModelPhone6p) {
        return width * 1.3f;
    }
    return width;
}

@end

@implementation UIDevice (Hardware)
- (NSString*)one_hardwareString {
    int name[] = {CTL_HW,HW_MACHINE};
    size_t size = 100;
    sysctl(name, 2, NULL, &size, NULL, 0); // getting size of answer
    char *hw_machine = malloc(size);
    
    sysctl(name, 2, hw_machine, &size, NULL, 0);
    NSString *hardware = [NSString stringWithUTF8String:hw_machine];
    free(hw_machine);
    return hardware;
}

/* This is another way of gtting the system info
 * For this you have to #import <sys/utsname.h>
 */

/*
 NSString* machineName
 {
 struct utsname systemInfo;
 uname(&systemInfo);
 return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
 }
 */

- (Hardware)one_hardware {
    NSString *hardware = [self one_hardwareString];
    if ([hardware isEqualToString:@"iPhone1,1"])    return IPHONE_2G;
    if ([hardware isEqualToString:@"iPhone1,2"])    return IPHONE_3G;
    if ([hardware isEqualToString:@"iPhone2,1"])    return IPHONE_3GS;
    if ([hardware isEqualToString:@"iPhone3,1"])    return IPHONE_4;
    if ([hardware isEqualToString:@"iPhone3,2"])    return IPHONE_4;
    if ([hardware isEqualToString:@"iPhone3,3"])    return IPHONE_4_CDMA;
    if ([hardware isEqualToString:@"iPhone4,1"])    return IPHONE_4S;
    if ([hardware isEqualToString:@"iPhone5,1"])    return IPHONE_5;
    if ([hardware isEqualToString:@"iPhone5,2"])    return IPHONE_5_CDMA_GSM;
    if ([hardware isEqualToString:@"iPhone5,3"])    return IPHONE_5C;
    if ([hardware isEqualToString:@"iPhone5,4"])    return IPHONE_5C_CDMA_GSM;
    if ([hardware isEqualToString:@"iPhone6,1"])    return IPHONE_5S;
    if ([hardware isEqualToString:@"iPhone6,2"])    return IPHONE_5S_CDMA_GSM;
    
    if ([hardware isEqualToString:@"iPhone7,1"])    return IPHONE_6_PLUS;
    if ([hardware isEqualToString:@"iPhone7,2"])    return IPHONE_6;
    
    if ([hardware isEqualToString:@"iPod1,1"])      return IPOD_TOUCH_1G;
    if ([hardware isEqualToString:@"iPod2,1"])      return IPOD_TOUCH_2G;
    if ([hardware isEqualToString:@"iPod3,1"])      return IPOD_TOUCH_3G;
    if ([hardware isEqualToString:@"iPod4,1"])      return IPOD_TOUCH_4G;
    if ([hardware isEqualToString:@"iPod5,1"])      return IPOD_TOUCH_5G;
    
    if ([hardware isEqualToString:@"iPad1,1"])      return IPAD;
    if ([hardware isEqualToString:@"iPad1,2"])      return IPAD_3G;
    if ([hardware isEqualToString:@"iPad2,1"])      return IPAD_2_WIFI;
    if ([hardware isEqualToString:@"iPad2,2"])      return IPAD_2;
    if ([hardware isEqualToString:@"iPad2,3"])      return IPAD_2_CDMA;
    if ([hardware isEqualToString:@"iPad2,4"])      return IPAD_2;
    if ([hardware isEqualToString:@"iPad2,5"])      return IPAD_MINI_WIFI;
    if ([hardware isEqualToString:@"iPad2,6"])      return IPAD_MINI;
    if ([hardware isEqualToString:@"iPad2,7"])      return IPAD_MINI_WIFI_CDMA;
    if ([hardware isEqualToString:@"iPad3,1"])      return IPAD_3_WIFI;
    if ([hardware isEqualToString:@"iPad3,2"])      return IPAD_3_WIFI_CDMA;
    if ([hardware isEqualToString:@"iPad3,3"])      return IPAD_3;
    if ([hardware isEqualToString:@"iPad3,4"])      return IPAD_4_WIFI;
    if ([hardware isEqualToString:@"iPad3,5"])      return IPAD_4;
    if ([hardware isEqualToString:@"iPad3,6"])      return IPAD_4_GSM_CDMA;
    if ([hardware isEqualToString:@"iPad4,1"])      return IPAD_AIR_WIFI;
    if ([hardware isEqualToString:@"iPad4,2"])      return IPAD_AIR_WIFI_GSM;
    if ([hardware isEqualToString:@"iPad4,3"])      return IPAD_AIR_WIFI_CDMA;
    if ([hardware isEqualToString:@"iPad4,4"])      return IPAD_MINI_RETINA_WIFI;
    if ([hardware isEqualToString:@"iPad4,5"])      return IPAD_MINI_RETINA_WIFI_CDMA;
    
    
    if ([hardware isEqualToString:@"i386"])         return SIMULATOR;
    if ([hardware isEqualToString:@"x86_64"])       return SIMULATOR;
    return NOT_AVAILABLE;
}

- (NSString*)one_hardwareDescription {
    NSString *hardware = [self one_hardwareString];
    if ([hardware isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([hardware isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([hardware isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([hardware isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([hardware isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM Rev. A)";
    if ([hardware isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([hardware isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([hardware isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([hardware isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (Global)";
    if ([hardware isEqualToString:@"iPhone5,3"])    return @"iPhone 5C (GSM)";
    if ([hardware isEqualToString:@"iPhone5,4"])    return @"iPhone 5C (Global)";
    if ([hardware isEqualToString:@"iPhone6,1"])    return @"iPhone 5S (GSM)";
    if ([hardware isEqualToString:@"iPhone6,2"])    return @"iPhone 5S (Global)";
    
    if ([hardware isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    if ([hardware isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([hardware isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([hardware isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([hardware isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([hardware isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([hardware isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([hardware isEqualToString:@"iPad1,1"])      return @"iPad (WiFi)";
    if ([hardware isEqualToString:@"iPad1,2"])      return @"iPad 3G";
    if ([hardware isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([hardware isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([hardware isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([hardware isEqualToString:@"iPad2,4"])      return @"iPad 2 (WiFi Rev. A)";
    if ([hardware isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([hardware isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([hardware isEqualToString:@"iPad2,7"])      return @"iPad Mini (CDMA)";
    if ([hardware isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([hardware isEqualToString:@"iPad3,2"])      return @"iPad 3 (CDMA)";
    if ([hardware isEqualToString:@"iPad3,3"])      return @"iPad 3 (Global)";
    if ([hardware isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([hardware isEqualToString:@"iPad3,5"])      return @"iPad 4 (CDMA)";
    if ([hardware isEqualToString:@"iPad3,6"])      return @"iPad 4 (Global)";
    if ([hardware isEqualToString:@"iPad4,1"])      return @"iPad Air (WiFi)";
    if ([hardware isEqualToString:@"iPad4,2"])      return @"iPad Air (WiFi+GSM)";
    if ([hardware isEqualToString:@"iPad4,3"])      return @"iPad Air (WiFi+CDMA)";
    if ([hardware isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina (WiFi)";
    if ([hardware isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina (WiFi+CDMA)";
    if ([hardware isEqualToString:@"i386"])         return @"Simulator";
    if ([hardware isEqualToString:@"x86_64"])       return @"Simulator";
    
    NSLog(@"This is a device which is not listed in this category. Please visit https://github.com/inderkumarrathore/UIDevice-Hardware and add a comment there.");
    NSLog(@"Your device hardware string is: %@", hardware);
    if ([hardware hasPrefix:@"iPhone"]) return @"iPhone";
    if ([hardware hasPrefix:@"iPod"]) return @"iPod";
    if ([hardware hasPrefix:@"iPad"]) return @"iPad";
    return nil;
}

- (NSString*)one_hardwareSimpleDescription
{
    NSString *hardware = [self one_hardwareString];
    if ([hardware isEqualToString:@"iPhone1,1"])    return @"iPhone 2G";
    if ([hardware isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([hardware isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([hardware isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    if ([hardware isEqualToString:@"iPhone3,2"])    return @"iPhone 4";
    if ([hardware isEqualToString:@"iPhone3,3"])    return @"iPhone 4";
    if ([hardware isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([hardware isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    if ([hardware isEqualToString:@"iPhone5,2"])    return @"iPhone 5";
    if ([hardware isEqualToString:@"iPhone5,3"])    return @"iPhone 5C";
    if ([hardware isEqualToString:@"iPhone5,4"])    return @"iPhone 5C";
    if ([hardware isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    if ([hardware isEqualToString:@"iPhone6,2"])    return @"iPhone 5S";
    
    if ([hardware isEqualToString:@"iPod1,1"])      return @"iPod Touch (1 Gen)";
    if ([hardware isEqualToString:@"iPod2,1"])      return @"iPod Touch (2 Gen)";
    if ([hardware isEqualToString:@"iPod3,1"])      return @"iPod Touch (3 Gen)";
    if ([hardware isEqualToString:@"iPod4,1"])      return @"iPod Touch (4 Gen)";
    if ([hardware isEqualToString:@"iPod5,1"])      return @"iPod Touch (5 Gen)";
    
    if ([hardware isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([hardware isEqualToString:@"iPad1,2"])      return @"iPad";
    if ([hardware isEqualToString:@"iPad2,1"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,2"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,3"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,4"])      return @"iPad 2";
    if ([hardware isEqualToString:@"iPad2,5"])      return @"iPad Mini";
    if ([hardware isEqualToString:@"iPad2,6"])      return @"iPad Mini";
    if ([hardware isEqualToString:@"iPad2,7"])      return @"iPad Mini";
    if ([hardware isEqualToString:@"iPad3,1"])      return @"iPad 3";
    if ([hardware isEqualToString:@"iPad3,2"])      return @"iPad 3";
    if ([hardware isEqualToString:@"iPad3,3"])      return @"iPad 3";
    if ([hardware isEqualToString:@"iPad3,4"])      return @"iPad 4";
    if ([hardware isEqualToString:@"iPad3,5"])      return @"iPad 4";
    if ([hardware isEqualToString:@"iPad3,6"])      return @"iPad 4";
    if ([hardware isEqualToString:@"iPad4,1"])      return @"iPad Air";
    if ([hardware isEqualToString:@"iPad4,2"])      return @"iPad Air";
    if ([hardware isEqualToString:@"iPad4,3"])      return @"iPad Air";
    if ([hardware isEqualToString:@"iPad4,4"])      return @"iPad Mini Retina";
    if ([hardware isEqualToString:@"iPad4,5"])      return @"iPad Mini Retina";
    
    if ([hardware isEqualToString:@"i386"])         return @"Simulator";
    if ([hardware isEqualToString:@"x86_64"])       return @"Simulator";
    
    NSLog(@"This is a device which is not listed in this category. Please visit https://github.com/inderkumarrathore/UIDevice-Hardware and add a comment there.");
    NSLog(@"Your device hardware string is: %@", hardware);
    
    if ([hardware hasPrefix:@"iPhone"]) return @"iPhone";
    if ([hardware hasPrefix:@"iPod"]) return @"iPod";
    if ([hardware hasPrefix:@"iPad"]) return @"iPad";
    
    return nil;
}


- (float)hardwareNumber:(Hardware)hardware {
    switch (hardware) {
            case IPHONE_2G: return 1.1f;
            case IPHONE_3G: return 1.2f;
            case IPHONE_3GS: return 2.1f;
            case IPHONE_4:    return 3.1f;
            case IPHONE_4_CDMA:    return 3.3f;
            case IPHONE_4S:    return 4.1f;
            case IPHONE_5:    return 5.1f;
            case IPHONE_5_CDMA_GSM:    return 5.2f;
            case IPHONE_5C:    return 5.3f;
            case IPHONE_5C_CDMA_GSM:    return 5.4f;
            case IPHONE_5S:    return 6.1f;
            case IPHONE_5S_CDMA_GSM:    return 6.2f;
            
            case IPHONE_6:         return 7.2f;
            case IPHONE_6_PLUS:    return 7.1f;
            
            case IPOD_TOUCH_1G:    return 1.1f;
            case IPOD_TOUCH_2G:    return 2.1f;
            case IPOD_TOUCH_3G:    return 3.1f;
            case IPOD_TOUCH_4G:    return 4.1f;
            case IPOD_TOUCH_5G:    return 5.1f;
            
            case IPAD:    return 1.1f;
            case IPAD_3G:    return 1.2f;
            case IPAD_2_WIFI:    return 2.1f;
            case IPAD_2:    return 2.2f;
            case IPAD_2_CDMA:    return 2.3f;
            case IPAD_MINI_WIFI:    return 2.5f;
            case IPAD_MINI:    return 2.6f;
            case IPAD_MINI_WIFI_CDMA:    return 2.7f;
            case IPAD_3_WIFI:    return 3.1f;
            case IPAD_3_WIFI_CDMA:    return 3.2f;
            case IPAD_3:    return 3.3f;
            case IPAD_4_WIFI:    return 3.4f;
            case IPAD_4:    return 3.5f;
            case IPAD_4_GSM_CDMA:    return 3.6f;
            case IPAD_AIR_WIFI:    return 4.1f;
            case IPAD_AIR_WIFI_GSM:    return 4.2f;
            case IPAD_AIR_WIFI_CDMA:    return 4.3f;
            case IPAD_MINI_RETINA_WIFI:    return 4.4f;
            case IPAD_MINI_RETINA_WIFI_CDMA:    return 4.5f;
            
            case SIMULATOR:    return 100.0f;
            case NOT_AVAILABLE:    return 200.0f;
    }
    return 200.0f; //Device is not available
}

- (BOOL)one_isCurrentDeviceHardwareBetterThan:(Hardware)hardware {
    float otherHardware = [self hardwareNumber:hardware];
    float currentHardware = [self hardwareNumber:[self one_hardware]];
    return currentHardware >= otherHardware;
}

- (CGSize)one_backCameraStillImageResolutionInPixels
{
    switch ([self one_hardware]) {
            case IPHONE_2G:
            case IPHONE_3G:
            return CGSizeMake(1600, 1200);
            break;
            case IPHONE_3GS:
            return CGSizeMake(2048, 1536);
            break;
            case IPHONE_4:
            case IPHONE_4_CDMA:
            case IPAD_3_WIFI:
            case IPAD_3_WIFI_CDMA:
            case IPAD_3:
            case IPAD_4_WIFI:
            case IPAD_4:
            case IPAD_4_GSM_CDMA:
            return CGSizeMake(2592, 1936);
            break;
            case IPHONE_4S:
            case IPHONE_5:
            case IPHONE_5_CDMA_GSM:
            case IPHONE_5C:
            case IPHONE_5C_CDMA_GSM:
            return CGSizeMake(3264, 2448);
            break;
            
            case IPOD_TOUCH_4G:
            return CGSizeMake(960, 720);
            break;
            case IPOD_TOUCH_5G:
            return CGSizeMake(2440, 1605);
            break;
            
            case IPAD_2_WIFI:
            case IPAD_2:
            case IPAD_2_CDMA:
            return CGSizeMake(872, 720);
            break;
            
            case IPAD_MINI_WIFI:
            case IPAD_MINI:
            case IPAD_MINI_WIFI_CDMA:
            return CGSizeMake(1820, 1304);
            break;
        default:
            NSLog(@"We have no resolution for your device's camera listed in this category. Please, make photo with back camera of your device, get its resolution in pixels (via Preview Cmd+I for example) and add a comment to this repository on GitHub.com in format Device = Hpx x Wpx.");
            NSLog(@"Your device is: %@", [self one_hardwareDescription]);
            break;
    }
    return CGSizeZero;
}

- (BOOL)one_isIphoneWith4inchDisplay
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPhone) {
        double height = [[UIScreen mainScreen] bounds].size.height;
        if (fabs(height-568.0f) < DBL_EPSILON) {
            return YES;
        }
    }
    return NO;
}


+ (NSString *)macAddress {
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;

    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;

    if((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }

    if(sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }

    if((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. Rrror!\n");
        return NULL;
    }

    if(sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        free(buf);
        printf("Error: sysctl, take 2");
        return NULL;
    }

    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);

    return outstring;
}

+ (NSString *)one_systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}
+ (BOOL)one_hasCamera
{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}
#pragma mark - sysctl utils

+ (NSUInteger)getSysInfo:(uint)typeSpecifier
{
    size_t size = sizeof(int);
    int result;
    int mib[2] = {CTL_HW, typeSpecifier};
    sysctl(mib, 2, &result, &size, NULL, 0);
    return (NSUInteger)result;
}

#pragma mark - memory information
+ (NSUInteger)one_cpuFrequency {
    return [self getSysInfo:HW_CPU_FREQ];
}

+ (NSUInteger)one_busFrequency {
    return [self getSysInfo:HW_BUS_FREQ];
}

+ (NSUInteger)one_ramSize {
    return [self getSysInfo:HW_MEMSIZE];
}

+ (NSUInteger)one_cpuNumber {
    return [self getSysInfo:HW_NCPU];
}


+ (NSUInteger)one_totalMemoryBytes
{
    return [self getSysInfo:HW_PHYSMEM];
}

+ (NSUInteger)one_freeMemoryBytes
{
    mach_port_t host_port = mach_host_self();
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    vm_size_t pagesize;
    vm_statistics_data_t vm_stat;
    
    host_page_size(host_port, &pagesize);
    if (host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size) != KERN_SUCCESS) {
        return 0;
    }
    unsigned long mem_free = vm_stat.free_count * pagesize;
    return mem_free;
}

#pragma mark - disk information

+ (long long)one_freeDiskSpaceBytes
{
    struct statfs buf;
    long long freespace;
    freespace = 0;
    if ( statfs("/private/var", &buf) >= 0 ) {
        freespace = (long long)buf.f_bsize * buf.f_bfree;
    }
    return freespace;
}

+ (long long)one_totalDiskSpaceBytes
{
    struct statfs buf;
    long long totalspace;
    totalspace = 0;
    if ( statfs("/private/var", &buf) >= 0 ) {
        totalspace = (long long)buf.f_bsize * buf.f_blocks;
    }
    return totalspace;
}

#pragma mark -

+ (BOOL)isWiFiEnabled {
    NSCountedSet * cset = [NSCountedSet new];
    
    struct ifaddrs *interfaces;
    
    if( ! getifaddrs(&interfaces) ) {
        for( struct ifaddrs *interface = interfaces; interface; interface = interface->ifa_next) {
            if ( (interface->ifa_flags & IFF_UP) == IFF_UP ) {
                if (interfaces->ifa_name) {
                    NSString *ifaName = [NSString stringWithUTF8String:interface->ifa_name];
                    if (ifaName) {
                        [cset addObject:ifaName];
                    }
                }
            }
        }
        freeifaddrs(interfaces);
    }
    
    BOOL ret = [cset countForObject:@"awdl0"] > 1 ? YES : NO;
    return ret;
}

+ (void)one_isWifiEnabledAsyncBlock:(void (^)(BOOL isEnabled))block {
    if (!block) {
        return;
    }
    
    if ([NSThread isMainThread] == NO) {
        block([UIDevice isWiFiEnabled]);
    }
    else {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            block([UIDevice isWiFiEnabled]);
        });
    }
}

@end

@implementation UIDevice (ONEIdentifier)


static NSString * globalDeviceIdentifier;

- (NSString *)one_UniqueGlobalDeviceIdentifier {
    if ([ONEValidJudge isValidString:globalDeviceIdentifier]) {
        return globalDeviceIdentifier;
    }
    NSString * serviceName = [[NSBundle mainBundle] bundleIdentifier];
    
    //  1、第一步：从keychain里读取udid，如果没有，则从如下代码中执行。
    globalDeviceIdentifier = [[NSUserDefaults standardUserDefaults] stringForKey:kKeyChainUDID];
    if (![ONEValidJudge isValidString:globalDeviceIdentifier]) {
        globalDeviceIdentifier = [UICKeyChainStore stringForKey:kKeyChainUDID service:serviceName];
    }
    
    //  2、对于小于6.0的系统，优先采用mac地址。
    if (globalDeviceIdentifier == nil) {
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 6.0) {
            globalDeviceIdentifier = [self one_uniqueGlobalDeviceIdentifier];
        } else {
            //  4、如果此时还获取失败， [[[UIDevice currentDevice] identifierForVendor] UUIDString];。
            if (globalDeviceIdentifier == nil) {
                globalDeviceIdentifier = [[self one_idfvString] one_MD5];
            }
        }
        
        //  5、如果获取失败，则采用openudid
        if (globalDeviceIdentifier == nil) {
            globalDeviceIdentifier = [OpenUDID value];
        }
        
        //  6、生成成功后，保存在keychain里。
        if ([ONEValidJudge isValidString:globalDeviceIdentifier]) {
            [UICKeyChainStore setString:globalDeviceIdentifier forKey:kKeyChainUDID service:serviceName];
            [[NSUserDefaults standardUserDefaults] setObject:globalDeviceIdentifier forKey:kKeyChainUDID];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    // 7、黑名单上的MD5值，需要重新生产一个globalDeviceIdentifier
    if (![self isValidWithMD5String:globalDeviceIdentifier]) {
        globalDeviceIdentifier = [self MD5OfNewUUIDString];
        
        [UICKeyChainStore setString:globalDeviceIdentifier forKey:kKeyChainUDID service:serviceName];
        
        [[NSUserDefaults standardUserDefaults] setObject:globalDeviceIdentifier forKey:kKeyChainUDID];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return globalDeviceIdentifier;
}

- (NSString *)one_idfaString {
    if (!IOS6_OR_LATER) {
        return nil;
    }
    
    NSBundle *adSupportBundle = [NSBundle bundleWithPath:@"/System/Library/Frameworks/AdSupport.framework"];
    [adSupportBundle load];
    
    if (adSupportBundle == nil) {
        return nil;
    }
    else {
        Class asIdentifierMClass = NSClassFromString(@"ASIdentifierManager");
        
        if (asIdentifierMClass == nil) {
            return nil;
        }
        else {
            //for no arc
            ASIdentifierManager *asIM = [[asIdentifierMClass alloc] init];
            
            if (asIM == nil) {
                return nil;
            }
            else {
                if (asIM.advertisingTrackingEnabled) {
                    return [asIM.advertisingIdentifier UUIDString];
                }
                else {
                    return [asIM.advertisingIdentifier UUIDString];
                }
            }
        }
    }
}

- (NSString *)one_idfvString {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        return [[UIDevice currentDevice].identifierForVendor UUIDString];
    }
    
    return nil;
}

#pragma mark - Private Method

/**
 *  判断重复的MD5
 *
 *  @param MD5String 需要判断的MD5值
 *
 *  @return NO，MD5String是不合法的，即冲突的；YES，MD5String是合法的
 */
- (BOOL)isValidWithMD5String:(NSString *)MD5String {
    // 黑名单
    NSArray *illegalMD5s = @[
                             @"9f89c84a559f573636a47ff8daed0d33",
                             @"0f607264fc6318a92b9e13c65db7cd3c"
                             ];
    
    if ([illegalMD5s containsObject:MD5String]) {
        return NO;
    }
    else {
        return YES;
    }
}

/**
 *  重新生成一个UUID的MD5
 *
 *  @return the MD5 of UUID string
 */
- (NSString *)MD5OfNewUUIDString {
    CFUUIDRef UUIDRef = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef UUIDStringRef = CFUUIDCreateString(kCFAllocatorDefault, UUIDRef);
    
    NSString *uuidString = [[NSString stringWithFormat:@"%@", UUIDStringRef] one_MD5];
    
    CFRelease(UUIDRef);
    CFRelease(UUIDStringRef);
    
    return uuidString;
}

#pragma mark - Deprecated Methods

- (NSString *)macaddress {
    
    int                 mib[6];
    size_t              len;
    char                *buf;
    unsigned char       *ptr;
    struct if_msghdr    *ifm;
    struct sockaddr_dl  *sdl;
    
    mib[0] = CTL_NET;
    mib[1] = AF_ROUTE;
    mib[2] = 0;
    mib[3] = AF_LINK;
    mib[4] = NET_RT_IFLIST;
    
    if ((mib[5] = if_nametoindex("en0")) == 0) {
        printf("Error: if_nametoindex error\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, NULL, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 1\n");
        return NULL;
    }
    
    if ((buf = malloc(len)) == NULL) {
        printf("Could not allocate memory. error!\n");
        return NULL;
    }
    
    if (sysctl(mib, 6, buf, &len, NULL, 0) < 0) {
        printf("Error: sysctl, take 2");
        free(buf);
        return NULL;
    }
    
    ifm = (struct if_msghdr *)buf;
    sdl = (struct sockaddr_dl *)(ifm + 1);
    ptr = (unsigned char *)LLADDR(sdl);
    NSString *outstring = [NSString stringWithFormat:@"%02X:%02X:%02X:%02X:%02X:%02X",
                           *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5)];
    free(buf);
    
    return outstring;
}

- (NSString *)one_uniqueDeviceIdentifier {
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *stringToHash = [NSString stringWithFormat:@"%@%@",macaddress,bundleIdentifier];
    NSString *uniqueIdentifier = [stringToHash one_MD5];
    
    return uniqueIdentifier;
}

- (NSString *)one_uniqueGlobalDeviceIdentifier {
    NSString *macaddress = [[UIDevice currentDevice] macaddress];
    NSString *uniqueIdentifier = [macaddress one_MD5];
    
    return uniqueIdentifier;
}

@end

