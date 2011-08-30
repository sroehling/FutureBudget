//
//  SimEvent.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimEvent.h"
#import "DateHelper.h"
#import "SharedAppValues.h"


@implementation SimEvent

@synthesize originatingEventCreator;
@synthesize eventDate;
@synthesize tieBreakPriority;

- (id) initWithEventCreator:(id<SimEventCreator>)eventCreator andEventDate:(NSDate*)theEventDate {
    self = [super init];
    if (self != nil) {
		assert(eventCreator != nil);
		assert(theEventDate != nil);
		
		// All events must occur on or after the simulatino start date. This is because
		// accounts, cash, etc. have "starting balance" (as of the simulation start date), 
		// such that events only need to be processed after the start date.
		assert([DateHelper dateIsEqualOrLater:theEventDate 
			otherDate:[[SharedAppValues singleton] beginningOfSimStartDate]]);
		
        self.eventDate = theEventDate;
        self.originatingEventCreator = eventCreator;
		
		tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_MEDIUM;
    }
    return self;
}

- (id) init 
{
	assert(0); // must call initWithEventCreator:andEventDate
}

- (void)doSimEvent:(FiscalYearDigest*)digest
{
	assert(0); // must be overridden
}

- (void)dealloc {
    // release owned objects here
    [super dealloc]; 
    [eventDate release];
}

@end
