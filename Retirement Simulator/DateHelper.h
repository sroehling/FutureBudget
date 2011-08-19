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
+ (NSDate*)beginningOfDay:(NSDate*)theDate;
+ (NSDate*)beginningOfNextYear:(NSDate*)dateWithinPreviousYear;
+ (NSDate*)nextDay:(NSDate*)currentDay;
+ (NSDate*)endOfYear:(NSDate*)dateWithinYear;

+ (bool)dateIsEqualOrLater:(NSDate*)theDate otherDate:(NSDate*)comparisonDate;

@property(nonatomic,retain)  NSDateFormatter *mediumDateFormatter;
@property(nonatomic,retain) NSDateFormatter *longDateFormatter;
@property(nonatomic,retain) NSCalendar *gregorian;

+ (NSDate*)today;

@end
