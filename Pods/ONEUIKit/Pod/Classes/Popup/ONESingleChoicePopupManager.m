//
//  ONESingleChoicePopupManager.m
//  Pods
//
//  Created by 张华威 on 16/9/20.
//
//

#import "ONESingleChoicePopupManager.h"

@implementation ONESingleChoicePopupManager

#pragma mark - picker

+ (nonnull ONEPopupView *) showPickerSingleChoiceOnView:(nullable UIView *)superView
                                                  title:(nullable NSString *)title
                                              dataArray:(nonnull NSArray <ONESingleChoicePopupModel *>*)dataArray
                                           defaultIndex:(NSInteger)defaultIndex
                                             complation:(nullable ONESingleChoicePopupComplation)complation {
    
    return [self showPickerSingleChoiceOnView:superView
                                        title:title
                                  detailTitle:nil
                                    dataArray:dataArray
                                 defaultIndex:defaultIndex
                                   complation:complation];
}

+ (nonnull ONEPopupView *) showPickerSingleChoiceOnView:(nullable UIView *)superView
                                                  title:(nullable NSString *)title
                                            detailTitle:(nullable NSString *)detailTitle
                                              dataArray:(nonnull NSArray <ONESingleChoicePopupModel *>*)dataArray
                                           defaultIndex:(NSInteger)defaultIndex
                                             complation:(nullable ONESingleChoicePopupComplation)complation {
    
    ONEPopupPickerView *pickerView = [[ONEPopupPickerView alloc] init];
    [pickerView setDataArray:dataArray];
    [pickerView setDefaultIndex:(int)defaultIndex];
    [pickerView setTitle:title];
    [pickerView setDetialTitle:detailTitle];
    [pickerView showOnView:superView complation:complation];
    return pickerView;
}

#pragma mark - table

+ (nonnull ONEPopupView *) showTableSingleChoiceOnView:(nullable UIView *)superView
                                                 title:(nullable NSString *)title
                                                 style:(ONEPopupTableViewStyle)style
                                             dataArray:(nonnull NSArray <ONESingleChoicePopupModel *>*)dataArray
                                          defaultIndex:(NSInteger)defaultIndex
                                            complation:(nullable ONESingleChoicePopupComplation)complation {
    
    return [self showTableSingleChoiceOnView:superView
                                       title:title
                                 detailTitle:nil
                                       style:style
                                   dataArray:dataArray
                                defaultIndex:defaultIndex
                                  complation:complation];
}

+ (nonnull ONEPopupView *)showTableSingleChoiceOnView:(nullable UIView *)superView
                                                title:(nullable NSString *)title
                                          detailTitle:(nullable NSString *)detailTitle
                                                style:(ONEPopupTableViewStyle)style
                                            dataArray:(nonnull NSArray<ONESingleChoicePopupModel *> *)dataArray
                                         defaultIndex:(NSInteger)defaultIndex
                                           complation:(nullable ONESingleChoicePopupComplation)complation {
    if (dataArray.count <= 0) {
        return nil;
    }
    
    // tableView型选择器只允许5条
    if (dataArray.count > 5) {
        [dataArray subarrayWithRange:NSMakeRange(0, 5)];
    }
    ONEPopupTableView *tableView = [[ONEPopupTableView alloc] init];
    [tableView setDataArray:dataArray];
    [tableView setDefaultIndex:(int)defaultIndex];
    [tableView setStyle:style];
    [tableView setTitle:title];
    [tableView setDetialTitle:detailTitle];
    [tableView showOnView:superView complation:complation];
    return tableView;
}

@end
