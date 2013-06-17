//
//  NoPaymentAmtCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/22/13.
//
//

#import "NoPmtProcessor.h"
#import "PeriodicInterestBearingWorkingBalance.h"
#import "DigestEntryProcessingParams.h"
#import "LoanSimInfo.h"
#import "LoanPmtHelper.h"

@implementation NoPmtProcessor

-(void)processPmtForLoanInfo:(LoanSimInfo*)loanInfo andProcessingParams:(DigestEntryProcessingParams*)processingParams
{
	NSDate *pmtDate = processingParams.currentDate;

	// This payment processor is used when a loan is in deferrment. The balance needs to be moved forward, so
	// that interest can be added to the loan balance, but otherwise the payment is not deducted from
	// the loan's balance.
	[loanInfo.loanBalance advanceCurrentBalanceToNextPeriodOnDate:pmtDate];
	
	
	// Even if the loan is in deferment, extra payments can be made. This support scenarios where
	// a little bit of money will be paid on the principle each month, even if a full interest
	// and/or principle payment is not made.
	[LoanPmtHelper decrementLoanPayment:[loanInfo extraPmtAmountAsOfDate:pmtDate]
		forLoanInfo:loanInfo andProcessingParams:processingParams];


}


@end
