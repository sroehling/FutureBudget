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
#import "PeriodicInterestBearingWorkingBalance.h"
#import "DigestEntryProcessingParams.h"
#import "LoanPmtHelper.h"

@implementation FirstDeferredPmtProcessor


-(void)processPmtForLoanInfo:(LoanSimInfo*)loanInfo andProcessingParams:(DigestEntryProcessingParams*)processingParams
{

	NSDate *paymentDate = processingParams.currentDate;
	
	// Use the balance leading into the first payment to calculate the monthly payment.
	// This happens before adding on the interst for the month leading into the first payment
	// (via advanceCurrentBalanceToNextPeriodOnDate).
	// The first payment calculator has the side effect of updating the current monthly
	// payment for the loan, based upon the current loan balance.
	[loanInfo.loanBalance advanceCurrentBalanceToDate:paymentDate];

	double balanceAsOfFirstPaymentDate = [loanInfo.loanBalance currentBalanceForDate:paymentDate];
	assert(balanceAsOfFirstPaymentDate >= 0.0);

	loanInfo.currentMonthlyPayment = [loanInfo monthlyPaymentForPmtCalcDate:paymentDate
		andStartingBal:balanceAsOfFirstPaymentDate];


	[loanInfo.loanBalance advanceCurrentBalanceToNextPeriodOnDate:processingParams.currentDate];

	// The first deferred payment is handled as a "regular payment" and includes interest
	// from the month leading into the first payment, and extra payments if any. In other words,
	// if interest payments are subsidized or not payed under deferment, they are not
	// subsidized with the first payment.
		
	[LoanPmtHelper decrementLoanPayment:[loanInfo totalMonthlyPmtAsOfDate:paymentDate]
		forLoanInfo:loanInfo andProcessingParams:processingParams];
	
}

@end
