//
//  DateHelper.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SECONDS_PER_DAY 86400

@interface DateHelper : NSObject {
    @private
        NSDateFormatter *mediumDateFormatter;
}

+(DateHelper*)theHelper; // singleton

+ (NSDate*)dateFromStr:(NSString*)dateStr;
+ (NSString*)stringFromDate:(NSDate*)theDate;


@property(nonatomic,retain)  NSDateFormatter *mediumDateFormatter;

+ (NSDate*)today;

@end
