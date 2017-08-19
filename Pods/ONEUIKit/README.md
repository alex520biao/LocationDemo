# ONEUIKit

ONEUIKit 是滴滴内部定制的一组通用的UI组件库。目前包括以下组件：

* [Theme](#Theme)
* [UIKitUtils](#UIKitUtils)
* [WebP](#WebP)
* [HUD](#HUD)
* [Alert](#Alert)
* [Bubble](#Bubble)
* [Popup](#Popup)
* [Helper](#helper)

## 安装

```ruby
pod "ONEUIKit"
```

或者只引入一个subspec

```ruby
pod "ONEUIKit/WebP"
```

## 使用方法、公开类、API说明

#### Theme

<div id = "Theme"></div>

`UIView+ONETheme.h`一键从json配置主题

```json
{
  "ONESideMenuViewController.view": [
    {
      "backgroundColor": "#262B2E"
    }
  ],
  "ONESideMenuHeaderView": [
    {
      "userNameLabel": {
        "textColor": "#FFFFFF"
      }
    }
  ],
  "__common__ONEHightColor": [
    {
      "styleType": 0,
      "color": "#ff8903"
    },{
      "styleType": 1,
      "color": "#00B0FF"
    }
  ]
}
```
json中第一层的key对应某个控件的标示，value是一个数组，可定义不同的styleType,通过`oneTheme_setStyle:`切换。对于有子view的情况，可以嵌套配置。

```
[self.view oneTheme_setThemeWithId:@"ONESideMenuViewController.view" inBundle:@"ONEMainMenuModuleSub"];
```

```
[self oneTheme_setThemeWithId@"ONESideMenuHeaderView"]
[self oneTheme_setStyle:1]
```

```
ONELocalizedTheme *theme = [ONELocalizedTheme themeWithIdentifier:@"__common__ONEHightColor" inBundle:@"ONEMainMenuModuleSub"];
UIColor *highLightColor = [theme colorForKey:@"color"];
```

`ONEUIKitTheme.h` App 主题、颜色、样式相关工具类

##### 使用方法

```objc
// 创建颜色
[ONEUIKitTheme colorWithHexString:@"000000"];
// 获取bundle中图片
[ONEUIKitTheme imageNamed:@"imagename" inBundle:@"bundlename"];
```

##### API说明

```objc
// 通过此文件获得各种滴滴颜色值
#pragma mark 颜色
/**
 从 hex 字符串创建颜色，错误时返回 nil。
 @param string 支持格式 "#rrggbb" 或 "rrggbb" 不区分大小写。
 */
+ (UIColor *)colorWithHexString:(NSString *)string;

/**
 从 hex 字符串创建颜色，错误时返回 nil。
 @param string 支持格式 "#rrggbb" 或 "rrggbb" 不区分大小写。
 @param alpha 透明度，0～1
 */
+ (UIColor *)colorWithHexString:(NSString *)string alpha:(CGFloat)alpha;


#pragma mark 图片

/**
 从 ONEUIKit 的 bundle 中取图片，失败返回 nil。
 @param name 图片名
 @param bundle ONEUIKit 中子控件的 bundle 名。传入 nil 则优先搜索 ONEUIKit.bundle
 */
+ (UIImage *)imageNamed:(NSString *)name inBundle:(NSString *)bundle;


#pragma mark 按钮

/**
 创建一个预定义样式的按钮
 */
+ (UIButton *)buttonWithStyle:(ONEButtonStyle)style size:(ONEButtonSize)size;

/**
 设置按钮样式 (包括背景图片和文本颜色)
 */
+ (void)setButton:(UIButton *)button withStyle:(ONEButtonStyle)style;

/**
 设置按钮的大小 (包括高度和文本字体大小)
 */
+ (void)setButton:(UIButton *)button withSize:(ONEButtonSize)size;

/**
 预定义按钮文字颜色
 */
+ (UIColor *)buttonTextColorWithStyle:(ONEButtonStyle)style state:(UIControlState)state;

/**
 预定义按钮背景图片
 */
+ (UIImage *)buttomImageWithStyle:(ONEButtonStyle)style state:(UIControlState)state;
```

#### UIKitUtils

<div id = "UIKitUtils"></div>

`ONEUIKit/UIKitUtils`提供了ONEUIKit的扩展方法，使用UIKitUtils可更便捷的开发。

公开类如下

```objc
// UIKit的扩展方法
#import <ONEUIKit/UIButton+ONEExtends.h>
#import <ONEUIKit/UIColor+ONEExtends.h>
#import <ONEUIKit/UIControl+ONEExtends.h>
#import <ONEUIKit/UIDevice+ONEExtends.h>
#import <ONEUIKit/UIImage+ONEExtends.h>
#import <ONEUIKit/UILabel+ONEExtends.h>
#import <ONEUIKit/UINavigationController+ONEExtends.h>
#import <ONEUIKit/UIScrollView+ONEExtends.h>
#import <ONEUIKit/UIView+ONEExtends.h>
#import <ONEUIKit/UIViewController+ONEExtends.h>
```

#### WebP

<div id = "WebP"></div>

webp格式图片比png图片更小。为此，当图片很多时，采用webp能有效减少app体积。但使用webp格式图片需要引入google的`libwebp`库，`ONEUIKit/WebP`对libwebp进行了封装。

##### PNG转WebP方法

- 使用官方提供命令行工具 cwebp：

```bash
# 安装
brew install webp
# 转换 webp
cwebp -q 75 bts-home-nocity@3x.png -o bts-home-nocity@3x.webp
```

- 智图 - 在线网页版 http://zhitu.isux.us/


- 使用脚本批量处理：[脚本链接，供参考](https://git.xiaojukeji.com/snippets/104)

##### 使用方法

```objc
#import <ONEUIKit/UIImage+ONEWebP.h>

// 直接使用，与 imageWithName: 使用方法相同，内部会自行判断选择合适的分辨率图片，并且对图片缓存（无差别全部使用缓存将会降低缓存命中率、拖慢 App 性能，一次性使用图片建议使用 one_imageWithContentsOfWebPName 方法加载）
UIImage *image = [UIImage one_imageWithWebPName:@"bts-home-nocity"];

// 也可手动指定使用 @2x
UIImage *2xImage = [UIImage one_imageWithWebPName:@"bts-home-nocity@2x"];

// 读取指定 bundle 内图片
NSBundle *bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle] pathForResource:IDCardBundleName ofType:IDCardBundleType]];
UIImage *image = [UIImage one_imageWithWebPName:@"bts-home-nocity" bundle:bundle];

// 若图片为一次性使用，无需缓存时，使用以下方法：
UIImage *image = [UIImage one_imageWithContentsOfWebPName:@"bts-home-nocity"];
```

##### API说明

```objc

#pragma mark - Cached

+ (UIImage*)one_imageWithWebPName:(NSString*)name;
+ (UIImage*)one_imageWithWebPName:(NSString*)name bundle:(NSBundle*)bundle;

#pragma mark - Direct access

+ (UIImage*)one_imageWithContentsOfWebPName:(NSString*)name; /**< not cache */
+ (UIImage*)one_imageWithContentsOfWebPName:(NSString*)name bundle:(NSBundle*)bundle; /**< not cache */

+ (UIImage*)one_imageWithWebPData:(NSData*)data scale:(CGFloat)scale; /**< not cache */

#pragma mark - Util

+ (NSInteger)one_scaleWithImageName:(NSString*)name;
+ (NSString*)one_imagePathWithName:(NSString*)name bundle:(NSBundle*)bundle type:(NSString*)type;
```

### HUD    

<div id = "HUD"></div>

HUD是一款toast组件，目前的实现基于第三方开源库`MPProgressHUD`修改，对外公开的类`ONEProgressHUD+Custom.h`，请不要直接使用`ONEProgressHUD.h`

##### 使用方法

```objc
#import <ONEUIKit/ONEProgressHUD+Custom.h>
/*
 * do something
 */
ONEProgressHUD *hud = [ONEProgressHUD showOnView:[ONEProgressHUD TopWindow] labelText:@"加载中, 请稍后..."];
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
	[ONEProgressHUD switchToSuccessHud:hud withText:@"编辑常用地址成功"];
});

[ONEProgressHUD showOnViewWarnImg:nil labelText:@"警告"];

[ONEProgressHUD showOnViewSucceedImg:nil labelText:@"最多十二个字最多十二个字"];

[ONEProgressHUD showOnViewErrorImg:nil labelText:@"第十三个会显示不出来别说我没告诉你"];
```

##### API说明

```objc
#pragma mark 进度展示
/*
 * 展示进度，默认使用ONEProgressHUDModeIndeterminate及pending...文本,默认屏蔽背景用户操作
 */
+ (ONEProgressHUD *)showOnView:(UIView *)view;

/*
 * 展示进度，默认使用ONEProgressHUDModeIndeterminate，指定labelText文本,默认屏蔽背景用户操作
 */
+ (ONEProgressHUD *)showOnView:(UIView *)view labelText:(NSString*)labelText;

#pragma mark 结果展示
/*
 * 展示纯文本，不建议使用
 */
+ (void)showOnViewFinishTxt:(UIView *)view  labelText:(NSString*)labelText;

/*
 * 展示成功icon及文本结果，2s后自动消失
 * view：当view==nil时，使用window作为view
 * 屏蔽背景用户操作
 */
+ (void)showOnViewSucceedImg:(UIView *)view  labelText:(NSString*)labelText;

/*
 * 展示失败icon及文本结果，2s后自动消失
 * view：当view==nil时，使用window作为view
 * 屏蔽背景用户操作
 */
+ (void)showOnViewErrorImg:(UIView *)view  labelText:(NSString*)labelText;

/*
 * 展示警告icon及文本结果，2s后自动消失
 * view：当view==nil时，使用window作为view
 * 屏蔽背景用户操作
 */
+ (void)showOnViewWarnImg:(UIView *)view  labelText:(NSString*)labelText;
```

### Alert

<div id = "Alert"></div>

Alert是一款弹框组件，类似于`UIAlertView`，公开类`ONEAlertViewManager.h`

##### 使用方法

注意：buttonTitles个数为2时，高亮按钮显示在右边

```objc
[ONEAlertViewManager showAlertONEAlertView:^(ONEAlertViewModel *model) {
    [model setIconType:ONEAlertViewIconExclamMark];
    [model setTitle:@"我是标题"];
    [model setMessage:@"我是对话框的正文我是对话框的正文我是对话框的正文字数不要超过三行"];
    [model setCheckText:@"我可以被勾选"];
    [model setButtonTitles:@[@"确定操作",@"取消"]];
    [model setCanClose:YES];
} completion:^(BOOL closed, BOOL checked, NSInteger buttonIndex) {

}];
```

##### API说明

```obj
/**
 采用view model方式自定义alertView，可简单定义，也可复杂定义。

 @param modelBlock 定义alert的展示内容
 @param completion 点击事件

 @return 返回ONEAlertView实例，但不要强引用，Alert内部会持有
 */
+ (ONEAlertView *)showAlertONEAlertView:(void (^)(ONEAlertViewModel *model))modelBlock completion:(ONEAlertViewCompletionBlock)completion;

/**
 隐藏alert
 */
+ (void)dissmissAlert:(ONEAlertView *)alert animated:(BOOL)animated;
```

### Bubble

<div id = "Bubble"></div>

气泡组件，公开类`ONEBubbleTipsView.h`

##### 使用方法

```objc
ONEBubbleTipsView *tips1 = [ONEBubbleTipsView viewWithText:@"箭头在左边" canClose:NO];
tips1.arrowDirection = ONEBubbleArrowDirectionLeft;
[tips1 setCloseAction:^(ONEBubbleTipsView *bubbleTipsView) {
}];
[tips1 setTapAction:^(__kindof ONEBubbleView *bubble) {
}];
[tips1 showAnimation];
```

#### 公开API

```objc
/**
 *  创建气泡View
 *  @param text     显示的文本
 */
+ (instancetype)viewWithText:(NSString *)text;

///< Tips 左侧的图标，默认 nil
@property (nonatomic, strong, readonly) UIImage *icon;
/**
 Tips 文本,如需高亮,将高亮内容用{}包起来。
 */
@property (nonatomic, copy) NSString *text;
///< 最大宽度
@property (nonatomic, assign) CGFloat maxWidth;
///< 只显示一行，超出部分显示...
@property (nonatomic, assign) BOOL singleLine;

/**
 设置点击关闭事件block
 @param closeAction 关闭事件block
 */
- (void)setCloseAction:(ONEBubbleTipsViewCloseAction)closeAction;

///< 渐隐并移除
- (void)dismiss;
///< 显示并播放动画
- (void)showAnimation;
```

### Popup

<div id = "Popup"></div>

选择器，封装UITableView和UIPickerView，公开类`ONESingleChoicePopupManager.h`,`ONEPopupDatePickerView.h`

##### 使用方法

```
// pickerView
NSMutableArray *array = [NSMutableArray array];
for (int i = 0; i < 10; i++) {
    NSString *str = [NSString stringWithFormat:@"到达后%d0分钟",i];
    [array addObject:str];
}
[ONESingleChoicePopupManager showPickerSingleChoiceOnView:nil title:@"可配置标题" dataArray:array defaultIndex:0 complation:^(BOOL isClosed, NSInteger index, ONESingleChoicePopupModel *model) {
}];

// tableView
NSMutableArray *array = [NSMutableArray array];
for (int i = 0; i < 4; i++) {
    ONESingleChoicePopupModel *model = [[ONESingleChoicePopupModel alloc] init];
    [model setTitle:@"选项"];
    [array addObject:model];
}
[ONESingleChoicePopupManager showTableSingleChoiceOnView:nil title:@"可配置标题" style:ONEPopupTableViewStyleCenter dataArray:array defaultIndex:2 complation:^(BOOL isClosed, NSInteger index, ONESingleChoicePopupModel *model) {
}];

// datePickerView
ONEPopupDatePickerView *datePicker = [[ONEPopupDatePickerView alloc] init];
[datePicker setMinutesInterval:5];
[datePicker setStyle:ONEPopupDatePickerStyleDateAndWeek];
[datePicker setHasPresent:YES];
[datePicker setAutoDismiss:YES];
[datePicker setResetvationDays:3];
[datePicker showOnView:nil complation:^(BOOL isClosed, NSDate *date) {
}];
```

##### 公开API

```objc
/// ONESingleChoicePopupManager

/**
 使用TableView选择器

 @param superView    夫视图，如传nil默认显示在window上
 @param title        上方标题
 @param style        样式 <居中，居左，居左带图标>
 @param dataArray    数据列表,已经对NSString类型数组做兼容
 @param defaultIndex 默认选项，如不指定则传-1
 @param complation   完成选择block

 @return ONEPopupView实例
 */
+ (ONEPopupView *) showTableSingleChoiceOnView:(nullable UIView *)superView
                                         title:(nullable NSString *)title
                                         style:(ONEPopupTableViewStyle)style
                                     dataArray:(nonnull NSArray *)dataArray
                                  defaultIndex:(NSInteger)defaultIndex
                                    complation:(nullable ONESingleChoicePopupComplation)complation;

/**
 使用Pickerview选择器

 @param superView    夫视图，如传nil默认显示在window上
 @param title        上方标题
 @param dataArray    数据列表,已经对NSString类型数组做兼容
 @param defaultIndex 默认选项
 @param complation   完成选择block

 @return ONEPopupView实例
 */
+ (ONEPopupView *) showPickerSingleChoiceOnView:(nullable UIView *)superView
                                          title:(nullable NSString *)title
                                      dataArray:(nonnull NSArray *)dataArray
                                   defaultIndex:(NSInteger)defaultIndex
                                     complation:(nullable ONESingleChoicePopupComplation)complation;
```

```objc
/// ONEPopupDatePickerView

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, strong) NSDate *initialDate;
@property (nonatomic, copy) NSDate *defaultDate;
@property (nonatomic, assign) BOOL hasPresent;
@property (nonatomic, assign) NSUInteger resetvationDays;
@property (nonatomic, assign) NSInteger minutesInterval;
@property (nonatomic, assign) ONEPopupDatePickerStyle style;

/**
 * 移自ONEDatePickerView,增加了{DateAndWeek,TimeOnly}两种Style
 */
- (void)showOnView:(UIView *)superView complation:(ONEPopupDatePickerComplation)complation;
```

### Helper

<div id = "Helper"></div>

提供便捷的CGFloat,CGPoint,CGRect的便捷取整方法。公开类`ONEPixelAlign.h`

##### 公开API

```objc
#pragma mark convert
/// 将像素转为 point 值
CGFloat ONEPixelToFloat(CGFloat value);
/// 将 point 值转为像素
CGFloat ONEPixelFromFloat(CGFloat value);

#pragma mark float
/// CGFloat 像素对齐 (向下取整)
CGFloat ONEPixelFloor(CGFloat value);
/// CGFloat 像素对齐 (四舍五入)
CGFloat ONEPixelRound(CGFloat value);
/// CGFloat 像素对齐 (向上取整)
CGFloat ONEPixelCeil(CGFloat value);

#pragma mark point
/// CGPoint 像素对齐 (向下取整)
CGPoint ONEPixelPointFloor(CGPoint point);
/// CGPoint 像素对齐 (四舍五入)
CGPoint ONEPixelPointRound(CGPoint point);
/// CGPoint 像素对齐 (向上取整)
CGPoint ONEPixelPointCeil(CGPoint point);

#pragma mark size
/// CGSize 像素对齐 (向下取整)
CGSize ONEPixelSizeFloor(CGSize size);
/// CGSize 像素对齐 (四舍五入)
CGSize ONEPixelSizeRound(CGSize size);
/// CGSize 像素对齐 (向上取整)
CGSize ONEPixelSizeCeil(CGSize size);

#pragma mark rect
/// CGRect 像素对齐 (向下取整)
CGRect ONEPixelRectFloor(CGRect rect);
/// CGRect 像素对齐 (四舍五入)
CGRect ONEPixelRectRound(CGRect rect);
/// CGRect 像素对齐 (向上取整)
CGRect ONEPixelRectCeil(CGRect rect);
```


## 设计思路

ONEUIKit主要实现以下几点目标：

* ONEUIKit 组件独立，减少对其它库和层级的依赖
* ONEUIKit 里面的组件可以单独集成

### 素材资源管理

为了使用ONEUIKit中的组件可以单独集成，ONEUIKit里面的组件需要用到的素材也要单独分开，每个组件的素材使用单独的bundle，命名规范为 `ONEUIKit-<pod>` 如`ONEUIKit-HUD`。 image对象使用ONETheme api获得。如下：

```objc
[ONETheme imageNamed:@"xxx_xxx" inBundle:@"HUD"]
```


### 其它依赖管理

理论上，尽量不让ONEUIKit依赖底层foundation提供的一些基础服务(如logger，net等)。目前有一些UI组件必需要用到简单的网络功能，先使用依赖`SDWebImage`库。

## 维护者

zhanghuawei@didichuxing.com

## 版权声明

ONEUIKit 是滴滴内部项目，默认不对外开源。
