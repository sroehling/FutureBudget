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
#import "AccountWorkingBalance.h"
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
#import "TaxInputCalc.h"
#import "TaxInput.h"

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

	// A single cash flow value is tallied across all the results. This represents a
	// summation of inflow minus outflow of money.
	double sumCashFlow = 0.0;

	NSArray *assetSimInfos = [self.simParams.assetInfo simInfos];
	double sumAssetVal = 0.0;
	for(AssetSimInfo *assetSimInfo in assetSimInfos)
	{
		double assetVal = [assetSimInfo.assetValue currentBalanceForDate:results.endDate];
		[results.assetValues setResultForInput:assetSimInfo.asset andValue:assetVal];
		sumAssetVal += assetVal;
		
		sumCashFlow += [assetSimInfo.assetSaleIncome yearlyTotal];
		sumCashFlow -= [assetSimInfo.assetPurchaseExpense yearlyTotal];
	}
	results.sumAssetVals = sumAssetVal;
	
	NSArray *loanSimInfos = [self.simParams.loanInfo simInfos];
	double sumLoanBal = 0.0;
	for(LoanSimInfo *loanSimInfo in loanSimInfos)
	{
		double loanBal = [loanSimInfo.loanBalance currentBalanceForDate:results.endDate];
		[results.loanBalances setResultForInput:loanSimInfo.loan andValue:loanBal];
		sumLoanBal += loanBal;
		
		sumCashFlow += [loanSimInfo.originationSum yearlyTotal];		
		sumCashFlow -= [loanSimInfo.paymentSum yearlyTotal];
		sumCashFlow -= [loanSimInfo.downPaymentSum yearlyTotal];
			
	}
	results.sumLoanBal = sumLoanBal;
	
	NSArray *acctSimInfos = [self.simParams.acctInfo simInfos];
	double sumAcctBal = 0.0;
	double sumAcctContrib = 0.0;
	double sumAcctWithdrawal = 0.0;
	double sumAcctDividend = 0.0;
	double sumAcctCapitalGains = 0.0;
	double sumAcctCapitalLoss = 0.0;
	for(AccountSimInfo *acctSimInfo in acctSimInfos)
	{
		double acctBal = [acctSimInfo.acctBal currentBalanceForDate:results.endDate];
		[results.acctBalances setResultForInput:acctSimInfo.account andValue:acctBal];
		sumAcctBal += acctBal;
		
		double acctContrib = [acctSimInfo.acctBal.overallBal.contribs yearlyTotal];
		[results.acctContribs setResultForInput:acctSimInfo.account andValue:acctContrib];
		sumAcctContrib += acctContrib;
		
		double acctWithdrawal = [acctSimInfo.acctBal.overallBal.withdrawals yearlyTotal];
		[results.acctWithdrawals setResultForInput:acctSimInfo.account andValue:acctWithdrawal];
		sumAcctWithdrawal += acctWithdrawal;
		
		double acctDividend = [acctSimInfo.dividendPayments yearlyTotal];
		[results.acctDividends setResultForInput:acctSimInfo.account andValue:acctDividend];
		sumAcctDividend += acctDividend;

		double acctCapGains = [acctSimInfo.acctBal.capitalGains yearlyTotal];
		[results.acctCapitalGains setResultForInput:acctSimInfo.account andValue:acctCapGains];
		sumAcctCapitalGains += acctCapGains;
		
		double acctCapLoss = [acctSimInfo.acctBal.capitalLosses yearlyTotal];
		[results.acctCapitalLoss setResultForInput:acctSimInfo.account andValue:acctCapLoss];
		sumAcctCapitalLoss += acctCapLoss;
		
		sumCashFlow += [acctSimInfo.dividendPayouts yearlyTotal];

	}
	results.sumAcctBal = sumAcctBal;
	results.sumAcctContrib = sumAcctContrib;
	results.sumAcctWithdrawal = sumAcctWithdrawal;
	results.sumAcctDividend = sumAcctDividend;
	results.sumAcctCapitalGains = sumAcctCapitalGains;
	results.sumAcctCapitalLoss = sumAcctCapitalLoss;
	
	NSArray *incomeSimInfos = [self.simParams.incomeInfo simInfos];
	double sumIncome = 0.0;
	for(IncomeSimInfo *incomeSimInfo  in incomeSimInfos)
	{
		double incomeAmt = [incomeSimInfo.digestSum yearlyTotal];
		[results.incomes setResultForInput:incomeSimInfo.income andValue:incomeAmt];
		sumIncome += incomeAmt;
	}
	results.sumIncomes = sumIncome;
	sumCashFlow += sumIncome;

	NSArray *expenseSimInfos = [self.simParams.expenseInfo simInfos];
	double sumExpense = 0.0;
	for(ExpenseSimInfo *expenseSimInfo  in expenseSimInfos)
	{
		double expenseAmt = [expenseSimInfo.digestSum yearlyTotal];
		[results.expenses setResultForInput:expenseSimInfo.expense andValue:expenseAmt];
		sumExpense += expenseAmt;
	}
	results.sumExpense = sumExpense;
	sumCashFlow -= sumExpense;
	
	results.cashBal = [self.simParams.workingBalanceMgr.cashWorkingBalance currentBalanceForDate:results.endDate];
	results.deficitBal = [self.simParams.workingBalanceMgr.deficitBalance currentBalanceForDate:results.endDate];
	
	assert(results.endDate != nil);
	assert([DateHelper dateIsEqualOrLater:results.endDate otherDate:self.simParams.simStartDate]);
	
	NSArray *taxInputCalcs = self.simParams.taxInputCalcs.taxInputCalcs;
	assert(taxInputCalcs != nil);
	double sumTaxesPaid = 0.0;
	for(TaxInputCalc *taxInputCalc in taxInputCalcs)
	{
		double taxesPaid = [taxInputCalc.taxesPaid yearlyTotal];
		[results.taxesPaid setResultForInput:taxInputCalc.taxInput andValue:taxesPaid];
		sumTaxesPaid += taxesPaid;
	}
	results.sumTaxesPaid = sumTaxesPaid;
	sumCashFlow -= sumTaxesPaid;
	
	
	results.cashFlow = sumCashFlow;
	
	double futureValueMultiplier = [self.adjustValueForInflationCalculator  
		valueMultiplierBetweenStartDate:self.simParams.simStartDate andEndDate:results.endDate];
	assert(futureValueMultiplier > 0.0);
	results.simStartDateValueMultiplier = 1.0/futureValueMultiplier; 


}
	
