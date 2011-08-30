//
//  YearlySimEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YearlySimEventCreator.h"
#import "EventRepeater.h"
#import "SharedAppValues.h"
#import "DateHelper.h"
#import "NeverEndDate.h"

@implementation YearlySimEventCreator

@synthesize yearlyEventRepeater;

- (void)dealloc
{
	[super dealloc];
	[yearlyEventRepeater release];
}

- (id) initWithStartingMonth:(NSInteger)monthNum andStartingDay:(NSInteger)dayNum
{
	self = [super init];
	if(self)
	{
		NSDate *simStartDate = [SharedAppValues singleton].simStartDate;
		NSDate *startDate = [DateHelper sameYearDifferentDay:simStartDate 
			andMonth:monthNum andDay:dayNum];
		NSDateComponents *repeatYearly = [[[NSDateComponents alloc] init] autorelease];
		[repeatYearly setYear:1];
		NSDate *neverEndDate = [DateHelper dateFromStr:NEVER_END_PSEUDO_END_DATE];
		self.yearlyEventRepeater = [[[EventRepeater alloc] initWithRepeatOffset:repeatYearly andRepeatOnce:false 
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
	[self.yearlyEventRepeater reset];
}

- (SimEvent*)createSimEventOnDate:(NSDate*)eventDate
{
	assert(0); // must be overridden
	return nil;
}

- (SimEvent*)nextSimEvent
{
    NSDate *nextDate = [self.yearlyEventRepeater nextDateOnOrAfterDate:
		[[SharedAppValues singleton] beginningOfSimStartDate]];
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
