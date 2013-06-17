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

	double interestPmtAmount = [loanInfo.loanBalance advanceCurrentBalanceToNextPeriodOnDate:pmtDate];

	[LoanPmtHelper decrementLoanPayment:interestPmtAmount forLoanInfo:loanInfo
		andProcessingParams:processingParams andSubsidizedPmt:subsizePayment];
		
	// Even if the loan is in deferment, extra payments can be made. This supports scenarios where
	// a little bit of money will be paid on the principle each month, even if a full interest
	// and/or principle payment is not made.
	//
	// Note: this portion of the payment needs to be processed separately from the interest only payment,
	// since the interest only payment may be subsidized, while the extra payment is not.
	[LoanPmtHelper decrementLoanPayment:[loanInfo extraPmtAmountAsOfDate:pmtDate]
		forLoanInfo:loanInfo andProcessingParams:processingParams];
	

}


@end
