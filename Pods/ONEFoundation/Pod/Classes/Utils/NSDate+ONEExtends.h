//
//  NSDate+ONEExtends.h
//  Pods
//
//  Created by zhanghuawei on 16/8/31.
//
//

#import <Foundation/Foundation.h>

@interface NSDate (ONEExtends)

//毫秒时间戳
- (NSString *)one_dateWithMillisecond;
@end

@interface NSDate (ONEHelper1)

- (NSUInteger)one_daysAgoAgainstMidnight;

+ (NSDate *)one_dateFromString:(NSString *)string;
+ (NSDate *)one_dateFromString:(NSString *)string withFormat:(NSString *)format;
+ (NSString *)one_stringFromDate:(NSDate *)date withFormat:(NSString *)string;
+ (NSString *)one_stringFromDate:(NSDate *)date;

- (NSString *)one_string;
- (NSString *)one_stringWithFormat:(NSString *)format;

- (NSDate *)one_beginningOfDay;

+ (NSString *)one_dateFormatString;
+ (NSString *)one_timeFormatString;
+ (NSString *)one_timestampFormatString;

@end

@interface NSDate (ONEHelper)

- (NSDate *)one_dateByAddingSeconds:(NSInteger)seconds;

- (NSString *)one_dateString;

- (NSString *)one_stringWithFormat:(NSString *)format;

// 根据日期字符串和格式，生成日期
+ (NSDate *)one_dateFromString:(NSString *)aString withFormat:(NSString *)aFromat;

@end

@interface NSDate (ONEExtension)

/**
 * 获取日、月、年、小时、分钟、秒
 */
- (NSUInteger)one_day;
- (NSUInteger)one_month;
- (NSUInteger)one_year;
- (NSUInteger)one_hour;
- (NSUInteger)one_minute;
- (NSUInteger)one_second;

/**
 * 返回当前月一共有几周(可能为4,5,6)
 */
- (NSUInteger)one_weeksOfMonth;
+ (NSUInteger)one_weeksOfMonth:(NSDate *)date;

/**
 * 获取该月的第一天的日期
 */
- (NSDate *)one_begindayOfMonth;
+ (NSDate *)one_begindayOfMonth:(NSDate *)date;

/**
 * 获取该月的最后一天的日期
 */
- (NSDate *)one_lastdayOfMonth;
+ (NSDate *)one_lastdayOfMonth:(NSDate *)date;

/**
 * 返回day天后的日期(若day为负数,则为|day|天前的日期)
 */
- (NSDate *)one_dateAfterDay:(NSUInteger)day;
+ (NSDate *)one_dateAfterDate:(NSDate *)date day:(NSInteger)day;

/**
 * 返回day天后的日期(若day为负数,则为|day|天前的日期)
 */
- (NSDate *)one_dateAfterMonth:(NSUInteger)month;
+ (NSDate *)one_dateAfterDate:(NSDate *)date month:(NSInteger)month;

/**
 * 返回numYears年后的日期
 */
- (NSDate *)one_offsetYears:(int)numYears;
+ (NSDate *)one_offsetYears:(int)numYears fromDate:(NSDate *)fromDate;

/**
 * 返回numMonths月后的日期
 */
- (NSDate *)one_offsetMonths:(int)numMonths;
+ (NSDate *)one_offsetMonths:(int)numMonths fromDate:(NSDate *)fromDate;

/**
 * 返回numDays天后的日期
 */
- (NSDate *)one_offsetDays:(int)numDays;
+ (NSDate *)one_offsetDays:(int)numDays fromDate:(NSDate *)fromDate;

/**
 * 返回numHours小时后的日期
 */
- (NSDate *)one_offsetHours:(int)hours;
+ (NSDate *)one_offsetHours:(int)numHours fromDate:(NSDate *)fromDate;

/**
 * 距离该日期前几天
 */
- (NSUInteger)one_daysAgo;
+ (NSUInteger)one_daysAgo:(NSDate *)date;

/**
 *  获取星期几
 *
 *  @return Return weekday number
 *  [1 - Sunday]
 *  [2 - Monday]
 *  [3 - Tuerday]
 *  [4 - Wednesday]
 *  [5 - Thursday]
 *  [6 - Friday]
 *  [7 - Saturday]
 */
- (NSInteger)one_weekday;
+ (NSInteger)one_weekday:(NSDate *)date;

/**
 *  获取星期几(名称)
 *
 *  @return Return weekday as a localized string
 *  [1 - Sunday]
 *  [2 - Monday]
 *  [3 - Tuerday]
 *  [4 - Wednesday]
 *  [5 - Thursday]
 *  [6 - Friday]
 *  [7 - Saturday]
 */
- (NSString *)one_dayFromWeekday;
+ (NSString *)one_dayFromWeekday:(NSDate *)date;

/**
 *  日期是否相等
 *
 *  @param anotherDate The another date to compare as NSDate
 *  @return Return YES if is same day, NO if not
 */
- (BOOL)one_isSameDay:(NSDate *)anotherDate;

/**
 *  是否是今天
 *
 *  @return Return if self is today
 */
- (BOOL)one_isToday;

