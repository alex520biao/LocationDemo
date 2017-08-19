//
//  ONEPopupDatePickerView.m
//  Pods
//
//  Created by 张华威 on 16/9/22.
//
//

#import "ONEPopupDatePickerView.h"
#import <UIView+Positioning/UIView+Positioning.h>
#import <ONEUIKit/ONEUIKitTheme.h>
#import <ONEFoundation/NSArray+ONEExtends.h>
#import <ONEFoundation/NSDate+ONEExtends.h>
#import <ONEFoundation/ONELocalizedString.h>
#import <ONEFoundation/ONEUserLanguageManager.h>
#import <objc/runtime.h>

#define SafeBlockRun(block, ...) block ? block(__VA_ARGS__) : nil
#define ONEPopupLocalizedStr(str) ONELocalizedStr(str, @"ONEUIKit-Popup")

static const CGFloat kPickerViewHeight = 153.f;
static const CGFloat kPickerViewRowHeight = 34.f;
static const CGFloat kPickerViewMarginH = 20.f;
static const CGFloat kPickerViewMarginW = 16.f;

static const void *dateIsPresent;

@interface NSDate (TRDatePickerView)

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds;

- (NSString *)preOrderText;

// 后天
- (BOOL)isDayAfterTomorrow;

- (NSString *)dateString;

- (NSString *)stringWithFormat:(NSString *)format;

// 根据日期字符串和格式，生成日期
+ (NSDate *)dateFromString:(NSString *)aString withFormat:(NSString *)aFromat;

- (BOOL)isEqualToDateIgnoringSecond:(NSDate *)aDate;

@end

@implementation NSDate (ONEPopupDatePickerView)

- (BOOL)isPresent {
    id present = objc_getAssociatedObject(self, &dateIsPresent);
    if ([present respondsToSelector:@selector(boolValue)]) {
        return [present boolValue];
    }
    return NO;
}

@end

@interface ONEPopupDatePickerView () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *backView;

@property (nonatomic, strong) NSDate *validDate;
//上一次选择的小时
@property (nonatomic, strong) NSString *latestSelectedHour;
//上一次选择的分钟
@property (nonatomic, strong) NSString *latestSelectedMinute;
@end

@implementation ONEPopupDatePickerView

#pragma - mark Public

- (void)showOnView:(UIView *)superView complation:(ONEPopupDatePickerComplation)complation {
    if (!superView) {
        superView  = [[UIApplication sharedApplication].delegate window];
    }
    
    NSAssert(self.startHourValue != self.endHourValue, @"开始和结束时间相同");
    
    self.showTopView = YES;
    
    self.contentView = [[UIView alloc] init];
    
    [self.pickerView setFrame:CGRectMake(kPickerViewMarginW, kPickerViewMarginH, superView.width - kPickerViewMarginW * 2, kPickerViewHeight)];
    [self.backView setFrame:CGRectMake(0, 0, superView.width, kPickerViewHeight + kPickerViewMarginH * 2)];
    [self.backView addSubview:self.pickerView];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, self.pickerView.centerY - (kPickerViewMarginH + 17) / 2, superView.width, .5f)];
    [line1 setBackgroundColor:[kColorBlack colorWithAlphaComponent:.1f]];
    [self.backView addSubview:line1];
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, self.pickerView.centerY + (kPickerViewMarginH + 17) / 2 - .5f, superView.width, .5f)];
    [line2 setBackgroundColor:[kColorBlack colorWithAlphaComponent:.1f]];
    [self.backView addSubview:line2];
    
    [self.contentView addSubview:self.backView];
    [self.contentView setFrame:self.backView.frame];
    
    NSDate *validDate = [self getFirstValidDate];
    self.validDate = validDate;
    
    __weak typeof(self) weakSelf = self;
    [super showOnView:superView close:^(ONEPopupViewCloseType type) {
        SafeBlockRun(complation, YES, nil);
    } confirm:^{
        __strong typeof(weakSelf) strongSelf = weakSelf;
        if (strongSelf) {
            SafeBlockRun(complation, NO, [self selectedDateTime]);
        }
    }];
    
    if (!self.initialDate && !self.hasPresent) {
        self.initialDate = self.startDate;
    }
    
    [self reloadWithDate:self.initialDate];

}

