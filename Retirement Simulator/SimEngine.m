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
#import "LoanInput.h"
#import "InterestBearingWorkingBalance.h"
#import "IncomeSimEventCreator.h"
#import "SavingsAccount.h"
#import "BoolInputValue.h"
#import "SavingsContributionSimEventCreator.h"
#import "SimInputHelper.h"

#import "EstimatedTaxAccrualSimEventCreator.h"
#import "EstimatedTaxPaymentSimEventCreator.h"
#import "SimParams.h"
#import "LoanPaymentSimEventCreator.h"
#import "SimEventList.h"
#import "DefaultScenario.h"
#import "WorkingBalanceCltn.h"
#import "MultiScenarioInputValue.h"
#import "DownPaymentSimEventCreator.h"
#import "ExtraPaymentSimEventCreator.h"
#import "LoanSimInfo.h"

@implementation SimEngine

@synthesize eventCreators;
@synthesize simEndDate;
@synthesize digest;
@synthesize workingBalanceMgr;
@synthesize eventList;
@synthesize simParams;


-(id)init {    
    if((self =[super init]))
    {        
    }    
    return self;
}


-(void)dealloc {
    [super dealloc];
    [eventCreators release];
	[workingBalanceMgr release];
	[simEndDate release];   
    [eventList release];
	[simParams release];
	[digest release];
}


- (void) populateEventCreators
{
	self.eventCreators =[[[NSMutableArray alloc] init] autorelease];
	[self.eventCreators addObject:[[[DigestUpdateEventCreator alloc] init] autorelease]];

	NSSet *inputs = [[DataModelController theDataModelController] fetchObjectsForEntityName:INCOME_INPUT_ENTITY_NAME];
	for(IncomeInput *income in inputs)
	{
		assert(income!=nil);
		if([SimInputHelper multiScenBoolVal:income.multiScenarioCashFlowEnabled 
				andScenario:simParams.simScenario])
		{
			[self.eventCreators addObject:
				[[[IncomeSimEventCreator alloc]initWithIncome:income] autorelease]];
		}
	}

	
	inputs = [[DataModelController theDataModelController] fetchObjectsForEntityName:EXPENSE_INPUT_ENTITY_NAME];
    for(ExpenseInput *expense in inputs)
    {    
		assert(expense != nil);
		if([SimInputHelper multiScenBoolVal:expense.multiScenarioCashFlowEnabled
				andScenario:simParams.simScenario])
		{
			[self.eventCreators addObject:
				[[[ExpenseSimEventCreator alloc]initWithExpense:expense] autorelease]];
		}
    }

		
	inputs = [[DataModelController theDataModelController] fetchObjectsForEntityName:SAVINGS_ACCOUNT_ENTITY_NAME];
		for(SavingsAccount *savingsAcct in inputs)
	{
		InterestBearingWorkingBalance *savingsBal = 
			[[[InterestBearingWorkingBalance alloc] initWithSavingsAcct:savingsAcct] autorelease];
		if([SimInputHelper multiScenBoolVal:savingsAcct.multiScenarioContribEnabled
				andScenario:simParams.simScenario])
		{
			SavingsContributionSimEventCreator *savingsEventCreator = 
				[[[SavingsContributionSimEventCreator alloc]
					initWithSavingsWorkingBalance:savingsBal 
					andSavingsAcct:savingsAcct] autorelease];
			[self.eventCreators addObject:savingsEventCreator];
			[self.workingBalanceMgr.fundingSources addBalance:savingsBal];
		}
	}
	
	
	inputs = [[DataModelController theDataModelController] fetchObjectsForEntityName:LOAN_INPUT_ENTITY_NAME];
	for(LoanInput *loan in inputs)
	{
		if([SimInputHelper multiScenBoolVal:loan.multiScenarioLoanEnabled
				andScenario:simParams.simScenario])
		{
		
			LoanSimInfo *loanInfo = [[[LoanSimInfo alloc]initWithLoan:loan 
				andSimParams:self.simParams]autorelease];
			
			LoanPaymentSimEventCreator *loanPmtEventCreator = 
				[[[LoanPaymentSimEventCreator alloc] initWithLoanInfo:loanInfo] autorelease];
			[self.eventCreators addObject:loanPmtEventCreator];
			
			if([SimInputHelper multiScenBoolVal:loan.multiScenarioDownPmtEnabled
					andScenario:simParams.simScenario])
			{
				DownPaymentSimEventCreator *downPmtCreator = [[[DownPaymentSimEventCreator alloc]
					initWithLoanInfo:loanInfo] autorelease];
				[self.eventCreators addObject:downPmtCreator];
			}
			
			if([SimInputHelper multiScenBoolVal:loan.multiScenarioExtraPmtEnabled
				andScenario:simParams.simScenario])
			{
				ExtraPaymentSimEventCreator *extraPmtCreator = [[[ExtraPaymentSimEventCreator alloc]
					initWithLoanInfo:loanInfo] autorelease];
				[self.eventCreators addObject:extraPmtCreator];
			}

			[self.workingBalanceMgr.loanBalances addBalance:loanInfo.loanBalance];


		}
		
	}
	
	
	[self.eventCreators addObject:[[[EstimatedTaxAccrualSimEventCreator alloc] 
		initWithStartingMonth:3 andStartingDay:31] autorelease]];
	[self.eventCreators addObject:[[[EstimatedTaxAccrualSimEventCreator alloc] 
		initWithStartingMonth:5 andStartingDay:31] autorelease]];
	[self.eventCreators addObject:[[[EstimatedTaxAccrualSimEventCreator alloc] 
		initWithStartingMonth:8 andStartingDay:31] autorelease]];
	[self.eventCreators addObject:[[[EstimatedTaxAccrualSimEventCreator alloc] 
		initWithStartingMonth:12 andStartingDay:31] autorelease]];

	[self.eventCreators addObject:[[[EstimatedTaxPaymentSimEventCreator alloc] initWithStartingMonth:4 andStartingDay:15] autorelease]];
	[self.eventCreators addObject:[[[EstimatedTaxPaymentSimEventCreator alloc] initWithStartingMonth:6 andStartingDay:15] autorelease]];
	[self.eventCreators addObject:[[[EstimatedTaxPaymentSimEventCreator alloc] initWithStartingMonth:9 andStartingDay:15] autorelease]];
	[self.eventCreators addObject:[[[EstimatedTaxPaymentSimEventCreator alloc] initWithStartingMonth:1 andStartingDay:15] autorelease]];
}


