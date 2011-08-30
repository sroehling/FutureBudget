//
//  DigestUpdateEventCreator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "DigestUpdateEventCreator.h"
#import "DigestUpdateEvent.h"


@implementation DigestUpdateEventCreator


- (id) init
{
	self = [super initWithStartingMonth:12 andStartingDay:31];
	if(self)
	{
	}
	return self;
}

- (SimEvent*)createSimEventOnDate:(NSDate *)eventDate
{
	DigestUpdateEvent *theEvent = [[[DigestUpdateEvent alloc]initWithEventCreator:self 
			andEventDate:eventDate ] autorelease];
	theEvent.tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_LOWEST;
	return theEvent;
}



@end