- (void)reloadWithDate:(NSDate *)date {
    [self.pickerView reloadAllComponents];
    
    if (!date) {
        [self.pickerView selectRow:0 inComponent:0 animated:NO];
        [self.pickerView selectRow:0 inComponent:1 animated:NO];
        [self.pickerView selectRow:0 inComponent:2 animated:NO];
        
        _latestSelectedHour = [[self getHoursForDayIndex:0] firstObject];
        _latestSelectedMinute = [[self getMinutesForDayIndex:0 hourIndex:0] firstObject];
        return;
    }
    
    if ((date.one_minute % 10) != 0)
        date = [date one_dateByAddingMinutes:10];
    
    //限制时间范围
    NSInteger daysCount;
    if (self.isSpecifiedDays) {
        daysCount = self.resetvationDays;
    } else {
        daysCount = [self hasToday] ? (self.resetvationDays + 1) : self.resetvationDays;
    }
    NSDate *lastDate = self.lastDate;
    if ([date one_isEarlierThanDate:self.validDate])
        date = self.validDate;
    else if ([date one_isLaterThanDate:lastDate])
        date = lastDate;
    
    NSInteger dayIndex = ([[date one_dateAtEndOfDay] timeIntervalSince1970] - [[self.validDate one_dateAtEndOfDay] timeIntervalSince1970]) / (60 * 60 * 24);
    if (dayIndex >= 0 && dayIndex < [self.pickerView numberOfRowsInComponent:0])
        [self.pickerView selectRow:dayIndex inComponent:0 animated:NO];
    
    [self.pickerView reloadComponent:1];
    [self.pickerView reloadComponent:2];
    
    NSInteger hourIndex = date.one_hour;
    if ([self.pickerView selectedRowInComponent:0] == 0) {
        hourIndex = date.one_hour - self.validDate.one_hour;
        if ([self hasPresent] && [self hasToday])
            hourIndex = hourIndex + 1;
    }
    
    if (hourIndex >= 0 && hourIndex < [self.pickerView numberOfRowsInComponent:1])
        [self.pickerView selectRow:hourIndex inComponent:1 animated:NO];
    
    [self.pickerView reloadComponent:2];
    
    NSInteger minuteIndex = floorf((float)date.one_minute / 10.0);
    if ([self isMinuteFirst])
        minuteIndex = floorf((float)(date.one_minute - self.validDate.one_minute) / 10.0);
    if (minuteIndex >= 0 && minuteIndex < [self.pickerView numberOfRowsInComponent:2])
        [self.pickerView selectRow:minuteIndex inComponent:2 animated:NO];
}

- (NSArray *)getMinutesForDayIndex:(NSUInteger)dayIndex hourIndex:(NSUInteger)hourIndex {
    NSMutableArray * minutes = [NSMutableArray array];
    
    if ([self.pickerView numberOfRowsInComponent:0] == 0)
        return minutes;
    
    NSInteger startMinute = 0;
    
    if (dayIndex == 0 && [self hasToday] && [self hasPresent]) {
        if (hourIndex == 0) {
            [minutes addObject:@""];
            return minutes;
        } else if (hourIndex == 1) {
            startMinute = self.validDate.one_minute;
        }
    } else if (dayIndex == 0 && hourIndex == 0 && ![self hasToday] && [self hasPresent]) {
        [minutes addObject:@""];
        return minutes;
    } else if (dayIndex == 0 && hourIndex == 0) {
        startMinute = self.validDate.one_minute;
    } else if (dayIndex == 1 && hourIndex == 0 && ![self hasToday] && [self hasPresent]) {
        startMinute = self.validDate.one_minute;
    }
    
    for (NSInteger i = startMinute; i < 60; i += self.minutesInterval) {
        [minutes addObject:[NSString stringWithFormat:@"%02ld", (long)i]];
    }
    
    return minutes;
}

- (NSArray *)getHoursForDayIndex:(NSUInteger)dayIndex {
    NSMutableArray * hours = [NSMutableArray array];
    
    if ([self.pickerView numberOfRowsInComponent:0] == 0) {
        return hours;
    }
    
    if (self.hasPresent && dayIndex == 0) {
        [hours addObject:ONEPopupLocalizedStr(@"现在")];
        
        if (![self hasToday]) {
            return hours;
        }
    }
    
    NSInteger startHour = 0;
    if (dayIndex == 0) {
        startHour = self.validDate.one_hour;
    }
    
    startHour = MAX(startHour, self.startHourValue);
    
    NSUInteger endHourValue = MAX(MIN(24, self.endHourValue), 1);
    
    for (NSInteger i = startHour; i < endHourValue; ++i) {
        [hours addObject:[NSString stringWithFormat:@"%ld", (long)i]];
    }
    
    return hours;
}

