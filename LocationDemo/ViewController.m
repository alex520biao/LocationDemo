//
//  ViewController.m
//  LocationDemo
//
//  Created by alex on 2017/6/15.
//  Copyright © 2017年 alex. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
#import "ONEProgressHUD+Custom.h"


@interface ViewController ()<CLLocationManagerDelegate>

@property(nonatomic,strong)CLLocationManager *locationManager;


@property(nonatomic,strong)MBProgressHUD *hud;


@end

@implementation ViewController

-(CLLocationManager*)locationManager{
    if(!_locationManager){
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate =self;
    }
    return _locationManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    MBProgressHUD *hud = [[MBProgressHUD alloc] init];
    [self.view addSubview:hud];
//    hud.hidden = YES;
    self.hud = hud;
    
    // 距离筛选器(单位: 米)  当距离没有超出设定范围内,就不会有回调
    self.locationManager.distanceFilter = 20;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        self.locationManager.allowsBackgroundLocationUpdates =YES;
    }

    // 期望精确度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    
    //requestWhenInUseAuthorization是 IOS 8.0开始支持,如果兼容低版本,先判断能否响应requestWhenInUseAuthorization方法
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    // 开启定位
    [self.locationManager startUpdatingLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - CLLocationManagerDelegate
/**
 *  当已经获取定位信息后调用,该方法会持续返回位置信息（无论位置是否发生变化）
 *
 *  @param manager   位置管理者
 *  @param locations 数组<位置对象>
 */
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    //CLLocation 位置对象
    CLLocation *location = locations.lastObject;
    //打印坐标(经纬度)
    NSLog(@"%f, %f", location.coordinate.latitude, location.coordinate.longitude);
    //[manager stopUpdatingLocation];停止定位(一次性定位)
    NSLog(@"位置信息:%@", locations);
    
    self.hud.hidden = NO;

    self.hud.mode = MBProgressHUDModeText; //只显示文本
    
    //1,设置背景框的透明度  默认0.8
    self.hud.opacity = 1;
    //2,设置背景框的背景颜色和透明度， 设置背景颜色之后opacity属性的设置将会失效
    self.hud.color = [UIColor redColor];
    self.hud.color = [self.hud.color colorWithAlphaComponent:1];
    //3,设置背景框的圆角值，默认是10
    self.hud.cornerRadius = 20.0;
    //4,设置提示信息 信息颜色，字体
    self.hud.labelColor = [UIColor blueColor];
    self.hud.labelFont = [UIFont systemFontOfSize:13];
    self.hud.labelText = @"Loading...";
    //5,设置提示信息详情 详情颜色，字体
    self.hud.detailsLabelColor = [UIColor blueColor];
    self.hud.detailsLabelFont = [UIFont systemFontOfSize:13];
    self.hud.detailsLabelText = [NSString stringWithFormat:@"位置信息:%@", locations];
    
    
//    [ONEProgressHUD showOnViewFinishTxt:self.view labelText:[NSString stringWithFormat:@"位置信息:%@", locations]];
    [ONEProgressHUD showOnView:self.view
                          mode:ONEProgressHUDModeText
                    customView:nil
                        insets:UIEdgeInsetsZero
                     labelText:[NSString stringWithFormat:@"位置信息:%@", locations]
                     hideDelay:50];
}

/*
 *  locationManager:didUpdateHeading:
 *
 *  Discussion:
 *    Invoked when a new heading is available.
 */
- (void)locationManager:(CLLocationManager *)manager
       didUpdateHeading:(CLHeading *)newHeading{
    NSLog(@"newHeading:%f", newHeading.trueHeading);

}

/*
 *  locationManager:didFailWithError:
 *
 *  Discussion:
 *    Invoked when an error has occurred. Error types are defined in "CLError.h".
 */
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"定位失败:%@",[error localizedFailureReason]);
}


/*
 *  locationManager:didChangeAuthorizationStatus:
 *
 *  Discussion:
 *    Invoked when the authorization status changes for this application.
 */
- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    switch (status) {
            
        case kCLAuthorizationStatusNotDetermined:{
            NSLog(@"1.用户还未决定");
            break;
        }
        case kCLAuthorizationStatusRestricted:{
            NSLog(@"2.访问受限(苹果预留选项,暂时没用)");
            break;
        }
            // 定位关闭时 and 对此APP授权为never时调用
        case kCLAuthorizationStatusDenied:{
            // 定位是否可用（是否支持定位或者定位是否开启）
            if([CLLocationManager locationServicesEnabled]){
                NSLog(@"3.定位服务是开启状态，需要手动授权，即将跳转设置界面");
                // 在此处, 应该提醒用户给此应用授权, 并跳转到"设置"界面让用户进行授权在iOS8.0之后跳转到"设置"界面代码
                NSURL *settingURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
                
                if([[UIApplication sharedApplication] canOpenURL:settingURL]){
                    
                    //  [[UIApplication sharedApplication] openURL:settingURL]; // 方法过期
                    
                    [[UIApplication sharedApplication]openURL:settingURL options:nil completionHandler:^(BOOL success) {
                        NSLog(@"已经成功跳转到设置界面");
                    }];
                }
                else{
                    NSLog(@"定位关闭，不可用");
                }
                break;
            }
        case kCLAuthorizationStatusAuthorizedAlways:{
            NSLog(@"4.获取前后台定位授权");
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            NSLog(@"5.获得前台定位授权");
            break;
        }
        default:
            break;
        }
    }
}


@end
