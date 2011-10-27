//
//  FiscalYearDigest.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 8/15/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FiscalYearDigest.h"
#import "DigestEntryCltn.h"
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
#import "FiscalYearDigestEntries.h"
#import "WorkingBalanceAdjustment.h"
#import "LoanPmtDigestEntry.h"
#import "DigestEntryProcessingParams.h"
#import "AssetSimInfo.h"
#import "AssetDigestEntry.h"
#import "IncomeDigestEntry.h"
#import "DigestEntry.h"
#import "TaxInputCalcs.h"
#import "SimParams.h"

@implementation FiscalYearDigest

@synthesize simParams;
@synthesize digestEntries;
@synthesize savedEndOfYearResults;
@synthesize currentYearDigestStartDate;


-(id)initWithSimParams:(SimParams*)theSimParams
{
	self = [super init];
	if(self)
	{
		assert(theSimParams != nil);
		self.simParams = theSimParams;

		self.digestEntries = [[[FiscalYearDigestEntries alloc] 
			initWithStartDate:self.simParams.digestStartDate] autorelease];
		self.savedEndOfYearResults = [[[NSMutableArray alloc] init] autorelease];
		
		self.currentYearDigestStartDate = self.simParams.digestStartDate;

	}
	return self;
}


- (void)advanceWorkingBalancesAndAccrueInterest:(EndOfYearDigestResult*)theResults 
	advanceToDate:(NSDate*)advanceDate
{
	BalanceAdjustment *interestAccruedForAdvance = 
		[self.simParams.workingBalanceMgr advanceBalancesToDate:advanceDate];
	
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
	
	[self.simParams.workingBalanceMgr resetCurrentBalances];
	NSDate *endOfYearDate = [DateHelper endOfYear:self.currentYearDigestStartDate];

	EndOfYearDigestResult *endOfYearResults = [[[EndOfYearDigestResult alloc] 
		initWithEndDate:endOfYearDate] autorelease];
	
	NSDate *currentDate = self.currentYearDigestStartDate;
	
	for(int currDayIndex=0; currDayIndex < MAX_DAYS_IN_YEAR; currDayIndex++)
	{
		DigestEntryCltn *currDayDigestEntries = 
			[self.digestEntries entriesForDayIndex:currDayIndex];
		
		if([currDayDigestEntries.digestEntries count] > 0)
		{
			DigestEntryProcessingParams *processingParams = 
				[[DigestEntryProcessingParams alloc] 
				initWithWorkingBalanceMgr:self.simParams.workingBalanceMgr 
				andDayIndex:currDayIndex andCurrentDate:currentDate];
			for(id<DigestEntry> digestEntry in currDayDigestEntries.digestEntries)
			{
				[digestEntry processDigestEntry:processingParams];
			}
			[processingParams release];
		}
		if([currDayDigestEntries isEndDateForEstimatedTaxes])
		{
			// Advance all balances and accrue interest to the current date. This is needed so that
			// all the estimated taxes can be included. 
			[self advanceWorkingBalancesAndAccrueInterest:endOfYearResults 
				advanceToDate:currentDate];

			[self.simParams.workingBalanceMgr setAsideAccruedEstimatedTaxesForNextTaxPaymentAsOfDate:currentDate];
		}
		if([currDayDigestEntries isEstimatedTaxPaymentDay])
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

	// Update the effective tax rates for the tax inputs. This needs to be done at the end of 
	// processing the digest, since all the InputValDigestSummation objects referenced by the
	// TaxInputCalcs will have been populated with income, interest, etc.
	[self.simParams.taxInputCalcs updateEffectiveTaxRates];

	// Advance all the working balances to the end of this year. Although none of the current balances
	// are changed, some interest might be accrued leading up to the end of the year. This interest
	// needs to be included in the total interest for the year, so that taxes can be calculated.
	[self advanceWorkingBalancesAndAccrueInterest:endOfYearResults 
		advanceToDate:[DateHelper beginningOfNextYear:self.currentYearDigestStartDate]];

	endOfYearResults.totalEndOfYearBalance = [self.simParams.workingBalanceMgr totalCurrentNetBalance];
	[endOfYearResults logResults];

	return endOfYearResults;
}


- (EndOfYearDigestResult*)doMultiPassDigestCalcs
{


	//-------------------------------------------------------------------------------------
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
	// For the second pass, also include in the taxable income calculations the 
	// taxable savings interest and any taxable account withdrawals incurred through expenses 

	// For the second pass, we can also include the *actual* expense and contribution
	// amounts accrued over the year. This may be somewhat less than the estimated
	// deduction from the 1st pass, since some contributions may not be fully funded
	// if there's not enough cash available.
	// TODO - Need to have some kind of event handling to process the estimated taxes as an event.
		
	EndOfYearDigestResult *secondPassResults = [self processDigest];
	
	return secondPassResults;

}

- (void)advanceToNextYear
{
	NSLog(@"Advancing digest to next year from last year start = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:self.currentYearDigestStartDate]);
//	[self.simParams.workingBalanceMgr logCurrentBalances];

	EndOfYearDigestResult *endOfYearResults = [self doMultiPassDigestCalcs];
	assert(endOfYearResults != nil);
	[self.savedEndOfYearResults addObject:endOfYearResults];

	// Advance the digest to the next year
	self.currentYearDigestStartDate = [DateHelper beginningOfNextYear:self.currentYearDigestStartDate];
	[self.simParams.workingBalanceMgr carryBalancesForward:self.currentYearDigestStartDate];
	[self.digestEntries resetEntriesAndAdvanceStartDate:self.currentYearDigestStartDate];
}

- (id) init
{
	assert(0); // must call init method above
}

- (void) dealloc
{
	[super dealloc];
	[digestEntries release];
	[currentYearDigestStartDate release];
	[savedEndOfYearResults release];
	[simParams release];
}

@end
