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
#import "WorkingBalanceMgr.h"

@implementation FirstDeferredPmtProcessor


-(void)processPmtForLoanInfo:(LoanSimInfo*)loanInfo andProcessingParams:(DigestEntryProcessingParams*)processingParams
{

	NSDate *paymentDate = processingParams.currentDate;
	
	double actualPmtAmt = [loanInfo.loanBalance decrementFirstNonDeferredPeriodicPaymentOnDate:paymentDate
			withExtraPmtAmount:[loanInfo extraPmtAmountAsOfDate:paymentDate]];

	// The first deferred payment is handled as a "regular payment" and includes interest
	// from the month leading into the first payment, and extra payments if any. In other words,
	// if interest payments are subsidized or not payed under deferment, they are not
	// subsidized with the first payment.
	
	[processingParams.workingBalanceMgr decrementBalanceFromFundingList:actualPmtAmt 
				asOfDate:paymentDate];
}

@end
