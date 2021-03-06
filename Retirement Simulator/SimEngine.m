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
#import "PeriodicInterestBearingWorkingBalance.h"
#import "AccountWorkingBalance.h"
#import "IncomeSimEventCreator.h"
#import "IncomeSimInfo.h"
#import "Account.h"
#import "BoolInputValue.h"
#import "AccountContribSimEventCreator.h"
#import "SimInputHelper.h"

#import "SimParams.h"
#import "LoanPaymentSimEventCreator.h"
#import "LoanEarlyPayoffSimEventCreator.h"
#import "SimEventList.h"
#import "DefaultScenario.h"

#import "WorkingBalanceCltn.h"
#import "MultiScenarioInputValue.h"
#import "LoanOrigSimEventCreator.h"
#import "LoanSimInfo.h"

#import "AssetInput.h"
#import "AssetSimInfo.h"
#import "AssetPurchaseSimEventCreator.h"
#import "AssetSaleSimEventCreator.h"
#import "ExpenseSimInfo.h"

#import "TransferInput.h"
#import "TransferSimInfo.h"
#import "TransferSimEventCreator.h"

#import "TaxInput.h"
#import "TaxInputCalc.h"

#import "SimInputHelper.h"
#import "MultiScenarioSimDate.h"

#import "InputSimInfoCltn.h"
#import "TaxInputCalc.h"
#import "TaxInputCalcs.h"

#import "AccountSimInfo.h"

#import "DataModelController.h"
#import "AccountDividendSimEventCreator.h"
#import "ProgressUpdateDelegate.h"

#define UPDATE_SIM_PROGRESS_THRESHOLD 0.005

@implementation SimEngine

@synthesize eventCreators;
@synthesize digest;
@synthesize eventList;
@synthesize simParams;
@synthesize dataModelController;
@synthesize sharedAppVals;
@synthesize simExecutionOperation;

- (id)initWithDataModelController:(DataModelController*)theDataModelController
	andSharedAppValues:(SharedAppValues*)theSharedAppVals
{
    if((self =[super init]))
    {
		assert(theDataModelController != nil);
		self.dataModelController = theDataModelController;
		
		assert(theSharedAppVals != nil);
		self.sharedAppVals = theSharedAppVals;
    }    
    return self;

}

-(id)init {    
	assert(0); // must init with data model controller
	return nil;
}


-(void)dealloc {
    [eventCreators release]; 
    [eventList release];
	[simParams release];
	[digest release];
	[dataModelController release];
   [super dealloc];
 }


