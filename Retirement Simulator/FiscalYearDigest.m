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
@synthesize savedEndOfYearResults;

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
		
		self.savedEndOfYearResults = [[[NSMutableArray alloc] init] autorelease];
	}
	return self;
}

- (double)calcTaxesFromTotalTaxableAmount:(double)taxableAmount andTaxRate:(double)taxRate
{
	assert(taxRate >= 0.0);
	assert(taxRate <= 1.0);
	assert(taxableAmount >= 0);
	return taxableAmount * taxRate;
}

- (void)accrueEstimatedTaxesForTaxableAmount:(double)taxableAmount 
	andTaxRate:(double)taxRate andDate:(NSDate*)accrualDate
{
	double taxesToBePaid = 
		[self calcTaxesFromTotalTaxableAmount:taxableAmount
		andTaxRate:taxRate];
	
	[self.workingBalanceMgr incrementAccruedEstimatedTaxes:taxesToBePaid asOfDate:accrualDate];

}

- (void)advanceWorkingBalancesAndAccrueInterest:(EndOfYearDigestResult*)theResults 
	advanceToDate:(NSDate*)advanceDate
	andTaxRate:(double)taxRate
{
	BalanceAdjustment *interestAccruedForAdvance = 
		[self.workingBalanceMgr advanceBalancesToDate:advanceDate];
	
	[self accrueEstimatedTaxesForTaxableAmount:interestAccruedForAdvance.taxableAmount 
		andTaxRate:taxRate andDate:advanceDate];
		
	[theResults incrementTotalInterest:interestAccruedForAdvance];

}

- (void)processWithdrawal:(EndOfYearDigestResult*)eoyResults andAmount:(double)withdrawAmount 
	andDate:(NSDate*)withdrawDate andTaxRate:(double)taxRate
{
	WorkingBalanceAdjustment *withdrawAdj = 
		[self.workingBalanceMgr decrementBalanceFromFundingList:withdrawAmount 
		asOfDate:withdrawDate];
	assert([withdrawAdj.balanceAdjustment totalAmount] <= withdrawAmount);
	
	[eoyResults incrementTotalWithdrawals:withdrawAdj.balanceAdjustment];
				
	// By withdrawing/decrementing the expenses from the funding list, the 
	// different funding sources will advance their balances to currentDate,
	// accruing interest for the amount of time advanced. This interest is 
	// summed up in withdrawAmount.interestAdjustment and 
	// added to the end of year tax calculations.
	[eoyResults incrementTotalInterest:withdrawAdj.interestAdjustement];
	[eoyResults incrementTotalExpense:withdrawAdj.balanceAdjustment];
	
	[self accrueEstimatedTaxesForTaxableAmount:[withdrawAdj totalTaxableInterestAndBalance] 
		andTaxRate:taxRate andDate:withdrawDate];
	

}


- (EndOfYearDigestResult*)processDigestWithTaxRate:(double)incomeTaxRate
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
			[self processWithdrawal:endOfYearResults 
				andAmount:[currDayCashFlowSummation.sumExpenses totalAmount] 
				andDate:currentDate andTaxRate:incomeTaxRate];
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
							
						[self accrueEstimatedTaxesForTaxableAmount:
							interestAccruedLeadingUpToSavingsContribution.taxableAmount  
							andTaxRate:incomeTaxRate andDate:currentDate];
					}
				}
			}
		} // If there are savings contributions on this day
		if([currDayCashFlowSummation isEndDateForEstimatedTaxes])
		{
			// Advance all balances and accrue interest to the current date. This is needed so that
			// all the estimated taxes can be included. 
			[self advanceWorkingBalancesAndAccrueInterest:endOfYearResults 
				advanceToDate:currentDate andTaxRate:incomeTaxRate];

			[self.workingBalanceMgr setAsideAccruedEstimatedTaxesForNextTaxPaymentAsOfDate:currentDate];
		}
		if([currDayCashFlowSummation isEstimatedTaxPaymentDay])
		{
			double taxPaymentAmount = [self.workingBalanceMgr 
					decrementNextEstimatedTaxPaymentAsOfDate:currentDate];
			[self processWithdrawal:endOfYearResults 
				andAmount:taxPaymentAmount andDate:currentDate andTaxRate:incomeTaxRate];
		}
		currentDate = [DateHelper nextDay:currentDate];
	} // for each day in the year


	// Advance all the working balances to the end of this year. Although none of the current balances
	// are changed, some interest might be accrued leading up to the end of the year. This interest
	// needs to be included in the total interest for the year, so that taxes can be calculated.
	[self advanceWorkingBalancesAndAccrueInterest:endOfYearResults 
		advanceToDate:[DateHelper beginningOfNextYear:self.startDate] andTaxRate:incomeTaxRate];

	endOfYearResults.totalEndOfYearBalance = [self.workingBalanceMgr totalCurrentBalance];
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
	CashFlowSummation *yearlySummation = self.cashFlowSummations.yearlySummation;
	assert(yearlySummation != nil);
	double totalYearlyTaxableIncome = yearlySummation.sumIncome;
	// Note that for the first pass, total deductions
	// is an estimation of the *expected* tax deductable
	// expenses and contributions. However, in reality,
	// this could be reduced, since not all the 
	// contributions may get funding (e.g., if the
	// cash balance runs low).
	double totalDeductions = [yearlySummation totalDeductions];
	
	double incomeTaxRate = [self.incomeTaxRateCalc 
		taxRateForGrossIncome:totalYearlyTaxableIncome andDeductions:totalDeductions];
	EndOfYearDigestResult *firstPassResults = [self processDigestWithTaxRate:incomeTaxRate];

	//-------------------------------------------------------------------------------------
	NSLog(@"doMultiPassDigestCalcs: Starting 2nd pass of digest calculations");
	// For the second pass, also include in the taxable income calculations the 
	// taxable savings interest and any taxable account withdrawals incurred through expenses 
	totalYearlyTaxableIncome = yearlySummation.sumIncome + 
		[firstPassResults totalTaxableWithdrawalsAndSavingsInterest];
	// For the second pass, we can also include the *actual* expense and contribution
	// amounts accrued over the year. This may be somewhat less than the estimated
	// deduction from the 1st pass, since some contributions may not be fully funded
	// if there's not enough cash available.
	totalDeductions = [firstPassResults totalDeductableExpenseAndContributions];
	incomeTaxRate = [self.incomeTaxRateCalc 
		taxRateForGrossIncome:totalYearlyTaxableIncome andDeductions:totalDeductions];
		
	double yearlyEstimatedTaxes = 	[firstPassResults totalTaxableWithdrawalsAndSavingsInterest] * incomeTaxRate;
	// TODO - Need to have some kind of event handling to process the estimated taxes as an event.
		
	EndOfYearDigestResult *secondPassResults = [self processDigestWithTaxRate:incomeTaxRate];
	
		
	
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
	[incomeTaxRateCalc release];
	[savedEndOfYearResults release];

}

@end
