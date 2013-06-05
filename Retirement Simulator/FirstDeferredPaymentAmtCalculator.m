//
//  FirstDeferredPaymentAmtCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/13.
//
//

#import "FirstDeferredPaymentAmtCalculator.h"
#import "InterestOnlyPaymentAmtCalculator.h"
#import "LoanSimInfo.h"
#import "InterestBearingWorkingBalance.h"

@implementation FirstDeferredPaymentAmtCalculator

-(double)paymentAmtForLoanInfo:(LoanSimInfo*)loanInfo andPmtDate:(NSDate*)paymentDate
{

	// The first payment calculator has the side effect of updating the current monthly
	// payment for the loan, based upon the current loan balance.
	[loanInfo.loanBalance advanceCurrentBalanceToDate:paymentDate];


	double lastInterestPayment = 0.0;
	if([loanInfo deferredPaymentPayInterestWhileInDeferrment])
	{
		InterestOnlyPaymentAmtCalculator *interestPaymentForLastTimeIncrementBeforeFirstDeferredPayment
			= [[[InterestOnlyPaymentAmtCalculator alloc]
					initWithSubsidizedInterestPayment:FALSE] autorelease];
		lastInterestPayment =
			[interestPaymentForLastTimeIncrementBeforeFirstDeferredPayment paymentAmtForLoanInfo:loanInfo andPmtDate:paymentDate];
		
	}

	double balanceAsOfFirstPaymentDate = [loanInfo.loanBalance currentBalanceForDate:paymentDate];
	double balanceForCalculatingFirstPayment = balanceAsOfFirstPaymentDate - lastInterestPayment;
	assert(balanceAsOfFirstPaymentDate >= 0.0);

	loanInfo.currentMonthlyPayment = [loanInfo monthlyPaymentForPmtCalcDate:paymentDate
		andStartingBal:balanceForCalculatingFirstPayment];

	return loanInfo.currentMonthlyPayment + lastInterestPayment;
}

-(BOOL)paymentIsSubsized
{
	return FALSE;
}


@end