- (NSDate *)selectedDateTime{
    
    if ([self isSelectedPresent]) {
        NSDate *date = [NSDate date];
        objc_setAssociatedObject(date, &dateIsPresent, @(YES), OBJC_ASSOCIATION_RETAIN);
        return date;
    }
    
    NSInteger dayIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger hourIndex = [self.pickerView selectedRowInComponent:1];
    NSInteger minuteIndex = [self.pickerView selectedRowInComponent:2];
    
    NSDate *selectedDate = nil;
    if (![self hasToday] && self.hasPresent) {
        selectedDate = [[self.validDate one_dateByAddingDays:(dayIndex - 1)] one_dateAtStartOfDay];
    } else {
        selectedDate = [[self.validDate one_dateByAddingDays:dayIndex] one_dateAtStartOfDay];
    }
    NSString *hour = [self getHourForDayIndex:dayIndex withHourIndex:hourIndex];
    selectedDate = [selectedDate one_dateByAddingHours:[hour integerValue]];
    NSString *minute = [self getMinuteForDayIndex:dayIndex hourIndex:hourIndex minuteIndex:minuteIndex];
    selectedDate = [selectedDate one_dateByAddingMinutes:[minute integerValue]];
    
    return selectedDate;
}

- (BOOL)isSelectedPresent {
    NSInteger dayIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger hourIndex = [self.pickerView selectedRowInComponent:1];
    if ([[self getHourForDayIndex:dayIndex withHourIndex:hourIndex] isEqualToString:ONEPopupLocalizedStr(@"现在")])
        return YES;
    else
        return NO;
}

- (BOOL)isMinuteFirst {
    if (!self.hasPresent && [self.pickerView selectedRowInComponent:0] == 0 && [self.pickerView selectedRowInComponent:1] == 0)
        return YES;
    else if (self.hasPresent && [self.pickerView selectedRowInComponent:0] == 0 && [self.pickerView selectedRowInComponent:1] == 1)
        return YES;
    else
        return NO;
}

- (void)setMinutesInterval:(NSUInteger)minutesInterval {
    if (minutesInterval <= 0) {
        NSAssert(minutesInterval > 0, @"minutesInterval 必须大于0，否则会造成死循环");
        minutesInterval = 5;
    }
    _minutesInterval = minutesInterval;
}

- (BOOL)isDateInPicker:(NSDate *)date {
    
    if (!date || ![date isKindOfClass:[NSDate class]]) {
        return NO;
    }
    
    if (!self.validDate) {
        self.validDate = [self getFirstValidDate];
    }
    
    if ([date isEqualToDateIgnoringSecond:self.lastDate] ||
        [date isEqualToDateIgnoringSecond:self.validDate]) {
        return YES;
    }
    
    if ([date one_isLaterThanDate:self.lastDate] || \
        [date one_isEarlierThanDate:self.validDate]) {
        return NO;
    }
    
    if (date.one_hour < self.startHourValue || \
        date.one_hour >= self.endHourValue) {
        return NO;
    }
    
    return YES;
    
}

#pragma mark private

- (instancetype)init {
    if (self = [super init]) {
        _startDate = [NSDate date];
        _firstValidDateIntervalMins = 15;
        _minutesInterval = 15;
        _endHourValue = 24;
    }
    return self;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        _pickerView = [[UIPickerView alloc] init];
        [_pickerView setDelegate:self];
        [_pickerView setDataSource:self];
        [_pickerView setBackgroundColor:kColorWhite];
        [_pickerView setShowsSelectionIndicator:YES];
    }
    return _pickerView;
}

- (UIView *)backView {
    if (!_backView) {
        _backView = [[UIView alloc] init];
        [_backView setBackgroundColor:kColorWhite];
    }
    return _backView;
}

#pragma mark - 数据准备

