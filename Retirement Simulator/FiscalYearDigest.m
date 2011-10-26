//
//  FiscalYearDigest.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FiscalYearDigest.h"
#import "CashFlowSummation.h"
#import "DateHelper.h"
#import "NumberHelper.h"
#import "CashWorkingBalance.h"
#import "SavingsContribDigestEntry.h"
#import "BalanceAdjustment.h"
#import "WorkingBalanceMgr.h"
#import "SharedAppValues.h"
#import "InterestBearingWorkingBalance.h"
#import "EndOfYearDigestResult.h"
#import "Cash.h"
#import "CashFlowSummations.h"
#import "WorkingBalanceAdjustment.h"
#import "LoanPmtDigestEntry.h"
#import "DigestEntryProcessingParams.h"
#import "AssetSimInfo.h"
#import "AssetDigestEntry.h"
#import "IncomeDigestEntry.h"
#import "DigestEntry.h"

@implementation FiscalYearDigest

@synthesize startDate;
@synthesize workingBalanceMgr;
@synthesize cashFlowSummations;
@synthesize savedEndOfYearResults;

-(id)initWithStartDate:(NSDate*)theStartDate andWorkingBalances:(WorkingBalanceMgr*)wbMgr
{
	self = [super init];
	if(self)
	{
		assert(theStartDate != nil);
				
		self.startDate = theStartDate;

		self.cashFlowSummations = [[[CashFlowSummations alloc] initWithStartDate:theStartDate] autorelease];
		
		assert(wbMgr != nil);
		self.workingBalanceMgr = wbMgr;
		
		self.savedEndOfYearResults = [[[NSMutableArray alloc] init] autorelease];
	}
	return self;
}


- (void)advanceWorkingBalancesAndAccrueInterest:(EndOfYearDigestResult*)theResults 
	advanceToDate:(NSDate*)advanceDate
{
	BalanceAdjustment *interestAccruedForAdvance = 
		[self.workingBalanceMgr advanceBalancesToDate:advanceDate];
	
		
	// TODO - Need to store itemized sums of interest
	// for the TaxInputCalc objects.			
	/*
	[self accrueEstimatedTaxesForTaxableAmount:interestAccruedForAdvance.taxableAmount 
		andTaxRate:taxRate andDate:advanceDate];
	*/
		
	[theResults incrementTotalInterest:interestAccruedForAdvance];

}



- (EndOfYearDigestResult*)processDigest
{
	
	[self.workingBalanceMgr resetCurrentBalances];
	NSDate *endOfYearDate = [DateHelper endOfYear:self.startDate];

	EndOfYearDigestResult *endOfYearResults = [[[EndOfYearDigestResult alloc] 
		initWithEndDate:endOfYearDate] autorelease];
	
	NSDate *currentDate = self.startDate;
	for(int currDayIndex=0; currDayIndex < MAX_DAYS_IN_YEAR; currDayIndex++)
	{
		CashFlowSummation *currDayCashFlowSummation = 
			[self.cashFlowSummations summationForDayIndex:currDayIndex];
		
		if([currDayCashFlowSummation.digestEntries count] > 0)
		{
			DigestEntryProcessingParams *processingParams = 
				[[DigestEntryProcessingParams alloc] initWithWorkingBalanceMgr:self.workingBalanceMgr andDayIndex:currDayIndex andCurrentDate:currentDate];
			for(id<DigestEntry> digestEntry in currDayCashFlowSummation.digestEntries)
			{
				[digestEntry processDigestEntry:processingParams];
			}
			[processingParams release];
		}
		if([currDayCashFlowSummation isEndDateForEstimatedTaxes])
		{
			// Advance all balances and accrue interest to the current date. This is needed so that
			// all the estimated taxes can be included. 
			[self advanceWorkingBalancesAndAccrueInterest:endOfYearResults 
				advanceToDate:currentDate];

			[self.workingBalanceMgr setAsideAccruedEstimatedTaxesForNextTaxPaymentAsOfDate:currentDate];
		}
		if([currDayCashFlowSummation isEstimatedTaxPaymentDay])
		{
		/*
			double taxPaymentAmount = [self.workingBalanceMgr 
					decrementNextEstimatedTaxPaymentAsOfDate:currentDate];
			[self withdrawFundingForExpense:endOfYearResults 
				andAmount:taxPaymentAmount andDate:currentDate];
		*/
		}
		currentDate = [DateHelper nextDay:currentDate];
	} // for each day in the year


	// Advance all the working balances to the end of this year. Although none of the current balances
	// are changed, some interest might be accrued leading up to the end of the year. This interest
	// needs to be included in the total interest for the year, so that taxes can be calculated.
	[self advanceWorkingBalancesAndAccrueInterest:endOfYearResults 
		advanceToDate:[DateHelper beginningOfNextYear:self.startDate]];

	endOfYearResults.totalEndOfYearBalance = [self.workingBalanceMgr totalCurrentNetBalance];
	[endOfYearResults logResults];
	[self.workingBalanceMgr logCurrentBalances];

	return endOfYearResults;
}


- (EndOfYearDigestResult*)doMultiPassDigestCalcs
{


	//-------------------------------------------------------------------------------------
	NSLog(@"doMultiPassDigestCalcs: Starting first pass of digest calculations");
	// In the first pass, we use just the total income as an estimation of the taxes
	// to be paid. Not having processed the digest entries for withdrawals and
	// savings interest, we can't include that yet in the total. As a result, the
	// amount of tax withheld from income will initially be a little low.

	// Note that for the first pass, total deductions
	// is an estimation of the *expected* tax deductable
	// expenses and contributions. However, in reality,
	// this could be reduced, since not all the 
	// contributions may get funding (e.g., if the
	// cash balance runs low).
	
	EndOfYearDigestResult *firstPassResults = [self processDigest];

	//-------------------------------------------------------------------------------------
	NSLog(@"doMultiPassDigestCalcs: Starting 2nd pass of digest calculations");
	// For the second pass, also include in the taxable income calculations the 
	// taxable savings interest and any taxable account withdrawals incurred through expenses 

	// For the second pass, we can also include the *actual* expense and contribution
	// amounts accrued over the year. This may be somewhat less than the estimated
	// deduction from the 1st pass, since some contributions may not be fully funded
	// if there's not enough cash available.
	// TODO - Need to have some kind of event handling to process the estimated taxes as an event.
		
	EndOfYearDigestResult *secondPassResults = [self processDigest];
	
		
	
	NSLog(@"doMultiPassDigestCalcs: Done with digest calculations");
	
	return secondPassResults;

}

- (void)advanceToNextYear
{
	NSLog(@"Advancing digest to next year from last year start = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:self.startDate]);
	[self.workingBalanceMgr logCurrentBalances];

	EndOfYearDigestResult *endOfYearResults = [self doMultiPassDigestCalcs];
	assert(endOfYearResults != nil);
	[self.savedEndOfYearResults addObject:endOfYearResults];

	// Advance the digest to the next year
	self.startDate = [DateHelper beginningOfNextYear:self.startDate];
	[self.workingBalanceMgr carryBalancesForward:self.startDate];
	NSLog(@"Done Advancing digest to next year start = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:self.startDate]);
	[self.cashFlowSummations resetSummationsAndAdvanceStartDate:self.startDate];
}

- (id) init
{
	assert(0); // must call init method above
}

- (void) dealloc
{
	[super dealloc];
	[cashFlowSummations release];
	[startDate release];
	[savedEndOfYearResults release];

}

@end
