//
//  FirstDeferredPaymentAmtCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/13.
//
//

#import "FirstDeferredPmtProcessor.h"
#import "InterestOnlyPmtProcessor.h"
#import "LoanSimInfo.h"
#import "InterestBearingWorkingBalance.h"
#import "DigestEntryProcessingParams.h"
#import "LoanPmtHelper.h"

@implementation FirstDeferredPmtProcessor


-(void)processPmtForLoanInfo:(LoanSimInfo*)loanInfo andProcessingParams:(DigestEntryProcessingParams*)processingParams
{

	NSDate *paymentDate = processingParams.currentDate;
	
	// The first payment calculator has the side effect of updating the current monthly
	// payment for the loan, based upon the current loan balance.
	[loanInfo.loanBalance advanceCurrentBalanceToDate:paymentDate];

	if([loanInfo deferredPaymentPayInterestWhileInDeferrment])
	{
		InterestOnlyPmtProcessor *interestPaymentForLastTimeIncrementBeforeFirstDeferredPayment
			= [[[InterestOnlyPmtProcessor alloc]
					initWithSubsidizedInterestPayment:[loanInfo deferredPaymentInterestSubsidized]] autorelease];
		[interestPaymentForLastTimeIncrementBeforeFirstDeferredPayment
			processPmtForLoanInfo:loanInfo andProcessingParams:processingParams];
	}
		
	double balanceAsOfFirstPaymentDate = [loanInfo.loanBalance currentBalanceForDate:paymentDate];
	assert(balanceAsOfFirstPaymentDate >= 0.0);

	loanInfo.currentMonthlyPayment = [loanInfo monthlyPaymentForPmtCalcDate:paymentDate
		andStartingBal:balanceAsOfFirstPaymentDate];
		
	[LoanPmtHelper decrementLoanPayment:loanInfo.currentMonthlyPayment
		forLoanInfo:loanInfo andProcessingParams:processingParams];
	
}

@end
