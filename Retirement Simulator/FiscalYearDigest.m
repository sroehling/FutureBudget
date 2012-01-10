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
#import "AccountContribDigestEntry.h"
#import "WorkingBalanceMgr.h"
#import "SharedAppValues.h"
#import "InterestBearingWorkingBalance.h"
#import "EndOfYearDigestResult.h"
#import "Cash.h"
#import "FiscalYearDigestEntries.h"
#import "LoanPmtDigestEntry.h"
#import "DigestEntryProcessingParams.h"
#import "AssetSimInfo.h"
#import "AssetDigestEntry.h"
#import "IncomeDigestEntry.h"
#import "InputValDigestSummations.h"
#import "DigestEntry.h"
#import "TaxInputCalcs.h"
#import "SimParams.h"

#import "AssetInput.h"
#import "InputSimInfoCltn.h"
#import "EndOfYearInputResults.h"
#import "LoanSimInfo.h"
#import "LoanInput.h"
#import "AccountSimInfo.h"
#import "Account.h"
#import "IncomeSimInfo.h"
#import "IncomeInput.h"
#import "InputValDigestSummation.h"
#import "ExpenseSimInfo.h"
#import "DateSensitiveValueVariableRateCalculatorCreator.h"
#import "InflationRate.h"
#import "VariableRateCalculator.h"
#import "ExpenseInput.h"

@implementation FiscalYearDigest

@synthesize simParams;
@synthesize digestEntries;
@synthesize savedEndOfYearResults;
@synthesize currentYearDigestStartDate;
@synthesize adjustValueForInflationCalculator;


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
		
		// Calculate a multiplier which can be used to adjust values back to the start date of simulation.
		DateSensitiveValueVariableRateCalculatorCreator *calcCreator = 
		   [[[DateSensitiveValueVariableRateCalculatorCreator alloc] init] autorelease];
		self.adjustValueForInflationCalculator = [calcCreator 
							createForDateSensitiveValue:self.simParams.inflationRate
							andStartDate:self.simParams.simStartDate];
	}
	return self;
}

-(void)processEndOfYearInputResults:(EndOfYearDigestResult*)results
{

	NSArray *assetSimInfos = [self.simParams.assetInfo simInfos];
	double sumAssetVal = 0.0;
	for(AssetSimInfo *assetSimInfo in assetSimInfos)
	{
		double assetVal = [assetSimInfo.assetValue currentBalance];
		[results.assetValues setResultForInput:assetSimInfo.asset andValue:assetVal];
		sumAssetVal += assetVal;
	}
	results.sumAssetVals = sumAssetVal;
	
	NSArray *loanSimInfos = [self.simParams.loanInfo simInfos];
	double sumLoanBal = 0.0;
	for(LoanSimInfo *loanSimInfo in loanSimInfos)
	{
		double loanBal = [loanSimInfo.loanBalance currentBalance];
		[results.loanBalances setResultForInput:loanSimInfo.loan andValue:loanBal];
		sumLoanBal += loanBal;
	}
	results.sumLoanBal = sumLoanBal;
	
	NSArray *acctSimInfos = [self.simParams.acctInfo simInfos];
	double sumAcctBal = 0.0;
	double sumAcctContrib = 0.0;
	double sumAcctWithdrawal = 0.0;
	for(AccountSimInfo *acctSimInfo in acctSimInfos)
	{
		double acctBal = [acctSimInfo.acctBal currentBalance];
		[results.acctBalances setResultForInput:acctSimInfo.account andValue:acctBal];
		sumAcctBal += acctBal;
		
		double acctContrib = [acctSimInfo.acctBal.contribs yearlyTotal];
		[results.acctContribs setResultForInput:acctSimInfo.account andValue:acctContrib];
		sumAcctContrib += acctContrib;
		
		double acctWithdrawal = [acctSimInfo.acctBal.withdrawals yearlyTotal];
		[results.acctWithdrawals setResultForInput:acctSimInfo.account andValue:acctWithdrawal];
		sumAcctWithdrawal += acctWithdrawal;
	}
	results.sumAcctBal = sumAcctBal;
	results.sumAcctContrib = sumAcctContrib;
	results.sumAcctWithdrawal = sumAcctWithdrawal;
	
	NSArray *incomeSimInfos = [self.simParams.incomeInfo simInfos];
	double sumIncome = 0.0;
	for(IncomeSimInfo *incomeSimInfo  in incomeSimInfos)
	{
		double incomeAmt = [incomeSimInfo.digestSum yearlyTotal];
		[results.incomes setResultForInput:incomeSimInfo.income andValue:incomeAmt];
		sumIncome += incomeAmt;
	}
	results.sumIncomes = sumIncome;

	NSArray *expenseSimInfos = [self.simParams.expenseInfo simInfos];
	double sumExpense = 0.0;
	for(ExpenseSimInfo *expenseSimInfo  in expenseSimInfos)
	{
		double expenseAmt = [expenseSimInfo.digestSum yearlyTotal];
		[results.expenses setResultForInput:expenseSimInfo.expense andValue:expenseAmt];
		sumExpense += expenseAmt;
	}
	results.sumExpense = sumExpense;
	
	results.cashBal = [self.simParams.workingBalanceMgr.cashWorkingBalance currentBalance];
	results.deficitBal = [self.simParams.workingBalanceMgr.deficitBalance currentBalance];
	
	assert(results.endDate != nil);
	assert([DateHelper dateIsEqualOrLater:results.endDate otherDate:self.simParams.simStartDate]);
	
	
	double futureValueMultiplier = [self.adjustValueForInflationCalculator  
		valueMultiplierBetweenStartDate:self.simParams.simStartDate andEndDate:results.endDate];
	assert(futureValueMultiplier > 0.0);
	results.simStartDateValueMultiplier = 1.0/futureValueMultiplier; 


}
	


