//
//  FirstDeferredPaymentAmtCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 6/3/13.
//
//

#import "FirstDeferredPaymentAmtCalculator.h"
#import "LoanSimInfo.h"
#import "InterestBearingWorkingBalance.h"

@implementation FirstDeferredPaymentAmtCalculator

-(double)paymentAmtForLoanInfo:(LoanSimInfo*)loanInfo andPmtDate:(NSDate*)paymentDate
{

	// The first payment calculator has the side effect of updating the current monthly
	// payment for the loan, based upon the current loan balance.
	[loanInfo.loanBalance advanceCurrentBalanceToDate:paymentDate];
	double balanceAsOfFirstPaymentDate = [loanInfo.loanBalance currentBalanceForDate:paymentDate];
	loanInfo.currentMonthlyPayment = [loanInfo monthlyPaymentForPmtCalcDate:paymentDate
		andStartingBal:balanceAsOfFirstPaymentDate];

	return loanInfo.currentMonthlyPayment;
}

-(BOOL)paymentIsSubsized
{
	return FALSE;
}


@end
