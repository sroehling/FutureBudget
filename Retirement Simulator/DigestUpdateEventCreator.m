//
//  DigestUpdateEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DigestUpdateEventCreator.h"
#import "DateHelper.h"
#import "EventRepeater.h"
#import "SharedAppValues.h"
#import "DigestUpdateEvent.h"
#import "NeverEndDate.h"

@implementation DigestUpdateEventCreator

@synthesize digestStartDate;
@synthesize updateEventRepeater;

- (id) init
{
	self = [super init];
	if(self)
	{
		// TODO - Should the first update date be the end of 12-31
#warning Need to make sure digestStartDate is the very last second of the year, so that no events on 12/31 will come after it.
		self.digestStartDate = [DateHelper endOfYear:[SharedAppValues singleton].simStartDate];;
		NSDateComponents *repeatYearly = [[[NSDateComponents alloc] init] autorelease];
		[repeatYearly setYear:1];
		
		NSDate *neverEndDate = [DateHelper dateFromStr:NEVER_END_PSEUDO_END_DATE];
		self.updateEventRepeater = [[[EventRepeater alloc] initWithRepeatOffset:repeatYearly andRepeatOnce:false 
			andStartDate:self.digestStartDate andEndDate:neverEndDate] autorelease];
	}
	return self;
}


- (void) dealloc
{
	[super dealloc];
	[updateEventRepeater release];
	[digestStartDate release];
}


- (void)resetSimEventCreation
{
	[self.updateEventRepeater reset];
}

- (SimEvent*)nextSimEvent
{
    NSDate *nextDate = [self.updateEventRepeater nextDate];
    if(nextDate !=nil)
    {
        DigestUpdateEvent *theEvent = [[DigestUpdateEvent alloc]initWithEventCreator:self 
			andEventDate:nextDate ];
		return theEvent;
    }
    else
    {
        return nil;
    }

}

@end
