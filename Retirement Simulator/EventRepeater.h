//
//  EventRepeater.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EventRepeatFrequency;
@class DateHelper;

@interface EventRepeater : NSObject {
    @private
        NSDateFormatter *dateFormatter;
        NSDateComponents *repeatOffsetComponents;
        bool repeatOnce;
        int repeatCount;
        NSDate *startDate;
		NSDate *endDate;
        NSDate *currentDate;
        DateHelper *dateHelper;
    
}


- (id) initWithEventRepeatFrequency:(EventRepeatFrequency*)repeatFrequency 
         andStartDate:(NSDate*)theStartDate andEndDate:(NSDate*)theEndDate;
- (id) initWithRepeatOffset:(NSDateComponents*)theRepeatOffset andRepeatOnce:(bool)doRepeatOnce
	 andStartDate:(NSDate*)theStartDate andEndDate:(NSDate*)theEndDate;

// Helper method for allocating a monthly repeater.
+(EventRepeater*)monthlyEventRepeaterWithStartDate:(NSDate*)startDate
	andEndDate:(NSDate*)endDate;

- (void)reset;
- (NSDate*)nextDate;
- (NSDate*)nextDateOnOrAfterDate:(NSDate*)minimumDate;


@property(nonatomic,retain) NSDate *startDate;
@property(nonatomic,retain) NSDate *endDate;
@property(nonatomic,retain) NSDate *currentDate;
@property(nonatomic,retain) DateHelper *dateHelper;

@end