- (void) resetSimulator
{
    // Reset the event list
	self.eventList = [[[SimEventList alloc] init] autorelease];
	
	NSDate *simStartDate = [[SharedAppValues singleton] beginningOfSimStartDate];
	self.simParams = [[[SimParams alloc] 
			initWithStartDate:simStartDate 
			andScenario:[SharedAppValues singleton].defaultScenario] autorelease];

	
	
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
            [eventList addEvent:firstEvent];
        }
    }  
    
    // Initialize the date for the results checkpoint

	assert(simStartDate != nil);
	
	
	self.digest = [[[FiscalYearDigest alloc] initWithStartDate:digestStartDate andWorkingBalances:self.workingBalanceMgr] autorelease];
}

#pragma mark - Private methods for simulator engine

- (void) processEvent: (SimEvent*)theEvent
{
    [theEvent doSimEvent:self.digest];
    SimEvent *followOnEvent = [[theEvent originatingEventCreator] nextSimEvent];
    if(followOnEvent != nil)
    {
        [eventList addEvent:followOnEvent];
    }

}



- (bool) eventEarlierOrSameTimeAsSimEnd: (SimEvent*)theEvent
{
    NSComparisonResult eventComparedToSimEnd = 
    [[theEvent eventDate] compare:self.simEndDate];
    
    // Comparison is to determine if the event's time is "not later"
    // than the results checkpoint date.
    if (eventComparedToSimEnd != NSOrderedDescending) 
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
    
	SimEvent* nextEventToProcess = [self.eventList nextEvent];
    while ((nextEventToProcess != nil) &&
		[self eventEarlierOrSameTimeAsSimEnd:nextEventToProcess]) 
    {
		[self processEvent:nextEventToProcess];
		nextEventToProcess = [self.eventList nextEvent];
    } // while planEndDate is in the future w.r.t. currentSimDate
     
}

@end