-(BOOL)fullYearSimulated
{
	if([DateHelper sameYear:self.simParams.simStartDate otherDate:self.currentYearDigestStartDate])
	{
		// First year of simulation
		if([DateHelper dateIsLater:self.simParams.simStartDate 
			otherDate:self.currentYearDigestStartDate])
		{
			return FALSE;
		}
		else 
		{
			return TRUE;
		}
	}
	else if([DateHelper sameYear:self.simParams.simEndDate 
		otherDate:self.currentYearDigestStartDate])
	{
		NSDate *endOfSimEndDate = [DateHelper endOfDay:self.simParams.simEndDate];
		if([DateHelper dateIsLater:[DateHelper endOfYear:self.simParams.simEndDate]
			otherDate:endOfSimEndDate])
		{
			return FALSE;
		}
		else 
		{
			return TRUE;
		}
		
	}
	else 
	{
		return TRUE;
	}
}

- (EndOfYearDigestResult*)processDigest
{
	
	[self.simParams.workingBalanceMgr resetCurrentBalances];
	NSDate *endOfYearDate = [DateHelper endOfYear:self.currentYearDigestStartDate];

	EndOfYearDigestResult *endOfYearResults = [[[EndOfYearDigestResult alloc] 
		initWithEndDate:endOfYearDate andFullYearSimulated:[self fullYearSimulated]] autorelease];
	
	NSDate *currentDate = self.currentYearDigestStartDate;
	
    // Setup a date for comparing for comparing against to stop the digest
    // processing for the current year. The method 'timeIntervalSinceDate' will
    // return < 0 while the currentDate has not advanced into the next year. This
    // turned out to be about 50% more efficient than using the DateHelper methods.
    NSDate *beginningOfNextDigestYear = [DateHelper beginningOfNextYear:self.currentYearDigestStartDate];
    
	int currDayIndex=0;
    while([currentDate timeIntervalSinceDate:beginningOfNextDigestYear] < 0)
	{
		// Advance all the balances through the current day. This ensures any outstanding
		// interest is accrued.
		[self.simParams.workingBalanceMgr advanceBalancesToDate:currentDate];

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

		// After processing all tax related digest entries (for incomes, expenses, 
		// asset sales, asset purchases, etc.), the tax payment is calculated
		// See the comments in TaxInputCalc.m for further explanation regarding
		// these dependencies.
		[self.simParams.taxInputCalcs processDailyTaxPmts:processingParams];

		currentDate = [DateHelper nextDay:currentDate];
		currDayIndex++;
		[processingParams release];
	}


	// Update the effective tax rates for the tax inputs. This needs to be done at the end of 
	// processing the digest, since all the InputValDigestSummation objects referenced by the
	// TaxInputCalcs will have been populated with income, interest, etc.
	// TBD - Should the date passed be the end this year, or the beginning of next year.
	NSDate *endOfYear = [DateHelper endOfYear:self.currentYearDigestStartDate];
	NSDate *beginningOfNextYear = [DateHelper beginningOfNextYear:self.currentYearDigestStartDate];
	[self.simParams.taxInputCalcs updateEffectiveTaxRates:beginningOfNextYear
		andLastDayOfTaxYear:endOfYear];
	

	endOfYearResults.totalEndOfYearBalance = 
		[self.simParams.workingBalanceMgr totalCurrentNetBalance:beginningOfNextYear];
	[self processEndOfYearInputResults:endOfYearResults];
	[endOfYearResults logResults];

	// Rewind the digest sums after processing end of year results, since
	// these digest sums are copied out to the results. Rewinding the digest
	// sums retains any interest which was carried over from the prior year.
	[self.simParams.digestSums rewindSumsToStartDate];


	return endOfYearResults;
}


