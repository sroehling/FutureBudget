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

@implementation RegularPmtProcessor

-(void)processPmtForLoanInfo:(LoanSimInfo*)loanInfo andProcessingParams:(DigestEntryProcessingParams*)processingParams
{

	NSDate *pmtDate = processingParams.currentDate;

	[loanInfo.loanBalance advanceCurrentBalanceToNextPeriodOnDate:pmtDate];
	
	[LoanPmtHelper decrementLoanPayment:[loanInfo totalMonthlyPmtAsOfDate:pmtDate]
		forLoanInfo:loanInfo andProcessingParams:processingParams];
}

@end
