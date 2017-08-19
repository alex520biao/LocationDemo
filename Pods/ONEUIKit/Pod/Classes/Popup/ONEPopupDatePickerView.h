//
//  ONEPopupDatePickerView.h
//  Pods
//
//  Created by 张华威 on 16/9/22.
//
//

#import <UIKit/UIKit.h>
#import <ONEUIKit/ONEPopupView.h>

typedef void (^ONEPopupDatePickerComplation) (BOOL isClosed, NSDate *date);

typedef NS_ENUM(NSUInteger, ONEPopupDatePickerStyle) {
    ONEPopupDatePickerStyleDefault,
    ONEPopupDatePickerStyleDateAndWeek,
    ONEPopupDatePickerStyleTimeOnly
};

@interface NSDate (ONEPopupDatePickerView)
@property (nonatomic, assign, readonly) BOOL isPresent;
@end

@interface ONEPopupDatePickerView : ONEPopupView

@property (nonatomic, copy) NSDate *startDate;
@property (nonatomic, strong) NSDate *initialDate;
//@property (nonatomic, copy) NSDate *defaultDate;
@property (nonatomic, assign) BOOL hasPresent;
@property (nonatomic, assign) NSUInteger resetvationDays;
@property (nonatomic, assign) NSUInteger minutesInterval;
@property (nonatomic, assign) ONEPopupDatePickerStyle style;
@property (nonatomic, assign) NSUInteger firstValidDateIntervalMins; ///< startTime后的第一个有效时间间隔，单位分钟，默认15
@property (nonatomic, assign) NSUInteger startHourValue;
@property (nonatomic, assign) NSUInteger endHourValue;

@property (nonatomic, assign) BOOL isSpecifiedDays; ///< 忽略是否有今天，resetvationDays是几天就显示几天

/**
 * 移自ONEDatePickerView,增加了{DateAndWeek,TimeOnly}两种Style
 */
- (void)showOnView:(UIView *)superView complation:(ONEPopupDatePickerComplation)complation;

- (BOOL)isDateInPicker:(NSDate *)date;

@end
