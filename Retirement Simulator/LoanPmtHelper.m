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

@end