- (NSDate *)getFirstValidDate {
    // 找到第一个有效的时间，当前时间+15分钟，向后取整（取分钟，对10求余，再用10减去余数，+15后的数，加上该减之后的结果）
    NSDate * validDate = self.startDate;
    
    if ([validDate one_isToday] || [[[NSDate date] one_dateByAddingMinutes:self.firstValidDateIntervalMins] one_isLaterThanDate:validDate])
        validDate = [validDate one_dateByAddingMinutes:self.firstValidDateIntervalMins];
    NSInteger interval = 0;
    NSInteger diff = [validDate one_minute] % 10;
    if (diff > 0) {
        interval = 10 - diff;
    }
    
    validDate = [validDate one_dateByAddingMinutes:interval];
    validDate = [validDate one_dateByAddingSeconds:-validDate.one_seconds];
    
    NSInteger startHour = 0;
    if ([validDate one_isToday]) {
        startHour = validDate.one_hour;
    }
    startHour = MAX(startHour, self.startHourValue);
    NSUInteger endHourValue = MAX(MIN(24, self.endHourValue), 1);
    
    // validDate在startDate
    if ([validDate one_isSameDay:self.startDate]) {
        if (validDate.one_hour < startHour) {
            // 在合法时间前，取startDate startHour点整，
            validDate = [validDate one_dateAtStartOfDay];
            validDate = [validDate one_dateByAddingHours:startHour];
        } else if (validDate.one_hour >= endHourValue) {
            // 在合法时间后，取startDate第二天startHour点整
            validDate = [validDate one_dateAfterDay:1];
            validDate = [validDate one_dateAtStartOfDay];
            validDate = [validDate one_dateByAddingHours:MAX(0, self.startHourValue)];
        } else {
            // 合法时间，不动
        }
        
    }
    
    return validDate;
}

- (NSDate *)lastDate {
    NSInteger daysCount;
    if (self.isSpecifiedDays) {
        daysCount = self.resetvationDays;
    } else {
        daysCount = [self hasToday] ? (self.resetvationDays + 1) : self.resetvationDays;
    }
    return [[[self.validDate one_dateByAddingDays:daysCount - 1] one_dateAtEndOfDay] one_dateByAddingMinutes:-9];
}

- (BOOL)hasToday {
    if ([self.validDate one_isToday] && self.validDate.one_day == self.startDate.one_day)
        return YES;
    else
        return NO;
}

- (NSArray *)getDaysFromStartDateWithWeek:(BOOL)withWeek {
    NSMutableArray *daysArray = [NSMutableArray array];
    
    if ([self hasToday] || (![self hasToday] && self.hasPresent)) {
        NSString *str;
        if (withWeek) {
            str = [NSString stringWithFormat:@"%@%@%ld%@ %@",
                   ONEPopupLocalizedStr([NSDate one_monthWithMonthNumber:[NSDate date].one_month]),
                   ONEPopupLocalizedStr(@"月"),
                   (long)[NSDate date].one_day,
                   ONEPopupLocalizedStr(@"日"),
                   ONEPopupLocalizedStr(@"今天")
                   ];
        } else {
            str = [NSString stringWithFormat:@"%@", ONEPopupLocalizedStr(@"今天")];
        }
        
        [daysArray addObject:str];
    }
    
    NSInteger shift = [self hasToday] ? 1 : 0;
    NSUInteger resetvationDays;
    if (self.isSpecifiedDays) {
        resetvationDays = self.resetvationDays - shift;
    } else {
        resetvationDays = self.resetvationDays;
    }
    
    for (int i = 0; i < resetvationDays; i++) {
        NSDate *tempDate = [self.validDate one_dateByAddingDays:(i + shift)];
        if (withWeek) {
            [daysArray addObject:[NSString stringWithFormat:@"%@%@%ld%@ %@",
                                 ONEPopupLocalizedStr([NSDate one_monthWithMonthNumber:tempDate.one_month]),
                                 ONEPopupLocalizedStr(@"月"),
                                 (long)tempDate.one_day,
                                 ONEPopupLocalizedStr(@"日"),
                                 [tempDate one_dayFromWeekday]
                                 ]];
        } else {
            if ([tempDate one_isTomorrow])
                [daysArray addObject:[NSString stringWithFormat:@"%@",ONEPopupLocalizedStr(@"明天")]];
//            else if ([[tempDate one_dateByAddingDays:-1] one_isTomorrow])
//                [daysArray addObject:[NSString stringWithFormat:ONEPopupLocalizedStr(@"后天")]];
            else
                [daysArray addObject:[NSString stringWithFormat:@"%@%@%ld%@",
                                      ONEPopupLocalizedStr([NSDate one_monthWithMonthNumber:tempDate.one_month]),
                                      ONEPopupLocalizedStr(@"月"),
                                      (long)tempDate.one_day,
                                      ONEPopupLocalizedStr(@"日")
                                      ]];
        }
    }
    
    return daysArray;
}

