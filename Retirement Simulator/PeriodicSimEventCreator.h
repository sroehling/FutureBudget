//
//  PeriodicSimEventCreator.h
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/13.
//
//

#import <Foundation/Foundation.h>

#import "SimEventCreator.h"
#import "EventRepeatFrequency.h"

@class EventRepeater;


@interface PeriodicSimEventCreator : NSObject <SimEventCreator>
{
    @private
		EventRepeater *periodicEventRepeater;
		NSDate *simStartDate;
}

@property(nonatomic,retain) EventRepeater *periodicEventRepeater;
@property(nonatomic,retain) NSDate *simStartDate;

- (id) initWithStartingMonth:(NSInteger)monthNum andStartingDay:(NSInteger)dayNum
	andSimStartDate:(NSDate*)simStart andPeriod:(EventPeriod)periodEnum;

@end