- (void) populateEventCreators
{
	self.eventCreators =[[[NSMutableArray alloc] init] autorelease];
	[self.eventCreators addObject:[[[DigestUpdateEventCreator alloc] initWithSimStartDate:self.simParams.simStartDate] autorelease]];

	NSSet *inputs = [self.dataModelController fetchObjectsForEntityName:INCOME_INPUT_ENTITY_NAME];
	for(IncomeInput *income in inputs)
	{
		assert(income!=nil);
		if([SimInputHelper multiScenBoolVal:income.cashFlowEnabled 
				andScenario:simParams.simScenario])
		{
 
			IncomeSimInfo *incomeSimInfo = [[[IncomeSimInfo alloc] initWithIncome:income
				andSimParams:self.simParams] autorelease];
			[self.simParams.incomeInfo addSimInfo:income withSimInfo:incomeSimInfo];
			
			[self.eventCreators addObject:
				[[[IncomeSimEventCreator alloc] initWithIncomeSimInfo:incomeSimInfo] autorelease]];
		}
	}

	
	inputs = [self.dataModelController fetchObjectsForEntityName:EXPENSE_INPUT_ENTITY_NAME];
    for(ExpenseInput *expense in inputs)
    {    
		assert(expense != nil);
		if([SimInputHelper multiScenBoolVal:expense.cashFlowEnabled
				andScenario:simParams.simScenario])
		{
			ExpenseSimInfo *expenseInfo = [[[ExpenseSimInfo alloc] initWithExpense:expense
				andSimParams:self.simParams] autorelease]; 
			[self.simParams.expenseInfo addSimInfo:expense withSimInfo:expenseInfo];
			
			[self.eventCreators addObject:
				[[[ExpenseSimEventCreator alloc]initWithExpenseInfo:expenseInfo] autorelease]];
		}
    }

		
	inputs = [self.dataModelController fetchObjectsForEntityName:ACCOUNT_ENTITY_NAME];
	for(Account *acct in inputs)
	{
	
		AccountSimInfo *acctSimInfo = 
			[[[AccountSimInfo alloc] initWithAcct:acct
				andSimParams:self.simParams] autorelease];
		[self.simParams.acctInfo addSimInfo:acct withSimInfo:acctSimInfo];
			
		if([SimInputHelper multiScenBoolVal:acct.contribEnabled
				andScenario:simParams.simScenario])
		{
			AccountContribSimEventCreator *savingsEventCreator = 
				[[[AccountContribSimEventCreator alloc]
					initWithAcctSimInfo:acctSimInfo]autorelease];
			[self.eventCreators addObject:savingsEventCreator];
		}
	
		if([SimInputHelper multiScenBoolVal:acct.dividendEnabled
				andScenario:simParams.simScenario])
		{
			AccountDividendSimEventCreator *dividendEventCreator =
				[[[AccountDividendSimEventCreator alloc] initWithAcctSimInfo:acctSimInfo
					andSimStartDate:self.simParams.simStartDate] autorelease];
				[self.eventCreators addObject:dividendEventCreator];
		}
		
		[self.simParams.workingBalanceMgr.fundingSources addBalance:acctSimInfo.acctBal forInput:acct];
	} // for each savings account
	
	
	inputs = [self.dataModelController fetchObjectsForEntityName:LOAN_INPUT_ENTITY_NAME];
	for(LoanInput *loan in inputs)
	{
		if([SimInputHelper multiScenBoolVal:loan.loanEnabled
				andScenario:simParams.simScenario])
		{
		
			LoanSimInfo *loanInfo = [[[LoanSimInfo alloc]initWithLoan:loan 
				andSimParams:self.simParams]autorelease];
			[self.simParams.loanInfo addSimInfo:loan withSimInfo:loanInfo];

			
			LoanPaymentSimEventCreator *loanPmtEventCreator = 
				[[[LoanPaymentSimEventCreator alloc] initWithLoanInfo:loanInfo] autorelease];
			[self.eventCreators addObject:loanPmtEventCreator];
			
			LoanOrigSimEventCreator *loanOrigCreator = [[[LoanOrigSimEventCreator alloc]
				initWithLoanInfo:loanInfo] autorelease];
			[self.eventCreators addObject:loanOrigCreator];
			
			LoanEarlyPayoffSimEventCreator *earlyPayoffSimEventCreator = 
				[[[LoanEarlyPayoffSimEventCreator alloc] initWithLoanInfo:loanInfo] autorelease];
			[self.eventCreators addObject:earlyPayoffSimEventCreator];

			[self.simParams.workingBalanceMgr.loanBalances addBalance:loanInfo.loanBalance forInput:loan];


		}
		
	}
	
	inputs = [self.dataModelController fetchObjectsForEntityName:ASSET_INPUT_ENTITY_NAME];
	for(AssetInput *asset in inputs)
	{
		if([SimInputHelper multiScenBoolVal:asset.assetEnabled
				andScenario:simParams.simScenario])
		{
			AssetSimInfo *assetInfo =  
				[[[AssetSimInfo alloc] initWithAsset:asset 
				andSimParams:self.simParams] autorelease];
			[self.simParams.assetInfo addSimInfo:asset withSimInfo:assetInfo];
				
				
			if([assetInfo ownedForAtLeastOneDay])
			{
				// Only include the asset in simulation if it's owned for at least one day.
				// Otherwise, it's a wash/non-event as far as simulation is concerned.
				if([assetInfo purchasedAfterSimStart])
				{
					AssetPurchaseSimEventCreator *assetPurchaseCreator = 
					[[[AssetPurchaseSimEventCreator alloc] initWithAssetSimInfo:assetInfo] autorelease];
					[self.eventCreators addObject:assetPurchaseCreator];
				}
			
				if([assetInfo soldAfterSimStart])
				{
					AssetSaleSimEventCreator *assetSaleCreator = 
					[[[AssetSaleSimEventCreator alloc] initWithAssetSimInfo:assetInfo] autorelease];
					[self.eventCreators addObject:assetSaleCreator];
				}
			
				[self.simParams.workingBalanceMgr.assetValues addBalance:assetInfo.assetValue forInput:asset];
			} // If asset owned for at least one day
		} // If asset is enabled
	}
	
	inputs = [self.dataModelController fetchObjectsForEntityName:TRANSFER_INPUT_ENTITY_NAME];
	for(TransferInput *transfer in inputs)
	{
		assert(transfer != nil);
		if([SimInputHelper multiScenBoolVal:transfer.cashFlowEnabled
				andScenario:simParams.simScenario])
		{
			TransferSimInfo *transferInfo = [[[TransferSimInfo alloc] initWithTransferInput:transfer 
				andSimParams:simParams] autorelease];
			[self.simParams.transferInfo addSimInfo:transfer withSimInfo:transferInfo];
			
			[self.eventCreators addObject:
				[[[TransferSimEventCreator alloc] initWithTransferSimInfo:transferInfo] autorelease]];
		}
	}
	
	
	inputs = [self.dataModelController fetchObjectsForEntityName:TAX_INPUT_ENTITY_NAME];
	for(TaxInput *tax in inputs)
	{
		if([SimInputHelper multiScenBoolVal:tax.taxEnabled
				andScenario:simParams.simScenario])
		{
			TaxInputCalc *taxCalc = [[[TaxInputCalc alloc] initWithTaxInput:tax 
					andSimParams:self.simParams] autorelease];
			[self.simParams.taxInputCalcs addTaxInputCalc:taxCalc];
			[self.simParams.taxInfo addSimInfo:tax withSimInfo:taxCalc];
		}
	}
	// The tax calculation objects need to be configured in 2 phases. In the first
	// phase all the objects are initialized. In the 2nd, all the itemizizations are 
	// setup. This is needed, since TaxInput's can refer to each other when there
	// is a deduction for taxes paid.
	[self.simParams.taxInputCalcs configCalcEntries:self.simParams];
	
}


