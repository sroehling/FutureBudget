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
#import "SharedAppValues.h"
#import "SimDate.h"
#import "FiscalYearDigest.h"
#import "DateHelper.h"
#import "DigestUpdateEventCreator.h"
#import "DataModelController.h"
#import "WorkingBalanceMgr.h"
#import "ExpenseInput.h"
#import "IncomeInput.h"
#import "ExpenseSimEventCreator.h"
#import "SavingsWorkingBalance.h"
#import "IncomeSimEventCreator.h"
#import "SavingsAccount.h"
#import "SavingsContributionSimEventCreator.h"

@implementation SimEngine

@synthesize eventCreators;
@synthesize simEndDate;
@synthesize digest;
@synthesize workingBalanceMgr;


-(id)init {    
    if((self =[super init]))
    {        
        eventList = [[NSMutableArray alloc] init];
		
        resultsOffsetComponents = [[NSDateComponents alloc] init];
        [resultsOffsetComponents setMonth:1];
    }    
    return self;
}


-(void)dealloc {
    [super dealloc];

    [eventCreators release];
	[workingBalanceMgr release];
	[simEndDate release];
   
    [eventList release];
    [resultsOffsetComponents release];
    [nextResultsCheckpointDate release];
	[digest release];

}


#pragma mark - Private methods for simulator engine

- (void) processEvent: (SimEvent*)theEvent
{
    [theEvent doSimEvent:self.digest];
    SimEvent *followOnEvent = [[theEvent originatingEventCreator] nextSimEvent];
    [eventList removeObject:theEvent];
    if(followOnEvent != nil)
    {
        [eventList addObject:followOnEvent];
    }

}


- (SimEvent*) nextEventFromEventList
{
    SimEvent* nextEventToProcess = nil;
    if ([eventList count] > 0) 
    {
        // Get the event whose next event date is the earliest
        for(SimEvent* candidateEvent in eventList)
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

- (void) populateEventCreators
{
	self.eventCreators =[[[NSMutableArray alloc] init] autorelease];
	[self.eventCreators addObject:[[[DigestUpdateEventCreator alloc] init] autorelease]];

	NSSet *inputs = [[DataModelController theDataModelController] fetchObjectsForEntityName:INCOME_INPUT_ENTITY_NAME];
	for(IncomeInput *income in inputs)
	{
		assert(income!=nil);
		[self.eventCreators addObject:
			[[[IncomeSimEventCreator alloc]initWithIncome:income] autorelease]];
	}

	
	inputs = [[DataModelController theDataModelController] fetchObjectsForEntityName:EXPENSE_INPUT_ENTITY_NAME];
    for(ExpenseInput *expense in inputs)
    {    
		assert(expense != nil);
		[self.eventCreators addObject:
			[[[ExpenseSimEventCreator alloc]initWithExpense:expense] autorelease]];
    }

		
	inputs = [[DataModelController theDataModelController] fetchObjectsForEntityName:SAVINGS_ACCOUNT_ENTITY_NAME];
		for(SavingsAccount *savingsAcct in inputs)
	{
		SavingsWorkingBalance *savingsBal = 
			[[[SavingsWorkingBalance alloc] initWithSavingsAcct:savingsAcct] autorelease];
		SavingsContributionSimEventCreator *savingsEventCreator = 
			[[[SavingsContributionSimEventCreator alloc]
				initWithSavingsWorkingBalance:savingsBal 
				andSavingsAcct:savingsAcct] autorelease];
		[self.eventCreators addObject:savingsEventCreator];
		[self.workingBalanceMgr addFundingSource:savingsBal];
	}

	

}


- (void) resetSimulator
{
    // Reset the event list
    [eventList removeAllObjects];
	
    NSDate *simStartDate = [DateHelper beginningOfDay:[SharedAppValues singleton].simStartDate];
	NSLog(@"Simulation Start: %@",[[DateHelper theHelper].mediumDateFormatter stringFromDate:simStartDate]);
	NSDate *digestStartDate = [DateHelper beginningOfYear:simStartDate];
	self.simEndDate = [[SharedAppValues singleton].simEndDate endDateWithStartDate:simStartDate];

	
	self.workingBalanceMgr = [[[WorkingBalanceMgr alloc] initWithStartDate:digestStartDate] autorelease];
		
	[self populateEventCreators];
	
	NSLog(@"Initial working balances ...");
	[self.workingBalanceMgr logCurrentBalances];
    
    // At the beginning of the simulation, iterate through the
    // event creators and have them create their first event.
    // After iteratig through the event list, we'll have a list
    // of events to process.
    NSLog(@"Processing event creators");
    for(id<SimEventCreator> eventCreator in eventCreators)
    {
        [eventCreator resetSimEventCreation];
        
        SimEvent *firstEvent = [eventCreator nextSimEvent];
        if(firstEvent != nil)
        {
            [eventList addObject:firstEvent];
        }
    }  
    
    // Initialize the date for the results checkpoint

	assert(simStartDate != nil);
    nextResultsCheckpointDate = [[DateHelper theHelper].gregorian
			dateByAddingComponents:resultsOffsetComponents 
             toDate:simStartDate options:0];
    [nextResultsCheckpointDate retain];
	
	
	self.digest = [[[FiscalYearDigest alloc] initWithStartDate:digestStartDate andWorkingBalances:self.workingBalanceMgr] autorelease];

	
    NSLog(@"First checkpoint date for results: %@",[[DateHelper theHelper].mediumDateFormatter stringFromDate:nextResultsCheckpointDate]);

}

- (void) generateAndAdvanceResults
{
    // Advance to the nextResultsCheckpointDate
    NSLog(@"Generating checkpoint results: %@",[[DateHelper theHelper].mediumDateFormatter stringFromDate:nextResultsCheckpointDate]);
    
    NSDate *lastCheckpoint = nextResultsCheckpointDate;
    nextResultsCheckpointDate = [[DateHelper theHelper].gregorian dateByAddingComponents:resultsOffsetComponents 
                                                           toDate:lastCheckpoint options:0];
    [lastCheckpoint release];
    [nextResultsCheckpointDate retain];

}

- (bool) eventEarlierOrSameTimeAsNextResults: (SimEvent*)theEvent
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
    
    NSLog(@"Plan end date: %@",[[DateHelper theHelper].mediumDateFormatter stringFromDate:self.simEndDate]);
    
    while ([nextResultsCheckpointDate compare:self.simEndDate] == NSOrderedAscending) 
    {
        SimEvent* nextEventToProcess = [self nextEventFromEventList];
                
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
