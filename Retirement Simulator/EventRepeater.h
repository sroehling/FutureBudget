//
//  EventRepeater.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EventRepeatFrequency;

@interface EventRepeater : NSObject {
    @private
        NSDateFormatter *dateFormatter;
        NSDateComponents *repeatOffsetComponents;
        bool repeatOnce;
        int repeatCount;
        NSDate *startDate;
		NSDate *endDate;
        NSDate *currentDate;
    
}


- (id) initWithEventRepeatFrequency:(EventRepeatFrequency*)repeatFrequency 
         andStartDate:(NSDate*)theStartDate andEndDate:(NSDate*)theEndDate;
- (id) initWithRepeatOffset:(NSDateComponents*)theRepeatOffset andRepeatOnce:(bool)doRepeatOnce
	 andStartDate:(NSDate*)theStartDate andEndDate:(NSDate*)theEndDate;
- (void)reset;
- (NSDate*)nextDate;
- (NSDate*)nextDateOnOrAfterDate:(NSDate*)minimumDate;


@property(nonatomic,retain) NSDate *startDate;
@property(nonatomic,retain) NSDate *endDate;
@property(nonatomic,retain) NSDate *currentDate;

@end
