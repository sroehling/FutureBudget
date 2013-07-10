//
//  RegularPaymentAmtCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/21/13.
//
//

#import "RegularPmtProcessor.h"
#import "LoanSimInfo.h"
#import "LoanPmtHelper.h"
#import "PeriodicInterestBearingWorkingBalance.h"
#import "DigestEntryProcessingParams.h"
#import "WorkingBalanceMgr.h"
#import "InputValDigestSummation.h"

@implementation RegularPmtProcessor

-(void)processPmtForLoanInfo:(LoanSimInfo*)loanInfo andProcessingParams:(DigestEntryProcessingParams*)processingParams
{

	NSDate *pmtDate = processingParams.currentDate;

	double actualPmtAmt = [loanInfo.loanBalance decrementPeriodicPaymentOnDate:pmtDate
		withExtraPmtAmount:[loanInfo extraPmtAmountAsOfDate:pmtDate]];
		
	// Track payment amounts as an expense, for keeping a summation of overall cash flow
	[loanInfo.paymentSum adjustSum:actualPmtAmt onDay:processingParams.dayIndex];
			
	[processingParams.workingBalanceMgr decrementBalanceFromFundingList:actualPmtAmt 
				asOfDate:pmtDate];
	
	
}

@end
