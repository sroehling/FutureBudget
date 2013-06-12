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

@implementation NoPmtProcessor

-(void)processPmtForLoanInfo:(LoanSimInfo*)loanInfo andProcessingParams:(DigestEntryProcessingParams*)processingParams
{
	// This payment processor is used when a loan is in deferrment. The balance needs to be moved forward, so
	// that interest can be added to the loan balance, but otherwise the payment is not deducted from
	// the loan's balance.
	[loanInfo.loanBalance advanceCurrentBalanceToNextPeriodOnDate:processingParams.currentDate];

}


@end