- (EndOfYearDigestResult*)doMultiPassDigestCalcs
{


	//-------------------------------------------------------------------------------------
	// The first pass just processes and sums up the regular expenses, incomes, asset sales, etc. 
	// However, as this information can't be summed up until the end of the year, the
	// first pass includes an effectiveTaxRate of 0%. At the end of the first pass, the 
	// effectieTaxRates are updated to include this information.
	EndOfYearDigestResult *firstPassResults = [self processDigest];
    
    if(![self.simParams.taxInputCalcs taxesInputsExist])
    {
        // The only reason (at this time) of doing 3 passes of digest processing
        // is to support a heuristic for progressively updating the effective tax
        // rate for processing the daily tax payments (see [self processDigest])
        // So, if no taxes have been defined, the first pass results can be returned,
        // resulting in a performance improvement.
        return firstPassResults;
    }

	//-------------------------------------------------------------------------------------
	// In the second pass, an effectiveTaxRate based upon the sum of everything in the 
	// first pass is used. Since this does not include any taxes (remembe, effectiveTax
	// rate is 0 in the first pass), the taxes are a little bit low. However, the 
	// 2nd pass will pay taxes and possibly boost the taxable income, in the case
	// that tax payments cause a taxable withdrawal.
	[self processDigest];	
		
	//-------------------------------------------------------------------------------------
	// The third and final pass includes the effectiveTaxRate calculated in the 2nd pass
	// (including taxable withdrawals for taxes paid). 
	EndOfYearDigestResult *thirdPassResults = [self processDigest];
	
	return thirdPassResults;

}

- (void)advanceToNextYear
{
	NSLog(@"Advancing digest to next year from last year start = %@",
		[[DateHelper theHelper].mediumDateFormatter stringFromDate:self.currentYearDigestStartDate]);

	// Carry the balances forward from the prior year to the current. This
	// will have the result of adding any interest from December 31st to
	// the January 1st digest entry. We "snapshot" the digest sums after
	// calculating this interest, so with multiple passes of digest calculations,
	// we can rewind to the digest sums which include any interest carried over
	// from 12/31 in the prior year.
	[self.simParams.workingBalanceMgr carryBalancesForward:self.currentYearDigestStartDate];
	[self.simParams.digestSums snapshotSumsAtStartDate];

	EndOfYearDigestResult *endOfYearResults = [self doMultiPassDigestCalcs];
	assert(endOfYearResults != nil);
	[self.savedEndOfYearResults addObject:endOfYearResults];

	// Advance the digest to the next year
	self.currentYearDigestStartDate = [DateHelper beginningOfNextYear:self.currentYearDigestStartDate];
	[self.digestEntries resetEntriesAndAdvanceStartDate:self.currentYearDigestStartDate];
		[self.simParams.digestSums resetSums];


}

- (id) init
{
	assert(0); // must call init method above
}

- (void) dealloc
{
	[digestEntries release];
	[currentYearDigestStartDate release];
	[savedEndOfYearResults release];
	[simParams release];
	[adjustValueForInflationCalculator release];
	[super dealloc];
}

@end
