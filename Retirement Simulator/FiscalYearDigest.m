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
#import "AssetSimInfo.h"
#import "AssetDigestEntry.h"
#import "CashFlowDigestEntry.h"

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

- (void)withdrawFundingForExpense:
	(EndOfYearDigestResult*)eoyResults andAmount:(double)withdrawAmount 
	andDate:(NSDate*)withdrawDate
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
	
	/*
	[self accrueEstimatedTaxesForTaxableAmount:[withdrawAdj totalTaxableInterestAndBalance] 
		andTaxRate:taxRate andDate:withdrawDate];
	*/

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
		
		if([currDayCashFlowSummation.incomeCashFlows count] > 0)
		{
			for(CashFlowDigestEntry *incomeCashFlow in currDayCashFlowSummation.incomeCashFlows)
			{
				[incomeCashFlow processEntry:self.workingBalanceMgr andDate:currentDate];
			}
		}
		if([currDayCashFlowSummation.sumExpenses totalAmount] > 0.0)
		{			
			[self withdrawFundingForExpense:endOfYearResults 
				andAmount:[currDayCashFlowSummation.sumExpenses totalAmount] andDate:currentDate];
		}
		if([currDayCashFlowSummation.loanPmts count] > 0)
		{
			for(LoanPmtDigestEntry *loanPmt in currDayCashFlowSummation.loanPmts)
			{
				WorkingBalanceAdjustment *loanPmtAdjustment = 
					[loanPmt.loanBalance decrementAvailableBalance:loanPmt.paymentAmt asOfDate:currentDate];
// TODO - Sum up tax deductable interest, as described below.				
				// TODO - For tax purposes, we need to have some kind of increment like the following
				// This will be sum up the deductable interest in the same way as is done for expenses.
				//[eoyResults incrementTotalExpense:withdrawAdj.balanceAdjustment];
				// [eoyResult incrementTotalLoanPmt:loanPmtAdj.balanceAdjustment
			}
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
							[[[BalanceAdjustment alloc] initWithAmount:actualContrib] autorelease];
						[endOfYearResults incrementTotalExpense:contribAdjustment];
						BalanceAdjustment *interestAccruedLeadingUpToSavingsContribution = 
							[savingsContrib.workingBalance incrementBalance:actualContrib asOfDate:currentDate];
							
						// Similar to what happens for expenses (see comment above), by processing
						// the savings contribution, we advance the balance on the savings account and 
						// accrue some interest. This interest is added to the end of year results for 
						// tax calculations.
						[endOfYearResults incrementTotalInterest:interestAccruedLeadingUpToSavingsContribution];
				/*
									
						[self accrueEstimatedTaxesForTaxableAmount:
							interestAccruedLeadingUpToSavingsContribution.taxableAmount  
								andTaxRate:incomeTaxRate andDate:currentDate];
				*/
					}
				}
			}
		} // If there are savings contributions on this day
		if([currDayCashFlowSummation.assetPurchases count] > 0)
		{
			for(AssetDigestEntry *assetPurchase in currDayCashFlowSummation.assetPurchases)
			{
				assert(assetPurchase != nil);
				double purchaseCost = [assetPurchase.assetInfo purchaseCost];
				[self withdrawFundingForExpense:endOfYearResults andAmount:purchaseCost andDate:currentDate];
				[assetPurchase.assetInfo.assetValue 
					incrementBalance:purchaseCost asOfDate:currentDate];
			}
		}
		if([currDayCashFlowSummation.assetSales count] > 0)
		{
			for(AssetDigestEntry *assetSale in currDayCashFlowSummation.assetSales)
			{
				assert(assetSale != nil);
				double saleValue = 
					[assetSale.assetInfo.assetValue zeroOutBalanceAsOfDate:currentDate];
				[self.workingBalanceMgr incrementCashBalance:saleValue asOfDate:currentDate];
				// TODO - Handle taxes for change in value since purchase
			}
		} // If there are asset sales on this date.
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