- (EndOfYearDigestResult*)processDigest
{
	
	[self.simParams.workingBalanceMgr resetCurrentBalances];
	NSDate *endOfYearDate = [DateHelper endOfYear:self.currentYearDigestStartDate];

	EndOfYearDigestResult *endOfYearResults = [[[EndOfYearDigestResult alloc] 
		initWithEndDate:endOfYearDate] autorelease];
	
	NSDate *currentDate = self.currentYearDigestStartDate;
	
	// TODO - Stop the iteration if the currentDate falls into the next year,
	// not just when it reaches MAX_DAYS_IN_YEAR.
	for(int currDayIndex=0; currDayIndex < MAX_DAYS_IN_YEAR; currDayIndex++)
	{
		DigestEntryCltn *currDayDigestEntries = 
			[self.digestEntries entriesForDayIndex:currDayIndex];
		
		DigestEntryProcessingParams *processingParams = 
				[[DigestEntryProcessingParams alloc] 
				initWithWorkingBalanceMgr:self.simParams.workingBalanceMgr 
				andDayIndex:currDayIndex andCurrentDate:currentDate];
		
		if([currDayDigestEntries.digestEntries count] > 0)
		{
			for(id<DigestEntry> digestEntry in currDayDigestEntries.digestEntries)
			{
				[digestEntry processDigestEntry:processingParams];
			}
		}
		[self.simParams.taxInputCalcs processDailyTaxPmts:processingParams];

		if([currDayDigestEntries isEndDateForEstimatedTaxes])
		{
			// Advance all balances and accrue interest to the current date. This is needed so that
			// all the estimated taxes can be included. 
/*			[self advanceWorkingBalancesAndAccrueInterest:endOfYearResults 
				advanceToDate:currentDate];

			[self.simParams.workingBalanceMgr setAsideAccruedEstimatedTaxesForNextTaxPaymentAsOfDate:currentDate];
*/
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
		[processingParams release];
	} // for each day in the year

	// Advance all the working balances to the end of this year. Although none of the current balances
	// are changed, some interest might be accrued leading up to the end of the year. This interest
	// needs to be included in the total interest for the year, so that taxes can be calculated.
	NSDate *beginningOfNextYear = [DateHelper beginningOfNextYear:self.currentYearDigestStartDate];
	[self.simParams.workingBalanceMgr advanceBalancesToDate:beginningOfNextYear];

	// Update the effective tax rates for the tax inputs. This needs to be done at the end of 
	// processing the digest, since all the InputValDigestSummation objects referenced by the
	// TaxInputCalcs will have been populated with income, interest, etc.
	// TBD - Should the date passed be the end this year, or the beginning of next year.
	[self.simParams.taxInputCalcs updateEffectiveTaxRates:beginningOfNextYear];
	
	// Reset all the digest sums used to tally up taxable incomes, expenses, interest, etc.


	endOfYearResults.totalEndOfYearBalance = [self.simParams.workingBalanceMgr totalCurrentNetBalance];
	[self processEndOfYearInputResults:endOfYearResults];
	[endOfYearResults logResults];

	// Reset the digest sums after processing end of year results, since
	// these digest sums are used copied out to the results.
	[self.simParams.digestSums resetSums];


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
	
	[self processDigest];

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
	[adjustValueForInflationCalculator release];
}

@end