- (void) resetSimulator
{
    // Reset the event list
	self.eventList = [[[SimEventList alloc] init] autorelease];
	
	self.simParams = [[[SimParams alloc] 
			initWithSharedAppVals:self.sharedAppVals] autorelease];
    
    NSDate *simStartDate = [self.simParams.dateHelper beginningOfDay:self.sharedAppVals.simStartDate];


	[self populateEventCreators];
	    
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
	
	
	self.digest = [[[FiscalYearDigest alloc] initWithSimParams:self.simParams] autorelease];
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
    [[theEvent eventDate] compare:self.simParams.simEndDate];
    
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

-(CGFloat)eventProgressVal:(SimEvent*)theEvent
{
	NSTimeInterval totalSimTime = [self.simParams.simEndDate timeIntervalSinceDate:self.simParams.simStartDate];
	NSTimeInterval eventSimTime = [[theEvent eventDate] timeIntervalSinceDate:self.simParams.simStartDate];
	
	CGFloat progressVal = ((CGFloat)eventSimTime)/((CGFloat)totalSimTime);
	return progressVal;
}

#pragma mark - Main simulator engine loop

- (void)runSim:(id<ProgressUpdateDelegate>)simProgressDelegate
{
    NSLog(@"Running Simulator ...");
	assert(simProgressDelegate != nil);
    
    [self resetSimulator];
	
	[simProgressDelegate updateProgress:0.0];
        
	SimEvent* nextEventToProcess = [self.eventList nextEvent];
	
	assert([self.simParams.dateHelper dateIsEqualOrLater:[nextEventToProcess eventDate]
		otherDate:self.simParams.simStartDate]);
	
	CGFloat currentProgress = 0.0;
	
    while ((nextEventToProcess != nil) &&
		[self eventEarlierOrSameTimeAsSimEnd:nextEventToProcess]) 
    {
		[self processEvent:nextEventToProcess];
        
        if(self.simExecutionOperation != nil)
        {
            if(self.simExecutionOperation.isCancelled)
            {
                NSLog(@"... Sim execution canceled.");
                return; // abort the simulation
            }
        }

		
		CGFloat eventProgress = [self eventProgressVal:nextEventToProcess];
		if((eventProgress - currentProgress) > UPDATE_SIM_PROGRESS_THRESHOLD)
		{
			currentProgress = eventProgress;
			[simProgressDelegate updateProgress:currentProgress];
		}
        
        if(self.simExecutionOperation != nil)
        {
            if(self.simExecutionOperation.isCancelled)
            {
                NSLog(@"... Sim execution canceled.");
                return; // abort the simulation
            }
        }
		
		nextEventToProcess = [self.eventList nextEvent];
    } // while planEndDate is in the future w.r.t. currentSimDate
    
    NSLog(@"... Done running simulation");
    
    
}

@end
