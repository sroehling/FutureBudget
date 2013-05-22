//
//  InterestOnlyPaymentAmtCalculator.m
//  Retirement Simulator
//
//  Created by Steve Roehling on 5/21/13.
//
//

#import "InterestOnlyPaymentAmtCalculator.h"
#import "LoanSimInfo.h"
#import "InterestBearingWorkingBalance.h"

@implementation InterestOnlyPaymentAmtCalculator

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

-(BOOL)paymentIsSubsized
{
	return subsizePayment;
}

@end
