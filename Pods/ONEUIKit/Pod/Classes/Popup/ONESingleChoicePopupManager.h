//
//  ONESingleChoicePopupManager.h
//  Pods
//
//  Created by 张华威 on 16/9/20.
//
//

#import <Foundation/Foundation.h>

#import <ONEUIKit/ONEPopupTableView.h>
#import <ONEUIKit/ONEPopupPickerView.h>

@interface ONESingleChoicePopupManager : NSObject

/**
 使用Pickerview选择器
 
 @param superView    夫视图，如传nil默认显示在window上
 @param title        上方标题
 @param dataArray    数据列表,已经对NSString类型数组做兼容
 @param defaultIndex 默认选项
 @param complation   完成选择block
 
 @return ONEPopupView实例
 */
+ (nonnull ONEPopupView *) showPickerSingleChoiceOnView:(nullable UIView *)superView
                                                  title:(nullable NSString *)title
                                              dataArray:(nonnull NSArray <ONESingleChoicePopupModel *>*)dataArray
                                           defaultIndex:(NSInteger)defaultIndex
                                             complation:(nullable ONESingleChoicePopupComplation)complation;

/**
 使用Pickerview选择器
 
 @param superView    夫视图，如传nil默认显示在window上
 @param title        上方主标题
 @param detailTitle  上方副标题
 @param dataArray    数据列表,已经对NSString类型数组做兼容
 @param defaultIndex 默认选项
 @param complation   完成选择block
 
 @return ONEPopupView实例
 */
+ (nonnull ONEPopupView *) showPickerSingleChoiceOnView:(nullable UIView *)superView
                                                  title:(nullable NSString *)title
                                            detailTitle:(nullable NSString *)detailTitle
                                              dataArray:(nonnull NSArray <ONESingleChoicePopupModel *>*)dataArray
                                           defaultIndex:(NSInteger)defaultIndex
                                             complation:(nullable ONESingleChoicePopupComplation)complation;

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
+ (nonnull ONEPopupView *) showTableSingleChoiceOnView:(nullable UIView *)superView
                                                 title:(nullable NSString *)title
                                                 style:(ONEPopupTableViewStyle)style
                                             dataArray:(nonnull NSArray <ONESingleChoicePopupModel *>*)dataArray
                                          defaultIndex:(NSInteger)defaultIndex
                                            complation:(nullable ONESingleChoicePopupComplation)complation;


/**
 使用TableView选择器

 @param superView    夫视图，如传nil默认显示在window上
 @param title        上方主标题
 @param detailTitle  上方副标题
 @param style        样式 <居中，居左，居左带图标>
 @param dataArray    数据列表,已经对NSString类型数组做兼容
 @param defaultIndex 默认选项，如不指定则传-1
 @param complation   完成选择block
 
 @return ONEPopupView实例
 */
+ (nonnull ONEPopupView *)showTableSingleChoiceOnView:(nullable UIView *)superView
                                                title:(nullable NSString *)title
                                          detailTitle:(nullable NSString *)detailTitle
                                                style:(ONEPopupTableViewStyle)style
                                            dataArray:(nonnull NSArray<ONESingleChoicePopupModel *> *)dataArray
                                         defaultIndex:(NSInteger)defaultIndex
                                           complation:(nullable ONESingleChoicePopupComplation)complation;


@end
