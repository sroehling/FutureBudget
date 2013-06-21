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
#import "WorkingBalanceMgr.h"

@implementation NoPmtProcessor

-(void)processPmtForLoanInfo:(LoanSimInfo*)loanInfo andProcessingParams:(DigestEntryProcessingParams*)processingParams
{
	NSDate *pmtDate = processingParams.currentDate;
	
	double actualExtraPmt = [loanInfo.loanBalance skippedPaymentOnDate:pmtDate
		withExtraPmtAmount:[loanInfo extraPmtAmountAsOfDate:pmtDate]];
		
	if(actualExtraPmt > 0.0)
	{
		[processingParams.workingBalanceMgr decrementBalanceFromFundingList:actualExtraPmt 
				asOfDate:pmtDate];
	}

}


@end