- (NSDate *)getStartDateForDate:(NSDate *)aDate aDay:(NSInteger)aDay {
    NSDate * startDate = nil;
    startDate = [aDate one_dateByAddingDays:aDay];
    return [startDate one_dateAtStartOfDay];
}

- (NSString *)getHourForDayIndex:(NSUInteger)dayIndex withHourIndex:(NSUInteger)hourIndex{
    NSArray *array = [self getHoursForDayIndex:dayIndex];
    if ( hourIndex < [array count]) {
        return [array one_objectAtIndex:hourIndex];
    }
    return [array lastObject];
}

- (NSString *)getMinuteForDayIndex:(NSUInteger)dayIndex hourIndex:(NSUInteger)hourIndex minuteIndex:(NSUInteger)minuteIndex{
    NSArray *array = [self getMinutesForDayIndex:dayIndex hourIndex:hourIndex];
    if (minuteIndex < [array count]) {
        return [array one_objectAtIndex:minuteIndex];
    }
    return [array lastObject];
}

#pragma -mark UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pv{
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    switch (component) {
        case 0 :{
            if (self.style == ONEPopupDatePickerStyleDateAndWeek) {
                NSArray *arr = [self getDaysFromStartDateWithWeek:YES];
                return arr.count;
            } else {
                NSArray *arr = [self getDaysFromStartDateWithWeek:NO];
                return arr.count;
            }
        }
            
        case 1 :
            return [[self getHoursForDayIndex:[self.pickerView selectedRowInComponent:0]] count];
            
        case 2 :
            return [[self getMinutesForDayIndex:[self.pickerView selectedRowInComponent:0] hourIndex:[self.pickerView selectedRowInComponent:1]] count];
            
        default:
            return 0;
    }
}

#pragma -mark UIPickerViewDelegate

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return kPickerViewRowHeight;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    
    CGFloat width = self.pickerView.frame.size.width;
    
    switch (self.style) {
        case ONEPopupDatePickerStyleDefault: {
            return width / 3;
        } break;
            
        case ONEPopupDatePickerStyleDateAndWeek: {
            switch (component) {
                case 0: {
                    return width * .5f;
                } break;
                    
                case 1: {
                    return width * .2f;
                } break;
                    
                case 2: {
                    return width * .3f;
                } break;
            }
        } break;
            
        case ONEPopupDatePickerStyleTimeOnly: {
            switch (component) {
                case 0: {
                    return 0;
                } break;
                    
                case 1: {
                    return width * .5f;
                } break;
                    
                case 2: {
                    return width * .5f;
                } break;
            }
        }
    }
    
    NSAssert(NO, @"无效的Style");
    return width / 3;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];

    label.backgroundColor = [UIColor clearColor];
    label.textColor = [ONEUIKitTheme colorWithHexString:@"0a0a0a"];
    label.font = kFontSizeLarge1_;
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"";
    
    switch (component) {
        case 0 : {
            NSArray *dayArray;
            switch (self.style) {
                case ONEPopupDatePickerStyleDefault: {
                    dayArray = [self getDaysFromStartDateWithWeek:NO];
                    if (row < dayArray.count) {
                        label.text = [NSString stringWithFormat:@"%@", [dayArray one_objectAtIndex:row]];
                    }
                } break;
                case ONEPopupDatePickerStyleDateAndWeek: {
                    dayArray = [self getDaysFromStartDateWithWeek:YES];
                    if (row < dayArray.count) {
                        label.text = [NSString stringWithFormat:@"%@", [dayArray one_objectAtIndex:row]];
                    }
                } break;
                case ONEPopupDatePickerStyleTimeOnly: {
                    label.frame = CGRectZero;
                }
                    
                default:
                    break;
            }
            if (row < dayArray.count) {
                label.text = [NSString stringWithFormat:@"%@", [dayArray one_objectAtIndex:row]];
            }
            break;
        }
            
        case 1 :
        {
            NSArray * arrayHours = [self getHoursForDayIndex:[self.pickerView selectedRowInComponent:0]];
            if (row < [arrayHours count]) {
                if ([[arrayHours one_objectAtIndex:row] isEqualToString:ONEPopupLocalizedStr(@"现在")]) {
                    label.text = [arrayHours one_objectAtIndex:row];
                } else {
                    label.text = [NSString stringWithFormat:ONEPopupLocalizedStr(@"%@点"), [arrayHours one_objectAtIndex:row]];
                }
            }
        }
            break;
            
        case 2 :
        {
            NSArray * arrayMinute = [self getMinutesForDayIndex:[self.pickerView selectedRowInComponent:0] hourIndex:[self.pickerView selectedRowInComponent:1]];
            
            if (row < [arrayMinute count]) {
                NSString *minute = [arrayMinute one_objectAtIndex:row];
                label.text = [NSString stringWithFormat:@"%@%@", minute, minute.length > 0 ? ONEPopupLocalizedStr(@"分") : @""];
            }
        }
            break;
            
        default:
            break;
    }
    
    ((UIView *)[self.pickerView.subviews objectAtIndex:1]).backgroundColor = kColorClear;
    ((UIView *)[self.pickerView.subviews objectAtIndex:2]).backgroundColor = kColorClear;
    
    return label;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    switch (component) {
        case 0 : {
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [self setDefaultHour];
            [self setDefaultMimute];
        } break;
        case 1 : {
            [pickerView reloadComponent:1];
            [pickerView reloadComponent:2];
            [self setDefaultMimute];
        } break;
        case 2 : {
            NSInteger dayIndex = [self.pickerView selectedRowInComponent:0];
            NSInteger hourIndex = [self.pickerView selectedRowInComponent:1];
            NSString *selectHour = [self getHourForDayIndex:dayIndex withHourIndex:hourIndex];
            _latestSelectedHour = selectHour;
            NSInteger minuteIndex = [self.pickerView selectedRowInComponent:2];
            NSString *selectMinute = [self getMinuteForDayIndex:dayIndex hourIndex:hourIndex minuteIndex:minuteIndex];
            _latestSelectedMinute = selectMinute;
        } break;
    }
}

