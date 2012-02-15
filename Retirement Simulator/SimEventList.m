//
//  SimEventList.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimEventList.h"
#import "SimEvent.h"


@implementation SimEventList

@synthesize eventList;

-(id)init
{
	self = [super init];
	if(self)
	{
		self.eventList = [[[NSMutableArray alloc] init]autorelease];
	}
	return self;
}

-(void)addEvent:(SimEvent*)newEvent
{
	assert(newEvent != nil);
	[self.eventList addObject:newEvent];
}

- (void)removeAllEvents
{
	[self.eventList removeAllObjects];
}

-(SimEvent*)nextEvent
{
    SimEvent* nextEventToProcess = nil;
	NSUInteger nextEventIndex = 0;
	
    if ([eventList count] > 0) 
    {
        // Get the event whose next event date is the earliest
		for(NSUInteger eventIndex = 0; eventIndex < [eventList count]; eventIndex++)
		{
			SimEvent *candidateEvent = [eventList objectAtIndex:eventIndex];
			assert(candidateEvent != nil);
			
            if(nextEventToProcess == nil)
            {
                nextEventToProcess = candidateEvent;
				nextEventIndex = eventIndex;
            }
// TODO - For comparison purposes, need to keep the granularity of the comparison at the day level, then use tie breaking priority.
            else if([[candidateEvent eventDate] compare:[nextEventToProcess eventDate]] == NSOrderedAscending )
            {
				// The date/time of candidateEvent is sooner than the nextEventToProcess
				nextEventToProcess = candidateEvent;
				nextEventIndex = eventIndex;
             }
			else if([[candidateEvent eventDate] compare:[nextEventToProcess eventDate]] == NSOrderedSame)
			{
				if(candidateEvent.tieBreakPriority > nextEventToProcess.tieBreakPriority)
				{
					// The date/time of candidateEvent is the same as nextEventToProcess,
					// but candidateEvent has a higher tie break priority, so should occur first
					nextEventToProcess = candidateEvent;
					nextEventIndex = eventIndex;
				}
			}
			
		}
     } // If there's event's left to process
	if(nextEventToProcess != nil)
	{
		[nextEventToProcess retain];
		[self.eventList removeObjectAtIndex:nextEventIndex];
		[nextEventToProcess autorelease];
	}
    return nextEventToProcess;

}

- (void)dealloc
{
	[eventList release];
	[super dealloc];
}

@end
