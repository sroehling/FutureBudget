//
//  InterestOnlyPaymentAmtCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/21/13.
//
//

#import "InterestOnlyPmtProcessor.h"
#import "LoanSimInfo.h"
#import "PeriodicInterestBearingWorkingBalance.h"
#import "LoanPmtHelper.h"
#import "DigestEntryProcessingParams.h"
#import "WorkingBalanceMgr.h"
#import "PeriodicInterestPaymentResult.h"

@implementation InterestOnlyPmtProcessor

-(id)initWithSubsidizedInterestPayment:(BOOL)doSubsidizePayment
{
	self = [super init];
	if(self)
	{
		subsizePayment = doSubsidizePayment;
	}
	return self;
}

-(id)init
{
	assert(0);
	return nil;
}


-(void)processPmtForLoanInfo:(LoanSimInfo*)loanInfo andProcessingParams:(DigestEntryProcessingParams*)processingParams
{
	NSDate *pmtDate = processingParams.currentDate;
		
	PeriodicInterestPaymentResult *pmtResult = [loanInfo.loanBalance decrementInterestOnlyPaymentOnDate:pmtDate
			withExtraPmtAmount:[loanInfo extraPmtAmountAsOfDate:pmtDate]];
			
	if((!subsizePayment) && (pmtResult.interestPaid > 0.0))
	{
		// If the payment is subsidized, the balance of payment doesn't come out
		// of the list of accounts, but instead is assumped to be paid by
		// someone else. This is a special case for subsidized stafford school loans.
		[processingParams.workingBalanceMgr decrementBalanceFromFundingList:pmtResult.interestPaid 
				asOfDate:processingParams.currentDate];
	}

	// Even if the loan is in deferment, extra payments can be made. This supports scenarios where
	// a little bit of money will be paid on the principle each month, even if a full interest
	// and/or principle payment is not made.
	//
	// Note: this portion of the payment needs to be processed separately from the interest only payment,
	// since the interest only payment may be subsidized, while the extra payment is not.
	if(pmtResult.extraPaymentPaid > 0.0)
	{
		[processingParams.workingBalanceMgr decrementBalanceFromFundingList:pmtResult.extraPaymentPaid 
				asOfDate:processingParams.currentDate];
	}

	

}


@end