- (void)setDefaultHour{
    NSInteger dayIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger hourIndex = [self.pickerView selectedRowInComponent:1];
    NSArray *arrayHours = [self getHoursForDayIndex:dayIndex];
    //如果有上次选择的小时
    if (_latestSelectedHour) {
        //判断上次选择的小时是否在当前的小时列表里
        NSInteger indexOfLatestHour = [self indexOfString:_latestSelectedHour inArray:arrayHours];
        if (indexOfLatestHour > -1) {
            [self.pickerView selectRow:indexOfLatestHour inComponent:1 animated:NO];
        }else{
            _latestSelectedHour = [arrayHours one_objectAtIndex:0];
            [self.pickerView selectRow:0 inComponent:1 animated:NO];
            return;
        }
    }else{
        NSString *selectHour;
        if (hourIndex < arrayHours.count) {
            selectHour = [arrayHours one_objectAtIndex:hourIndex];
        }else{
            selectHour = [arrayHours firstObject];
        }
        _latestSelectedHour = selectHour;
    }
    
}
- (void)setDefaultMimute{
    NSInteger dayIndex = [self.pickerView selectedRowInComponent:0];
    NSInteger hourIndex = [self.pickerView selectedRowInComponent:1];
    NSArray *arrayHours = [self getHoursForDayIndex:dayIndex];
    NSString *selectHour = [arrayHours one_objectAtIndex:hourIndex];
    _latestSelectedHour = selectHour;
    NSInteger minuteIndex = [self.pickerView selectedRowInComponent:2];
    NSArray *arrayMinutes = [self getMinutesForDayIndex:dayIndex hourIndex:hourIndex];
    NSString *selectMinute;
    if (minuteIndex <  arrayMinutes.count) {
        selectMinute = arrayMinutes[minuteIndex];
    }else{
        selectMinute = [arrayMinutes firstObject];
    }
    //如果有上次选择的分钟
    if (_latestSelectedMinute) {
        //判断上次选择的分钟是否在当前的分钟列表里
        NSInteger indexOfLatestMinute = [self indexOfString:_latestSelectedMinute inArray:arrayMinutes];
        if (indexOfLatestMinute > -1) {
            [self.pickerView selectRow:indexOfLatestMinute inComponent:2 animated:NO];
        }else{
            _latestSelectedMinute = [arrayMinutes firstObject];
            [self.pickerView selectRow:0 inComponent:2 animated:NO];
            return;
        }
    }else{
        _latestSelectedMinute = selectMinute;
    }
    
}
- (NSInteger )indexOfString:(NSString *)string inArray:(NSArray *)array{
    NSInteger index = -1;
    for (int i = 0; i< array.count; i++) {
        id  subObj = array[i];
        if (subObj && [subObj isKindOfClass:[NSString class]]) {
            NSString *subString = (NSString *)subObj;
            if ([subString isEqualToString:string]) {
                index = i;
            }
        }
    }
    return index;
}

