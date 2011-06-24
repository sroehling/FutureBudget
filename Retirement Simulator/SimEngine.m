//
//  SimEngine.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SimEngine.h"
#import "SimEventCreator.h"
#import "SimEvent.h"


@implementation SimEngine

@synthesize eventCreators;

-(id)init {    
    if((self =[super init]))
    {        
        self.eventCreators =[[[NSMutableArray alloc] init] autorelease];
        
        eventList = [[NSMutableArray alloc] init];
        
        dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        
        gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        resultsOffsetComponents = [[NSDateComponents alloc] init];
        [resultsOffsetComponents setMonth:1];

    }    
    return self;
}


-(void)dealloc {
    [super dealloc];

    [eventCreators release];
   
    [eventList release];
    [dateFormatter release];
    [resultsOffsetComponents release];
    [gregorian release];
    [nextResultsCheckpointDate release];


}


#pragma mark - Private methods for simulator engine

- (void) processEvent: (id<SimEvent>)theEvent
{
    [theEvent doSimEvent];
    id<SimEvent> followOnEvent = [[theEvent originatingEventCreator] nextSimEvent];
    [eventList removeObject:theEvent];
    if(followOnEvent != nil)
    {
        [eventList addObject:followOnEvent];
    }

}


- (id<SimEvent>) nextEventFromEventList
{
    id<SimEvent> nextEventToProcess = nil;
    if ([eventList count] > 0) 
    {
        // Get the event whose next event date is the earliest
        for(id<SimEvent> candidateEvent in eventList)
        {
            if(nextEventToProcess == nil)
            {
                nextEventToProcess = candidateEvent;
            }
            else if([[candidateEvent eventDate] compare:[nextEventToProcess eventDate]] == NSOrderedAscending )
            {
                nextEventToProcess = candidateEvent;
            }
        }
    } // If there's event's left to process
    return nextEventToProcess;
}

- (void) resetSimulator
{
    // Reset the event list
    [eventList removeAllObjects];
    
    // At the beginning of the simulation, iterate through the
    // event creators and have them create their first event.
    // After iteratig through the event list, we'll have a list
    // of events to process.
    NSLog(@"Processing event creators");
    for(id<SimEventCreator> eventCreator in eventCreators)
    {
        [eventCreator resetSimEventCreation];
        
        id<SimEvent> firstEvent = [eventCreator nextSimEvent];
        if(firstEvent != nil)
        {
            [eventList addObject:firstEvent];
        }
    }  
    
    // Initialize the date for the results checkpoint
    NSDate *today = [[NSDate alloc]init];
    nextResultsCheckpointDate = [gregorian dateByAddingComponents:resultsOffsetComponents 
                                                                   toDate:today options:0];
    [nextResultsCheckpointDate retain];
    NSLog(@"First checkpoint date for results: %@",[dateFormatter stringFromDate:nextResultsCheckpointDate]);
    [today release];

}

- (void) generateAndAdvanceResults
{
    // Advance to the nextResultsCheckpointDate
    NSLog(@"Generating checkpoint results: %@",[dateFormatter stringFromDate:nextResultsCheckpointDate]);
    
    NSDate *lastCheckpoint = nextResultsCheckpointDate;
    nextResultsCheckpointDate = [gregorian dateByAddingComponents:resultsOffsetComponents 
                                                           toDate:lastCheckpoint options:0];
    [lastCheckpoint release];
    [nextResultsCheckpointDate retain];

}

- (bool) eventEarlierOrSameTimeAsNextResults: (id<SimEvent>)theEvent
{
    NSComparisonResult eventComparedToResultsCheckpoint = 
    [[theEvent eventDate] compare:nextResultsCheckpointDate];
    
    // Comparison is to determine if the event's time is "not later"
    // than the results checkpoint date.
    if (eventComparedToResultsCheckpoint != NSOrderedDescending) 
    {
        return true;
    }
    else
    {
        return false;
    }

}

#pragma mark - Main simulator engine loop

- (void)runSim
{
    NSLog(@"Running Simulator");
    
    [self resetSimulator];
    
    NSDate *planEndDate = [dateFormatter dateFromString:@"2013-12-31"];
    NSLog(@"Plan end date: %@",[dateFormatter stringFromDate:planEndDate]);
    
    while ([nextResultsCheckpointDate compare:planEndDate] == NSOrderedAscending) 
    {
        id<SimEvent> nextEventToProcess = [self nextEventFromEventList];
                
        if(nextEventToProcess != nil)
        {
            if([self eventEarlierOrSameTimeAsNextResults:nextEventToProcess])
            {
                // Event happens before or at the same time as the next results checkpoint.
                // In this case we process the event before generating the results.
                //
                // Note that other events could also occur before the next checkpoint,
                // so for this iteration of the simulator, we need to just process this
                // one event, then fall out of the loop iteration and go onto the next event.
                [self processEvent:nextEventToProcess];
            }
            else
            {
                // The event occurs after the next results checkpoint. Generate checkpoint
                // results, advance the checkpoint.
                // 
                // Note that the next event could occur more than 1 results interval after
                // the next event. So, to accommodate this potential case, we need
                // to drop out of this loop iteration and re-evaluate the next event w.r.t.
                // the new results checkpoint in the next iteration.
                [self generateAndAdvanceResults];                
            }
        }
        else
        {
            // There's no more events to process. However, there could still be results to process
            // before the end of the plan. In this case, we process the next checkpoint of results 
            // and advance the nextCheckpoint.
            // TBD - How is inflation and/or savings/investment interest handled in this case.
            [self generateAndAdvanceResults];
        }
        
    } // while planEndDate is in the future w.r.t. currentSimDate
     
}

@end
