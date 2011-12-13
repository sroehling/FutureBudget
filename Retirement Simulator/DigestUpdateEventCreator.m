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


- (id) initWithSimStartDate:(NSDate*)simStart
{
	self = [super initWithStartingMonth:12 andStartingDay:31 andSimStartDate:simStart];
	if(self)
	{
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}

- (SimEvent*)createSimEventOnDate:(NSDate *)eventDate
{
	DigestUpdateEvent *theEvent = [[[DigestUpdateEvent alloc]initWithEventCreator:self 
			andEventDate:eventDate ] autorelease];
	theEvent.tieBreakPriority = SIM_EVENT_TIE_BREAK_PRIORITY_LOWEST;
	return theEvent;
}



@end
