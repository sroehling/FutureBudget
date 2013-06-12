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



-(double)paymentAmtForLoanInfo:(LoanSimInfo*)loanInfo andPmtDate:(NSDate*)paymentDate
{
	// Advance the balance to accrue any interest.
	[loanInfo.loanBalance advanceCurrentBalanceToDate:paymentDate];
	
	double currBalance = [loanInfo.loanBalance currentBalanceForDate:paymentDate];
	
	double startingBal = [loanInfo startingBalanceAfterDownPayment];
	
	
	if(currBalance > startingBal)
	{
		double unpaidInterest = currBalance - startingBal;
		return unpaidInterest;
	}
	else
	{
		return 0.0;
	}
	
}

-(void)processPmtForLoanInfo:(LoanSimInfo*)loanInfo andProcessingParams:(DigestEntryProcessingParams*)processingParams
{
	[loanInfo.loanBalance advanceCurrentBalanceToNextPeriodOnDate:processingParams.currentDate];

	double pmtAmount = [self paymentAmtForLoanInfo:loanInfo andPmtDate:processingParams.currentDate];

	[LoanPmtHelper decrementLoanPayment:pmtAmount forLoanInfo:loanInfo
		andProcessingParams:processingParams andSubsidizedPmt:subsizePayment];

}


@end
