//
//  DateHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SECONDS_PER_DAY 86400
#define MAX_DAYS_IN_YEAR 366

@interface DateHelper : NSObject {
    @private
        NSDateFormatter *mediumDateFormatter;
        NSDateFormatter *longDateFormatter;
		NSCalendar *gregorian;
}

+(DateHelper*)theHelper; // singleton

+ (NSDate*)dateFromStr:(NSString*)dateStr;
+ (NSString*)stringFromDate:(NSDate*)theDate;
+ (NSDate*)beginningOfYear:(NSDate*)dateWithinYear;
+ (NSDate*)sameYearDifferentDay:(NSDate*)dateWithinYear andMonth:(NSInteger)monthNum andDay:(NSInteger)dayNum;
+ (NSDate*)beginningOfDay:(NSDate*)theDate;
+ (NSDate*)endOfDay:(NSDate*)theDate;
+ (NSInteger)daysOffset:(NSDate*)theDate vsEarlierDate:(NSDate*)otherDate;
+ (NSDate*)beginningOfNextYear:(NSDate*)dateWithinPreviousYear;
+ (NSDate*)nextDay:(NSDate*)currentDay;
+ (NSDate*)endOfYear:(NSDate*)dateWithinYear;
+ (NSInteger)yearOfDate:(NSDate*)dateWithinYear;

+ (bool)dateIsEqualOrLater:(NSDate*)theDate otherDate:(NSDate*)comparisonDate;
+ (bool)dateIsLater:(NSDate*)theDate otherDate:(NSDate*)comparisonDate;
+ (bool)dateIsEqual:(NSDate*)theDate otherDate:(NSDate*)comparisonDate;

@property(nonatomic,retain)  NSDateFormatter *mediumDateFormatter;
@property(nonatomic,retain) NSDateFormatter *longDateFormatter;
@property(nonatomic,retain) NSCalendar *gregorian;

+ (NSDate*)today;

@end
