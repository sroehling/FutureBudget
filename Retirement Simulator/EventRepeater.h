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
        NSCalendar *gregorian;
        NSDateComponents *repeatOffsetComponents;
        bool repeatOnce;
        int repeatCount;
        NSDate *startDate;
		NSDate *endDate;
        NSDate *currentDate;
    
}


- (id) initWithEventRepeatFrequency:(EventRepeatFrequency*)repeatFrequency 
         andStartDate:(NSDate*)theStartDate andEndDate:(NSDate*)theEndDate;
- (void)reset;
- (NSDate*)nextDate;


@property(nonatomic,retain) NSDate *startDate;
@property(nonatomic,retain) NSDate *endDate;
@property(nonatomic,retain) NSDate *currentDate;

@end
