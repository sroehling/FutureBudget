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
        NSDate *currentDate;
    
}


- (id) initWithEventRepeatFrequency:(EventRepeatFrequency*)repeatFrequency 
                        andStartDate:(NSDate*)theStartDate;
- (void)reset;
- (NSDate*)nextDate;

@end