@end


#define DATE_COMPONENTS (NSYearCalendarUnit| NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit | NSWeekdayCalendarUnit | NSWeekdayOrdinalCalendarUnit)
#define CURRENT_CALENDAR [NSCalendar currentCalendar]

@implementation NSDate (TRDatePickerView)

- (NSDate *)dateByAddingSeconds:(NSInteger)seconds{
    NSInteger secsToAdd = seconds;
    return [[NSDate alloc] initWithTimeInterval:secsToAdd sinceDate:self];
}

- (NSString *)preOrderText{
    NSString * dateTxt = nil;
    
    if ([self isToday]) {
        dateTxt = ONEPopupLocalizedStr(@"今天");
    } else if([self isTomorrow]){
        dateTxt = ONEPopupLocalizedStr(@"明天");
//    }else if ([self isDayAfterTomorrow]){
//        dateTxt = ONEPopupLocalizedStr(@"后天");
    }else{
        return self.dateString;
    }
    
    return [NSString stringWithFormat:@"%@ %@", dateTxt, [self stringWithFormat:@"HH:mm"]];
}

- (BOOL)isDayAfterTomorrow{
    return [self isEqualToDateIgnoringTime:[NSDate dateWithDaysFromNow:2]];
}

- (BOOL) isToday
{
    return [self isEqualToDateIgnoringTime:[NSDate date]];
}
- (BOOL) isTomorrow
{
    return [self isEqualToDateIgnoringTime:[NSDate dateTomorrow]];
}

+ (NSDate *) dateTomorrow
{
    return [NSDate dateWithDaysFromNow:1];
}

+ (NSDate *) dateWithDaysFromNow: (NSInteger) days
{
    // Thanks, Jim Morrison
    return [[NSDate date] dateByAddingDays:days];
}

- (NSDate *)dateByAddingDays:(NSUInteger)days {
    NSDateComponents *c = [[NSDateComponents alloc] init];
    c.day = days;
    return [[NSCalendar currentCalendar] dateByAddingComponents:c toDate:self options:0];
}

- (BOOL) isEqualToDateIgnoringTime: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day));
}

- (BOOL)isEqualToDateIgnoringSecond: (NSDate *) aDate
{
    NSDateComponents *components1 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:self];
    NSDateComponents *components2 = [CURRENT_CALENDAR components:DATE_COMPONENTS fromDate:aDate];
    return ((components1.year == components2.year) &&
            (components1.month == components2.month) &&
            (components1.day == components2.day) &&
            (components1.hour == components2.hour) &&
            (components1.minute == components2.minute)
            );
}

//将日期转换为字符串（日期，时间）
-(NSString *)dateString{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:self];
    NSInteger hour = [comps hour];
    NSInteger min = [comps minute];
    NSInteger sec = [comps second];
    NSInteger year = [comps year];
    NSInteger month = [comps month];
    NSInteger day = [comps day];
    
    return [NSString stringWithFormat:@"%04ld-%02ld-%02ld %02ld:%02ld:%02ld",(long)year, (long)month, (long)day, (long)hour, (long)min,(long)sec];
}

- (NSString *)stringWithFormat:(NSString *)format {
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    outputFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[ONEUserLanguageManager currentLanguage]];
    [outputFormatter setDateFormat:format];
    NSString *timestamp_str = [outputFormatter stringFromDate:self];
    
    return timestamp_str;
}

+ (NSDate *)dateFromString:(NSString *)aString withFormat:(NSString *)aFromat{
    NSDateFormatter * date = [[NSDateFormatter alloc] init];
    [date setDateFormat:aFromat];
    
    return [date dateFromString:aString];
}


@end


