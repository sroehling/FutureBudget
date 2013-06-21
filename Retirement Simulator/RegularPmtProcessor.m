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

@implementation RegularPmtProcessor

-(void)processPmtForLoanInfo:(LoanSimInfo*)loanInfo andProcessingParams:(DigestEntryProcessingParams*)processingParams
{

	NSDate *pmtDate = processingParams.currentDate;

	double actualPmtAmt = [loanInfo.loanBalance decrementPeriodicPaymentOnDate:pmtDate
		withExtraPmtAmount:[loanInfo extraPmtAmountAsOfDate:pmtDate]];
			
	[processingParams.workingBalanceMgr decrementBalanceFromFundingList:actualPmtAmt 
				asOfDate:pmtDate];
	
	
}

@end
