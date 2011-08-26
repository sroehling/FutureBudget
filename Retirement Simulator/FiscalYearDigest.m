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
#import "SavingsWorkingBalance.h"
#import "EndOfYearDigestResult.h"
#import "Cash.h"
#import "CashFlowSummations.h"
#import "WorkingBalanceAdjustment.h"
#import "FlatIncomeTaxRateCalculator.h"

@implementation FiscalYearDigest

@synthesize startDate;
@synthesize workingBalanceMgr;
@synthesize cashFlowSummations;
@synthesize incomeTaxRateCalc;


-(id)initWithStartDate:(NSDate*)theStartDate andWorkingBalances:(WorkingBalanceMgr*)wbMgr
{
	self = [super init];
	if(self)
	{
		assert(theStartDate != nil);
		
		// Initially dummy up with a flat tax calculator
		self.incomeTaxRateCalc = 
			[[[FlatIncomeTaxRateCalculator alloc] initWithRate:0.25] autorelease];
		
		self.startDate = theStartDate;

		self.cashFlowSummations = [[[CashFlowSummations alloc] initWithStartDate:theStartDate] autorelease];
		
		assert(wbMgr != nil);
		self.workingBalanceMgr = wbMgr;
	}
	return self;
}


- (EndOfYearDigestResult*)processDigestWithTaxRate:(double)incomeTaxRate
{
	
	EndOfYearDigestResult *endOfYearResults = [[[EndOfYearDigestResult alloc] init] autorelease];
	
	NSDate *currentDate = self.startDate;
	for(int currDayIndex=0; currDayIndex < MAX_DAYS_IN_YEAR; currDayIndex++)
	{
		CashFlowSummation *currDayCashFlowSummation = 
			[self.cashFlowSummations summationForDayIndex:currDayIndex];
		
		if(currDayCashFlowSummation.sumIncome >0.0)
		{
			[endOfYearResults incrementTotalIncome:currDayCashFlowSummation.sumIncome];
			
			assert(incomeTaxRate >= 0.0);
			assert(incomeTaxRate <= 1.0);
			double taxesToPayOnIncome = currDayCashFlowSummation.sumIncome * incomeTaxRate;
			double afterTaxIncome = currDayCashFlowSummation.sumIncome - taxesToPayOnIncome;
			
			// Unlike the handling for expenses and savings 
			// contributions (see below), there is no need to track
			// the interest for incrementing the cash balance. 
			// However, if we ever support an "interest bearing"
			// cash working balance (e.g. for people who have
			// interest bearing checking), the code below will need
			// to be changed to also sum up the interest generated
			// advancing (and thus generating interest), then 
			// incrementing the cash working balance.
			[self.workingBalanceMgr 
				incrementCashBalance:afterTaxIncome asOfDate:currentDate];
			[endOfYearResults incrementTotalIncomeTaxes:taxesToPayOnIncome];
		}
		if([currDayCashFlowSummation.sumExpenses totalAmount] > 0.0)
		{
			[endOfYearResults incrementTotalExpense:currDayCashFlowSummation.sumExpenses];
			
			WorkingBalanceAdjustment *withdrawAmount = 
				[self.workingBalanceMgr 
				decrementBalanceFromFundingList:[currDayCashFlowSummation.sumExpenses totalAmount] 
				asOfDate:currentDate];
			assert([withdrawAmount.balanceAdjustment totalAmount] <= 
				[currDayCashFlowSummation.sumExpenses totalAmount]);
				
			// By withdrawing/decrementing the expenses from the funding list, the 
			// different funding sources will advance their balances to currentDate,
			// accruing interest for the amount of time advanced. This interest is 
			// summed up in withdrawAmount.interestAdjustment and 
			// added to the end of year tax calculations.
			[endOfYearResults incrementTotalInterest:withdrawAmount.interestAdjustement];
		}
		if([currDayCashFlowSummation.savingsContribs count] > 0)
		{
			for(SavingsContribDigestEntry *savingsContrib in currDayCashFlowSummation.savingsContribs)
			{
				if(savingsContrib.contribAmount>0.0)
				{
					double actualContrib = [self.workingBalanceMgr
						decrementAvailableCashBalance:savingsContrib.contribAmount 
						asOfDate:currentDate];
					if(actualContrib>0.0)
					{
						BalanceAdjustment *contribAdjustment = 
							[[[BalanceAdjustment alloc] initWithAmount:actualContrib 
							andIsAmountTaxable:savingsContrib.contribIsTaxable] autorelease];
						[endOfYearResults incrementTotalExpense:contribAdjustment];
						BalanceAdjustment *interestAccruedLeadingUpToSavingsContribution = 
							[savingsContrib.workingBalance incrementBalance:actualContrib asOfDate:currentDate];
							
						// Similar to what happens for expenses (see comment above), by processing
						// the savings contribution, we advance the balance on the savings account and 
						// accrue some interest. This interest is added to the end of year results for 
						// tax calculations.
						[endOfYearResults incrementTotalInterest:interestAccruedLeadingUpToSavingsContribution];
					}
				}
			}
		}
		currentDate = [DateHelper nextDay:currentDate];
	} // for each day in the year

	// Advance all the working balances to the end of this year. Although none of the current balances
	// are changed, some interest might be accrued leading up to the end of the year. This interest
	// needs to be included in the total interest for the year, so that taxes can be calculated.
	BalanceAdjustment *remainingInterestUntilEndOfFiscalYear = 
		[self.workingBalanceMgr advanceBalancesToDate:[DateHelper beginningOfNextYear:self.startDate]];
	[endOfYearResults incrementTotalInterest:remainingInterestUntilEndOfFiscalYear];

	[endOfYearResults logResults];
	[self.workingBalanceMgr logCurrentBalances];

	return endOfYearResults;
}

- (void)advanceToNextYear
{
	NSLog(@"Advancing digest to next year from last year start = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:self.startDate]);
	[self.workingBalanceMgr logCurrentBalances];

	CashFlowSummation *yearlySummation = self.cashFlowSummations.yearlySummation;
	assert(yearlySummation != nil);
	double totalYearlyIncome = yearlySummation.sumIncome;
	double totalYearlyDeductableExpense = yearlySummation.sumExpenses.taxFreeAmount;
	double totalYearlyDeductableContributions = yearlySummation.sumContributions.taxFreeAmount;
	double totalDeductions = totalYearlyDeductableExpense + totalYearlyDeductableContributions;
	
	
	double incomeTaxRate = [self.incomeTaxRateCalc 
		taxRateForGrossIncome:totalYearlyIncome andDeductions:totalDeductions];
	[self processDigestWithTaxRate:incomeTaxRate];

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
	[incomeTaxRateCalc release];

}

@end