/**
 *  Add days to self
 *
 *  @param days The number of days to add
 *  @return Return self by adding the gived days number
 */
- (NSDate *)one_dateByAddingDays:(NSUInteger)days;

/**
 *  Get the month as a localized string from the given month number
 *
 *  @param month The month to be converted in string
 *  [1 - January]
 *  [2 - February]
 *  [3 - March]
 *  [4 - April]
 *  [5 - May]
 *  [6 - June]
 *  [7 - July]
 *  [8 - August]
 *  [9 - September]
 *  [10 - October]
 *  [11 - November]
 *  [12 - December]
 *
 *  @return Return the given month as a localized string
 */
+ (NSString *)one_monthWithMonthNumber:(NSInteger)month;

/**
 * 根据日期返回字符串
 */
+ (NSString *)one_stringWithDate:(NSDate *)date format:(NSString *)format;
- (NSString *)one_stringWithFormat:(NSString *)format;
+ (NSDate *)one_dateWithString:(NSString *)string format:(NSString *)format;

@end

#define D_MINUTE	60
#define D_HOUR	3600
#define D_DAY	86400
#define D_WEEK	604800
#define D_YEAR	31556926
@interface NSDate (ONEUtilities)

+ (NSCalendar *) one_currentCalendar; // avoid bottlenecks

// Relative dates from the current date
+ (NSDate *) one_dateTomorrow;
+ (NSDate *) one_dateYesterday;
+ (NSDate *) one_dateWithDaysFromNow: (NSInteger) days;
+ (NSDate *) one_dateWithDaysBeforeNow: (NSInteger) days;
+ (NSDate *) one_dateWithHoursFromNow: (NSInteger) dHours;
+ (NSDate *) one_dateWithHoursBeforeNow: (NSInteger) dHours;
+ (NSDate *) one_dateWithMinutesFromNow: (NSInteger) dMinutes;
+ (NSDate *) one_dateWithMinutesBeforeNow: (NSInteger) dMinutes;

// Short string utilities
- (NSString *) one_stringWithFormat: (NSString *) format;

// Comparing dates
- (BOOL) one_isEqualToDateIgnoringTime: (NSDate *) aDate;

- (BOOL) one_isToday;
- (BOOL) one_isTomorrow;
- (BOOL) one_isYesterday;

- (BOOL) one_isSameWeekAsDate: (NSDate *) aDate;
- (BOOL) one_isThisWeek;
- (BOOL) one_isNextWeek;
- (BOOL) one_isLastWeek;

- (BOOL) one_isSameMonthAsDate: (NSDate *) aDate;
- (BOOL) one_isThisMonth;
- (BOOL) one_isNextMonth;
- (BOOL) one_isLastMonth;

- (BOOL) one_isSameYearAsDate: (NSDate *) aDate;
- (BOOL) one_isThisYear;
- (BOOL) one_isNextYear;
- (BOOL) one_isLastYear;

- (BOOL) one_isEarlierThanDate: (NSDate *) aDate;
- (BOOL) one_isLaterThanDate: (NSDate *) aDate;

- (BOOL) one_isInFuture;
- (BOOL) one_isInPast;

// Date roles
- (BOOL) one_isTypicallyWorkday;
- (BOOL) one_isTypicallyWeekend;

// Adjusting dates
- (NSDate *) one_dateByAddingYears: (NSInteger) dYears;
- (NSDate *) one_dateBySubtractingYears: (NSInteger) dYears;
- (NSDate *) one_dateByAddingMonths: (NSInteger) dMonths;
- (NSDate *) one_dateBySubtractingMonths: (NSInteger) dMonths;
- (NSDate *) one_dateByAddingDays: (NSInteger) dDays;
- (NSDate *) one_dateBySubtractingDays: (NSInteger) dDays;
- (NSDate *) one_dateByAddingHours: (NSInteger) dHours;
- (NSDate *) one_dateByAddingMinutes: (NSInteger) dMinutes;
- (NSDate *) one_dateBySubtractingMinutes: (NSInteger) dMinutes;

// Date extremes
- (NSDate *) one_dateAtStartOfDay;
- (NSDate *) one_dateAtEndOfDay;

// Retrieving intervals
- (NSInteger) one_minutesAfterDate: (NSDate *) aDate;
- (NSInteger) one_minutesBeforeDate: (NSDate *) aDate;
- (NSInteger) one_hoursAfterDate: (NSDate *) aDate;
- (NSInteger) one_hoursBeforeDate: (NSDate *) aDate;
- (NSInteger) one_daysAfterDate: (NSDate *) aDate;
- (NSInteger) one_daysBeforeDate: (NSDate *) aDate;
- (NSInteger) one_distanceInDaysToDate:(NSDate *)anotherDate;

// Decomposing dates
@property (readonly) NSInteger one_nearestHour;
@property (readonly) NSInteger one_hour;
@property (readonly) NSInteger one_minute;
@property (readonly) NSInteger one_seconds;
@property (readonly) NSInteger one_day;
@property (readonly) NSInteger one_month;
@property (readonly) NSInteger one_week;
@property (readonly) NSInteger one_weekday;
@property (readonly) NSInteger one_year;

@end
