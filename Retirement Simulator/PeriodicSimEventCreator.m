//
//  PeriodicSimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/3/13.
//
//

#import "PeriodicSimEventCreator.h"
#import "DateHelper.h"
#import "NeverEndDate.h"
#import "EventRepeater.h"
#import "EventRepeatFrequency.h"

@implementation PeriodicSimEventCreator

@synthesize periodicEventRepeater;
@synthesize simStartDate;

- (void)dealloc
{
	[periodicEventRepeater release];
	[simStartDate release];
	[super dealloc];
}

- (id) initWithStartingMonth:(NSInteger)monthNum andStartingDay:(NSInteger)dayNum
	andSimStartDate:(NSDate*)simStart andPeriod:(EventPeriod)periodEnum
{
	self = [super init];
	if(self)
	{
        DateHelper *dateHelperForInit = [[[DateHelper alloc] init] autorelease];
        
		self.simStartDate = simStart;
		NSDate *startDate = [dateHelperForInit sameYearDifferentDay:simStartDate 
			andMonth:monthNum andDay:dayNum];
		NSDate *neverEndDate = [dateHelperForInit dateFromStr:NEVER_END_PSEUDO_END_DATE];
			
		NSDateComponents *periodicRepeat = [EventRepeatFrequency periodicDateComponentFromPeriod:periodEnum];
		
		self.periodicEventRepeater = [[[EventRepeater alloc] initWithRepeatOffset:periodicRepeat andRepeatOnce:false 
			andStartDate:startDate andEndDate:neverEndDate] autorelease];
	}
	return self;
}

- (id)init
{
	assert(0); // must call with starting month and day
	return nil;
}

- (void)resetSimEventCreation
{
	[self.periodicEventRepeater reset];
}

- (SimEvent*)createSimEventOnDate:(NSDate*)eventDate
{
	assert(0); // must be overridden
	return nil;
}

- (SimEvent*)nextSimEvent
{
    NSDate *nextDate = [self.periodicEventRepeater nextDateOnOrAfterDate:self.simStartDate];
    if(nextDate !=nil)
    {
        return [self createSimEventOnDate:nextDate];
    }
    else
    {
        return nil;
    }

}

@end
