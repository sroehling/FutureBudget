//
//  LoanPmtHelper.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/4/13.
//
//

#import "LoanPmtHelper.h"
#import "LoanSimInfo.h"
#import "DigestEntryProcessingParams.h"
#import "InterestBearingWorkingBalance.h"
#import "WorkingBalanceMgr.h"

CGFloat const LOAN_PMT_PERIODS_PER_YEAR = 12.0;

@implementation LoanPmtHelper

+(void)decrementLoanPayment:(double)pmtAmt forLoanInfo:(LoanSimInfo*)loanInfo
	andProcessingParams:(DigestEntryProcessingParams*)processingParams andSubsidizedPmt:(BOOL)paymentIsSubsidized
{
	if(pmtAmt > 0.0)
	{
		double balancePaid = [loanInfo.loanBalance decrementAvailableBalanceForNonExpense:pmtAmt
			asOfDate:processingParams.currentDate];
			
		if(!paymentIsSubsidized)
		{
			// If the payment is subsidized, the balance of payment doesn't come out
			// of the list of accounts, but instead is assumped to be paid by
			// someone else. This is a special case for subsidized stafford school loans.
			[processingParams.workingBalanceMgr decrementBalanceFromFundingList:balancePaid 
				asOfDate:processingParams.currentDate];
		}
	}

}

+(void)decrementLoanPayment:(double)pmtAmt forLoanInfo:(LoanSimInfo*)loanInfo
	andProcessingParams:(DigestEntryProcessingParams*)processingParams
{
	[LoanPmtHelper decrementLoanPayment:pmtAmt forLoanInfo:loanInfo
		andProcessingParams:processingParams andSubsidizedPmt:FALSE];
}

+(double)monthlyPeriodicLoanInterestRate:(double)annualRateEnteredByUser;
{
	assert(annualRateEnteredByUser >= 0.0);
	double unadjustedAnnualRate = annualRateEnteredByUser/100.0;
	double monthlyPeriodicRate = unadjustedAnnualRate / LOAN_PMT_PERIODS_PER_YEAR;
	
	return monthlyPeriodicRate;

}

+(double)annualizedPeriodicLoanInterestRate:(double)annualRateEnteredByUser
{
	// The conventional way (at least what is seen in on-line loan calculators
	// and Excel) to calculate the interest rate for a loan is to divide the 
	// annual rate by 12, then take that as the actual interest over the period.
	// However, this value, when compounded annually, is slightly more than the 
	// given as an input for the yearly rate.


	double monthlyPeriodicRate = [LoanPmtHelper monthlyPeriodicLoanInterestRate:annualRateEnteredByUser];
	double adjustedAnnualRate = pow(1.0+monthlyPeriodicRate, LOAN_PMT_PERIODS_PER_YEAR)-1.0;

	return adjustedAnnualRate;
}

@end
